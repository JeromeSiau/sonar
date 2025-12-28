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

final deviceRssiStreamProvider = StreamProvider.family<int, String>((ref, deviceId) {
  final repo = ref.watch(bluetoothRepositoryProvider);
  return repo.getRssiStream(deviceId);
});
