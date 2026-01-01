import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:bluetooth_finder/features/scanner/data/models/bluetooth_device_model.dart';
import 'package:bluetooth_finder/features/scanner/data/repositories/bluetooth_repository.dart';

final bluetoothAdapterStateProvider = StreamProvider<BluetoothAdapterState>((ref) {
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

final selectedDeviceProvider = StateProvider<BluetoothDeviceModel?>((ref) => null);

/// Toggle to show/hide unnamed devices
final showUnnamedDevicesProvider = StateProvider<bool>((ref) => false);

final deviceRssiStreamProvider = StreamProvider.family<int, String>((ref, deviceId) {
  final repo = ref.watch(bluetoothRepositoryProvider);
  return repo.getRssiStream(deviceId);
});

/// Real-time RSSI stream for radar (no debouncing, updates immediately)
final radarRssiStreamProvider = StreamProvider.family<int, String>((ref, deviceId) {
  final repo = ref.watch(bluetoothRepositoryProvider);
  final deviceIdUpper = deviceId.toUpperCase();
  return repo.rssiStream
      .where((rssiMap) => rssiMap.keys.any((k) => k.toUpperCase() == deviceIdUpper))
      .map((rssiMap) {
        final key = rssiMap.keys.firstWhere((k) => k.toUpperCase() == deviceIdUpper);
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
        if (!showUnnamed && d.name == 'Appareil inconnu') return false;
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
