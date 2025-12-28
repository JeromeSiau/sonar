import 'dart:async';
import 'dart:io';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart' as classic;
import 'package:bluetooth_finder/features/scanner/data/models/bluetooth_device_model.dart';

class BluetoothRepository {
  final Map<String, BluetoothDeviceModel> _devices = {};
  final _devicesController = StreamController<List<BluetoothDeviceModel>>.broadcast();
  StreamSubscription<List<ScanResult>>? _bleScanSubscription;
  StreamSubscription<classic.BluetoothDiscoveryResult>? _classicScanSubscription;
  Timer? _cleanupTimer;

  // Set of bonded device IDs for quick lookup
  final Set<String> _bondedDeviceIds = {};

  Stream<List<BluetoothDeviceModel>> get devicesStream => _devicesController.stream;

  List<BluetoothDeviceModel> get currentDevices {
    final sorted = _devices.values.toList();
    // Sort by signal strength (higher RSSI = closer)
    sorted.sort((a, b) => b.rssi.compareTo(a.rssi));
    return sorted;
  }

  Future<bool> isBluetoothOn() async {
    return await FlutterBluePlus.adapterState.first == BluetoothAdapterState.on;
  }

  Future<void> startScan() async {
    _devices.clear();
    _bondedDeviceIds.clear();

    // First, add bonded/paired devices (they have cached names)
    await _addBondedDevices();

    // Start BLE scan (iOS + Android)
    _startBleScan();

    // Start Classic Bluetooth scan (Android only)
    if (Platform.isAndroid) {
      _startClassicScan();
    }

    // Start cleanup timer to remove stale devices
    _cleanupTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _removeStaleDevices();
    });
  }

  void _startBleScan() {
    _bleScanSubscription = FlutterBluePlus.scanResults.listen((results) {
      for (final result in results) {
        final isBonded = _bondedDeviceIds.contains(result.device.remoteId.str);
        final device = BluetoothDeviceModel.fromScanResult(result, isBonded: isBonded);
        _mergeDevice(device);
      }
      _devicesController.add(currentDevices);
    });

    FlutterBluePlus.startScan(
      timeout: const Duration(seconds: 30),
      androidUsesFineLocation: true,
    );
  }

  void _startClassicScan() {
    _classicScanSubscription = classic.FlutterBluetoothSerial.instance
        .startDiscovery()
        .listen((result) {
      final device = BluetoothDeviceModel.fromClassicDevice(
        result.device,
        rssi: result.rssi,
      );
      _mergeDevice(device);
      _devicesController.add(currentDevices);
    });
  }

  /// Merge a device into the map, preferring named devices over unknown
  void _mergeDevice(BluetoothDeviceModel device) {
    final existing = _devices[device.id];

    if (existing == null) {
      _devices[device.id] = device;
      return;
    }

    // Prefer device with a name
    final existingHasName = existing.name != 'Appareil inconnu';
    final newHasName = device.name != 'Appareil inconnu';

    if (newHasName && !existingHasName) {
      // New device has name, existing doesn't - use new but keep bonded status
      _devices[device.id] = device.copyWith(
        isBonded: existing.isBonded || device.isBonded,
        source: _combineSource(existing.source, device.source),
      );
    } else if (existingHasName && !newHasName) {
      // Existing has name, keep it but update RSSI and lastSeen
      _devices[device.id] = existing.copyWith(
        rssi: device.rssi,
        lastSeen: device.lastSeen,
        isBonded: existing.isBonded || device.isBonded,
        source: _combineSource(existing.source, device.source),
      );
    } else {
      // Both have names or both don't - update with latest data
      // Prefer Classic Bluetooth name as it's more reliable
      if (device.source == BluetoothSource.classic) {
        _devices[device.id] = device.copyWith(
          isBonded: existing.isBonded || device.isBonded,
          source: _combineSource(existing.source, device.source),
        );
      } else {
        _devices[device.id] = existing.copyWith(
          rssi: device.rssi,
          lastSeen: device.lastSeen,
          isBonded: existing.isBonded || device.isBonded,
          source: _combineSource(existing.source, device.source),
        );
      }
    }
  }

  BluetoothSource _combineSource(BluetoothSource a, BluetoothSource b) {
    if (a == b) return a;
    return BluetoothSource.both;
  }

  Future<void> _addBondedDevices() async {
    // Add BLE bonded devices
    try {
      final bondedDevices = await FlutterBluePlus.bondedDevices;
      for (final device in bondedDevices) {
        _bondedDeviceIds.add(device.remoteId.str);
        final model = BluetoothDeviceModel.fromBondedDevice(device);
        if (model.name != 'Appareil inconnu') {
          _devices[model.id] = model;
        }
      }
    } catch (e) {
      // Bonded devices not supported on this platform
    }

    // Add Classic bonded devices (Android only)
    if (Platform.isAndroid) {
      try {
        final classicBonded = await classic.FlutterBluetoothSerial.instance.getBondedDevices();
        for (final device in classicBonded) {
          _bondedDeviceIds.add(device.address);
          final model = BluetoothDeviceModel.fromClassicDevice(device);
          if (model.name != 'Appareil inconnu') {
            _mergeDevice(model);
          }
        }
      } catch (e) {
        // Classic Bluetooth not available
      }
    }

    _devicesController.add(currentDevices);
  }

  Future<void> stopScan() async {
    await FlutterBluePlus.stopScan();
    _bleScanSubscription?.cancel();
    _bleScanSubscription = null;

    if (Platform.isAndroid) {
      try {
        await classic.FlutterBluetoothSerial.instance.cancelDiscovery();
      } catch (e) {
        // Ignore errors when stopping classic scan
      }
    }
    _classicScanSubscription?.cancel();
    _classicScanSubscription = null;

    _cleanupTimer?.cancel();
    _cleanupTimer = null;
  }

  void _removeStaleDevices() {
    final now = DateTime.now();
    const staleThreshold = Duration(seconds: 10);

    _devices.removeWhere((_, device) {
      // Don't remove bonded devices even if stale
      if (device.isBonded) return false;
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
