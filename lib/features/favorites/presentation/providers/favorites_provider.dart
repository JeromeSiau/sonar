import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bluetooth_finder/core/services/location_service.dart';
import 'package:bluetooth_finder/features/favorites/data/models/favorite_device_model.dart';
import 'package:bluetooth_finder/features/favorites/data/repositories/favorites_repository.dart';
import 'package:bluetooth_finder/features/scanner/data/models/bluetooth_device_model.dart';

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  return FavoritesRepository.instance;
});

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, List<FavoriteDeviceModel>>((ref) {
      final repo = ref.watch(favoritesRepositoryProvider);
      final locationService = ref.watch(locationServiceProvider);
      return FavoritesNotifier(repo, locationService);
    });

class FavoritesNotifier extends StateNotifier<List<FavoriteDeviceModel>> {
  final FavoritesRepository _repo;
  final LocationService _locationService;

  FavoritesNotifier(this._repo, this._locationService) : super(_repo.getAll());

  void _refresh() {
    state = _repo.getAll();
  }

  bool isFavorite(String deviceId) => _repo.isFavorite(deviceId);

  Future<void> toggleFavorite(BluetoothDeviceModel device) async {
    await _repo.toggleFavorite(device);
    _refresh();
  }

  Future<void> removeFavorite(String deviceId) async {
    await _repo.removeFavorite(deviceId);
    _refresh();
  }

  /// Updates a favorite from scan data, capturing current GPS location.
  Future<void> updateFromScan(BluetoothDeviceModel device) async {
    // Get current location (non-blocking, returns null if unavailable)
    final location = await _locationService.getCurrentLocationWithName();

    await _repo.updateFromScan(
      device,
      latitude: location?.latitude,
      longitude: location?.longitude,
      locationName: location?.placeName,
    );
    _refresh();
  }

  /// Updates multiple favorites from scan data with a pre-fetched location.
  /// This is more efficient than calling updateFromScan for each device,
  /// as it avoids N geocoding calls (only 1 is needed).
  Future<void> updateManyFromScanWithLocation(
    List<BluetoothDeviceModel> devices,
    LocationData? location,
  ) async {
    for (final device in devices) {
      await _repo.updateFromScan(
        device,
        latitude: location?.latitude,
        longitude: location?.longitude,
        locationName: location?.placeName,
      );
    }
    _refresh();
  }

  /// Updates only lastSeenAt for multiple devices (no location fetch).
  /// Used for frequent scan updates to keep lastSeen fresh.
  Future<void> updateManyLastSeen(List<BluetoothDeviceModel> devices) async {
    for (final device in devices) {
      await _repo.updateLastSeen(device.id, device.lastSeen);
    }
    _refresh();
  }
}

/// Optimized cached set of favorite IDs for efficient O(1) lookups.
///
/// Performance optimization: This provider caches the Set of favorite device IDs
/// so that multiple providers can perform O(1) contains() checks without
/// recreating the Set on every access. This is significantly more efficient than
/// calling favorites.any() which is O(n) linear search.
///
/// Used by: myDevicesProvider, nearbyDevicesProvider, isFavoriteProvider
final favoriteIdsSetProvider = Provider<Set<String>>((ref) {
  final favorites = ref.watch(favoritesProvider);
  return favorites.map((f) => f.id).toSet();
});

/// Efficient O(1) lookup for checking if a device is a favorite.
///
/// Performance: Uses Set.contains() which is O(1) instead of List.any() which is O(n).
final isFavoriteProvider = Provider.family<bool, String>((ref, deviceId) {
  final favoriteIds = ref.watch(favoriteIdsSetProvider);
  return favoriteIds.contains(deviceId);
});

final favoriteByIdProvider = Provider.family<FavoriteDeviceModel?, String>((
  ref,
  deviceId,
) {
  final favorites = ref.watch(favoritesProvider);
  try {
    return favorites.firstWhere((f) => f.id == deviceId);
  } catch (_) {
    return null;
  }
});
