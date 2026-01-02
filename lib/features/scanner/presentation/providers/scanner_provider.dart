import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:bluetooth_finder/core/services/location_service.dart';
import 'package:bluetooth_finder/features/scanner/data/models/bluetooth_device_model.dart';
import 'package:bluetooth_finder/features/scanner/data/repositories/bluetooth_repository.dart';
import 'package:bluetooth_finder/features/favorites/presentation/providers/favorites_provider.dart';

final bluetoothAdapterStateProvider = StreamProvider<BluetoothAdapterState>((
  ref,
) {
  return FlutterBluePlus.adapterState;
});

final bluetoothRepositoryProvider = Provider<BluetoothRepository>((ref) {
  final repo = BluetoothRepository();
  ref.onDispose(() => repo.dispose());
  return repo;
});

final isScanningProvider = StateProvider<bool>((ref) => false);

final devicesStreamProvider = StreamProvider<List<BluetoothDeviceModel>>((ref) {
  final repo = ref.watch(bluetoothRepositoryProvider);
  return repo.devicesStream;
});

final selectedDeviceProvider = StateProvider<BluetoothDeviceModel?>(
  (ref) => null,
);

/// Toggle to show/hide unnamed devices
final showUnnamedDevicesProvider = StateProvider<bool>((ref) => false);

final deviceRssiStreamProvider = StreamProvider.family<int, String>((
  ref,
  deviceId,
) {
  final repo = ref.watch(bluetoothRepositoryProvider);
  return repo.getRssiStream(deviceId);
});

/// Real-time RSSI stream for radar (no debouncing, updates immediately)
final radarRssiStreamProvider = StreamProvider.family<int, String>((
  ref,
  deviceId,
) {
  final repo = ref.watch(bluetoothRepositoryProvider);
  final deviceIdUpper = deviceId.toUpperCase();
  return repo.rssiStream
      .where(
        (rssiMap) => rssiMap.keys.any((k) => k.toUpperCase() == deviceIdUpper),
      )
      .map((rssiMap) {
        final key = rssiMap.keys.firstWhere(
          (k) => k.toUpperCase() == deviceIdUpper,
        );
        return rssiMap[key]!;
      });
});

/// Convert RSSI to bucket for stable sorting (avoids jumping on small changes)
int _rssiBucket(int rssi) {
  if (rssi >= -50) return 4; // Very close
  if (rssi >= -65) return 3; // Close
  if (rssi >= -80) return 2; // Medium
  if (rssi >= -90) return 1; // Far
  return 0; // Very far
}

/// All devices sorted by proximity (RSSI bucket), then name
/// Filters based on user preferences
final allDevicesProvider = Provider<List<BluetoothDeviceModel>>((ref) {
  final devicesAsync = ref.watch(devicesStreamProvider);
  final showUnnamed = ref.watch(showUnnamedDevicesProvider);

  return devicesAsync.when(
    data: (devices) {
      // Filter based on preferences
      final filtered = devices.where((d) {
        // Hide unnamed devices unless toggle is on
        if (!showUnnamed && d.name.isEmpty) return false;
        // Hide very weak signals (too far away to be useful)
        if (d.rssi < -95) return false;
        return true;
      }).toList();

      // Sort by RSSI bucket (stable), then name, then ID
      filtered.sort((a, b) {
        final bucketA = _rssiBucket(a.rssi);
        final bucketB = _rssiBucket(b.rssi);
        if (bucketA != bucketB) return bucketB.compareTo(bucketA);
        // Within same bucket, sort by name
        final nameCompare = a.name.compareTo(b.name);
        if (nameCompare != 0) return nameCompare;
        return a.id.compareTo(b.id);
      });
      return filtered;
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

/// Keep these for backwards compatibility but they're not used in the new UI
final myDevicesProvider = Provider<List<BluetoothDeviceModel>>((ref) => []);
final nearbyDevicesProvider = Provider<List<BluetoothDeviceModel>>((ref) => []);

/// Tracks when each favorite device was last updated to avoid excessive geocoding.
/// Key: device ID (uppercase), Value: last update timestamp
final _lastUpdateTimes = <String, DateTime>{};

/// Tracks when the last batch location fetch occurred.
DateTime? _lastBatchLocationTime;

/// Minimum interval between location updates for the same device.
/// This prevents excessive reverse geocoding API calls.
const _minUpdateInterval = Duration(minutes: 5);

/// Minimum interval between batch location fetches.
/// Even with LocationService caching, we avoid calling it too frequently.
const _minBatchLocationInterval = Duration(seconds: 30);

/// Auto-updates favorite devices when they are scanned.
/// This provider should be watched by the scanner screen to activate it.
///
/// Two-tier update strategy:
/// 1. Always update lastSeenAt for all found favorites (keeps widget fresh)
/// 2. Rate-limit location updates to avoid geocoding throttling
final favoriteLocationUpdaterProvider = Provider<void>((ref) {
  final devicesAsync = ref.watch(devicesStreamProvider);
  final favoriteIds = ref.watch(favoriteIdsSetProvider);
  final favoritesNotifier = ref.read(favoritesProvider.notifier);
  final locationService = ref.read(locationServiceProvider);

  devicesAsync.whenData((devices) async {
    final now = DateTime.now();

    // Find ALL favorites currently visible in scan
    final allFoundFavorites = <BluetoothDeviceModel>[];
    // Find favorites that need LOCATION update (rate-limited)
    final devicesNeedingLocation = <BluetoothDeviceModel>[];

    for (final device in devices) {
      final deviceIdUpper = device.id.toUpperCase();
      if (favoriteIds.any((id) => id.toUpperCase() == deviceIdUpper)) {
        allFoundFavorites.add(device);

        // Check if this device needs a location update
        final lastUpdate = _lastUpdateTimes[deviceIdUpper];
        if (lastUpdate == null ||
            now.difference(lastUpdate) >= _minUpdateInterval) {
          _lastUpdateTimes[deviceIdUpper] = now;
          devicesNeedingLocation.add(device);
        }
      }
    }

    // Always update lastSeenAt for ALL found favorites (no rate limit)
    if (allFoundFavorites.isNotEmpty) {
      await favoritesNotifier.updateManyLastSeen(allFoundFavorites);
    }

    // Rate limit location fetches (expensive geocoding)
    if (devicesNeedingLocation.isEmpty) return;
    if (_lastBatchLocationTime != null &&
        now.difference(_lastBatchLocationTime!) < _minBatchLocationInterval) {
      return;
    }
    _lastBatchLocationTime = now;

    // Get location ONCE for all devices (batched - 1 geocode instead of N)
    final location = await locationService.getCurrentLocationWithName();

    // Update devices with location
    await favoritesNotifier.updateManyFromScanWithLocation(
      devicesNeedingLocation,
      location,
    );
  });
});
