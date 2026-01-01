import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bluetooth_finder/core/services/location_service.dart';
import 'package:bluetooth_finder/features/favorites/data/models/favorite_device_model.dart';
import 'package:bluetooth_finder/features/favorites/data/repositories/favorites_repository.dart';
import 'package:bluetooth_finder/features/scanner/data/models/bluetooth_device_model.dart';

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  return FavoritesRepository.instance;
});

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<FavoriteDeviceModel>>((ref) {
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
}

final isFavoriteProvider = Provider.family<bool, String>((ref, deviceId) {
  final favorites = ref.watch(favoritesProvider);
  return favorites.any((f) => f.id == deviceId);
});

final favoriteByIdProvider = Provider.family<FavoriteDeviceModel?, String>((ref, deviceId) {
  final favorites = ref.watch(favoritesProvider);
  try {
    return favorites.firstWhere((f) => f.id == deviceId);
  } catch (_) {
    return null;
  }
});
