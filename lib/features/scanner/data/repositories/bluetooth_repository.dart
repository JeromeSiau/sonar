import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:bluetooth_finder/features/scanner/data/models/bluetooth_device_model.dart';

class BluetoothRepository {
  final Map<String, BluetoothDeviceModel> _devices = {};
  final _devicesController = StreamController<List<BluetoothDeviceModel>>.broadcast();
  StreamSubscription<List<ScanResult>>? _scanSubscription;
  Timer? _cleanupTimer;

  Stream<List<BluetoothDeviceModel>> get devicesStream => _devicesController.stream;

  List<BluetoothDeviceModel> get currentDevices => _devices.values.toList()
    ..sort((a, b) => b.rssi.compareTo(a.rssi));

  Future<bool> isBluetoothOn() async {
    return await FlutterBluePlus.adapterState.first == BluetoothAdapterState.on;
  }

  Future<void> startScan() async {
    _devices.clear();

    // Listen to scan results
    _scanSubscription = FlutterBluePlus.scanResults.listen((results) {
      for (final result in results) {
        final device = BluetoothDeviceModel.fromScanResult(result);
        _devices[device.id] = device;
      }
      _devicesController.add(currentDevices);
    });

    // Start cleanup timer to remove stale devices
    _cleanupTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _removeStaleDevices();
    });

    // Start scanning
    await FlutterBluePlus.startScan(
      timeout: const Duration(seconds: 30),
      androidUsesFineLocation: true,
    );
  }

  Future<void> stopScan() async {
    await FlutterBluePlus.stopScan();
    _scanSubscription?.cancel();
    _scanSubscription = null;
    _cleanupTimer?.cancel();
    _cleanupTimer = null;
  }

  void _removeStaleDevices() {
    final now = DateTime.now();
    const staleThreshold = Duration(seconds: 10);

    _devices.removeWhere((_, device) {
      return now.difference(device.lastSeen) > staleThreshold;
    });

    _devicesController.add(currentDevices);
  }

  Stream<int> getRssiStream(String deviceId) async* {
    await for (final devices in devicesStream) {
      final device = devices.where((d) => d.id == deviceId).firstOrNull;
      if (device != null) {
        yield device.rssi;
      }
    }
  }

  void dispose() {
    stopScan();
    _devicesController.close();
  }
}
