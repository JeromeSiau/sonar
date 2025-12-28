import 'package:hive_flutter/hive_flutter.dart';
import 'package:bluetooth_finder/features/favorites/data/models/favorite_device_model.dart';
import 'package:bluetooth_finder/features/scanner/data/models/bluetooth_device_model.dart';

class FavoritesRepository {
  static const String _boxName = 'favorites';
  static FavoritesRepository? _instance;
  late Box<FavoriteDeviceModel> _box;

  FavoritesRepository._();

  static FavoritesRepository get instance {
    _instance ??= FavoritesRepository._();
    return _instance!;
  }

  Future<void> init() async {
    _box = await Hive.openBox<FavoriteDeviceModel>(_boxName);
  }

  List<FavoriteDeviceModel> getAll() {
    return _box.values.toList()
      ..sort((a, b) => b.lastSeenAt.compareTo(a.lastSeenAt));
  }

  bool isFavorite(String deviceId) {
    return _box.containsKey(deviceId);
  }

  Future<void> addFavorite(BluetoothDeviceModel device) async {
    final favorite = FavoriteDeviceModel.fromBluetoothDevice(device);
    await _box.put(device.id, favorite);
  }

  Future<void> removeFavorite(String deviceId) async {
    await _box.delete(deviceId);
  }

  Future<void> toggleFavorite(BluetoothDeviceModel device) async {
    if (isFavorite(device.id)) {
      await removeFavorite(device.id);
    } else {
      await addFavorite(device);
    }
  }

  FavoriteDeviceModel? getFavorite(String deviceId) {
    return _box.get(deviceId);
  }

  Future<void> updateFromScan(BluetoothDeviceModel device) async {
    final favorite = _box.get(device.id);
    if (favorite != null) {
      favorite.updateFromScan(device);
    }
  }

  Future<void> updateCustomName(String deviceId, String newName) async {
    final favorite = _box.get(deviceId);
    if (favorite != null) {
      favorite.customName = newName;
      await favorite.save();
    }
  }

  Stream<List<FavoriteDeviceModel>> watchFavorites() {
    return _box.watch().map((_) => getAll());
  }
}
