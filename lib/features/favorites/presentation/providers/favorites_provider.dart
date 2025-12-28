import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bluetooth_finder/features/favorites/data/models/favorite_device_model.dart';
import 'package:bluetooth_finder/features/favorites/data/repositories/favorites_repository.dart';
import 'package:bluetooth_finder/features/scanner/data/models/bluetooth_device_model.dart';

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  return FavoritesRepository();
});

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<FavoriteDeviceModel>>((ref) {
  final repo = ref.watch(favoritesRepositoryProvider);
  return FavoritesNotifier(repo);
});

class FavoritesNotifier extends StateNotifier<List<FavoriteDeviceModel>> {
  final FavoritesRepository _repo;

  FavoritesNotifier(this._repo) : super([]) {
    _loadFavorites();
  }

  void _loadFavorites() {
    state = _repo.getAll();
  }

  bool isFavorite(String deviceId) => _repo.isFavorite(deviceId);

  Future<void> toggleFavorite(BluetoothDeviceModel device) async {
    await _repo.toggleFavorite(device);
    _loadFavorites();
  }

  Future<void> removeFavorite(String deviceId) async {
    await _repo.removeFavorite(deviceId);
    _loadFavorites();
  }

  Future<void> updateFromScan(BluetoothDeviceModel device) async {
    await _repo.updateFromScan(device);
    _loadFavorites();
  }
}

final isFavoriteProvider = Provider.family<bool, String>((ref, deviceId) {
  final favorites = ref.watch(favoritesProvider);
  return favorites.any((f) => f.id == deviceId);
});
