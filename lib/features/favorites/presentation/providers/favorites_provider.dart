import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bluetooth_finder/features/favorites/data/models/favorite_device_model.dart';
import 'package:bluetooth_finder/features/favorites/data/repositories/favorites_repository.dart';
import 'package:bluetooth_finder/features/scanner/data/models/bluetooth_device_model.dart';

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  return FavoritesRepository.instance;
});

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<FavoriteDeviceModel>>((ref) {
  final repo = ref.watch(favoritesRepositoryProvider);
  return FavoritesNotifier(repo);
});

class FavoritesNotifier extends StateNotifier<List<FavoriteDeviceModel>> {
  final FavoritesRepository _repo;

  FavoritesNotifier(this._repo) : super(_repo.getAll());

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

  Future<void> updateFromScan(BluetoothDeviceModel device) async {
    await _repo.updateFromScan(device);
    _refresh();
  }
}

/// Optimized cached set of favorite IDs for O(1) lookups
final favoriteIdsSetProvider = Provider<Set<String>>((ref) {
  final favorites = ref.watch(favoritesProvider);
  return favorites.map((f) => f.id).toSet();
});

/// Efficient O(1) lookup for checking if a device is a favorite
final isFavoriteProvider = Provider.family<bool, String>((ref, deviceId) {
  final favoriteIds = ref.watch(favoriteIdsSetProvider);
  return favoriteIds.contains(deviceId);
});
