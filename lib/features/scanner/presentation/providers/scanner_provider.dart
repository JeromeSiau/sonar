import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:bluetooth_finder/features/scanner/data/models/bluetooth_device_model.dart';
import 'package:bluetooth_finder/features/scanner/data/repositories/bluetooth_repository.dart';
import 'package:bluetooth_finder/features/favorites/presentation/providers/favorites_provider.dart';

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

final deviceRssiStreamProvider = StreamProvider.family<int, String>((ref, deviceId) {
  final repo = ref.watch(bluetoothRepositoryProvider);
  return repo.getRssiStream(deviceId);
});

/// "My devices" = bonded OR favorite, sorted by signal strength
final myDevicesProvider = Provider<List<BluetoothDeviceModel>>((ref) {
  final devicesAsync = ref.watch(devicesStreamProvider);
  final favorites = ref.watch(favoritesProvider);
  final favoriteIds = favorites.map((f) => f.id).toSet();

  return devicesAsync.when(
    data: (devices) {
      final myDevices = devices
          .where((d) => d.isBonded || favoriteIds.contains(d.id))
          .toList();
      myDevices.sort((a, b) => b.rssi.compareTo(a.rssi));
      return myDevices;
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

/// "Nearby devices" = NOT bonded AND NOT favorite, sorted by signal strength
final nearbyDevicesProvider = Provider<List<BluetoothDeviceModel>>((ref) {
  final devicesAsync = ref.watch(devicesStreamProvider);
  final favorites = ref.watch(favoritesProvider);
  final favoriteIds = favorites.map((f) => f.id).toSet();

  return devicesAsync.when(
    data: (devices) {
      final nearbyDevices = devices
          .where((d) => !d.isBonded && !favoriteIds.contains(d.id))
          .toList();
      nearbyDevices.sort((a, b) => b.rssi.compareTo(a.rssi));
      return nearbyDevices;
    },
    loading: () => [],
    error: (_, __) => [],
  );
});
