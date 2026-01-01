import 'dart:async';
import 'dart:io';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart' as classic;
import 'package:bluetooth_finder/features/scanner/data/models/bluetooth_device_model.dart';

class BluetoothRepository {
  final Map<String, BluetoothDeviceModel> _devices = {};
  final _devicesController = StreamController<List<BluetoothDeviceModel>>.broadcast();
  // Real-time RSSI stream for radar (not debounced)
  final _rssiController = StreamController<Map<String, int>>.broadcast();
  StreamSubscription<List<ScanResult>>? _bleScanSubscription;
  StreamSubscription<classic.BluetoothDiscoveryResult>? _classicScanSubscription;
  Timer? _cleanupTimer;
  Timer? _rssiPollingTimer;
  Timer? _updateDebounceTimer;
  DateTime? _lastEmit;

  // Map of bonded device IDs to their cached names
  final Map<String, String> _bondedDeviceNames = {};
  // List of bonded BLE devices for RSSI polling
  final List<BluetoothDevice> _bondedBleDevices = [];

  // Debounce interval for UI updates (prevents constant jumping)
  static const _updateInterval = Duration(milliseconds: 1500);

  Stream<List<BluetoothDeviceModel>> get devicesStream => _devicesController.stream;

  /// Real-time RSSI stream for radar - emits immediately without debouncing
  Stream<Map<String, int>> get rssiStream => _rssiController.stream;

  /// Emit real-time RSSI update (no debouncing, for radar)
  void _emitRssi(String deviceId, int rssi) {
    _rssiController.add({deviceId: rssi});
  }

  /// Emit update to stream with debouncing to prevent UI jumping
  void _emitUpdate({bool force = false}) {
    final now = DateTime.now();

    // If forced or first emit, do it immediately
    if (force || _lastEmit == null) {
      _lastEmit = now;
      _devicesController.add(currentDevices);
      return;
    }

    // Cancel any pending debounce
    _updateDebounceTimer?.cancel();

    // If enough time has passed, emit immediately
    if (now.difference(_lastEmit!) >= _updateInterval) {
      _lastEmit = now;
      _devicesController.add(currentDevices);
    } else {
      // Schedule an update for later
      _updateDebounceTimer = Timer(_updateInterval, () {
        _lastEmit = DateTime.now();
        _devicesController.add(currentDevices);
      });
    }
  }

  List<BluetoothDeviceModel> get currentDevices {
    final sorted = _devices.values.toList();
    // Sort by: 1) bonded devices first, 2) named devices, 3) signal strength
    sorted.sort((a, b) {
      // Bonded devices first
      if (a.isBonded && !b.isBonded) return -1;
      if (!a.isBonded && b.isBonded) return 1;
      // Then named devices
      final aHasName = a.name != 'Appareil inconnu';
      final bHasName = b.name != 'Appareil inconnu';
      if (aHasName && !bHasName) return -1;
      if (!aHasName && bHasName) return 1;
      // Then by signal strength (higher RSSI = closer)
      return b.rssi.compareTo(a.rssi);
    });
    return sorted;
  }

  Future<bool> isBluetoothOn() async {
    return await FlutterBluePlus.adapterState.first == BluetoothAdapterState.on;
  }

  Future<void> startScan() async {
    _devices.clear();
    _bondedDeviceNames.clear();

    // First, collect bonded/paired device names
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
        final deviceId = result.device.remoteId.str.toUpperCase();
        final cachedName = _bondedDeviceNames[deviceId];
        final isBonded = cachedName != null;

        // Debug: log advertisement data for devices with manufacturer data
        final msd = result.advertisementData.manufacturerData;
        if (msd.isNotEmpty && _devices.length < 20) {
          final name = result.advertisementData.advName;
          final platformName = result.device.platformName;
          print('[BT] MSD device: $deviceId');
          print('[BT]   advName: "$name", platformName: "$platformName"');
          for (final entry in msd.entries) {
            final companyId = entry.key;
            final data = entry.value;
            print('[BT]   Company 0x${companyId.toRadixString(16)}: ${data.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}');
            // Apple company ID
            if (companyId == 0x004C) {
              print('[BT]   -> APPLE DEVICE DETECTED!');
            }
          }
        }

        var device = BluetoothDeviceModel.fromScanResult(result, isBonded: isBonded);
        // Use cached name if scan didn't provide one
        if (device.name == 'Appareil inconnu' && cachedName != null) {
          device = device.copyWith(name: cachedName);
        }
        _mergeDevice(device);
        // Emit real-time RSSI for radar
        _emitRssi(device.id, device.rssi);
      }
      _emitUpdate();
    });

    // Start continuous scan (no timeout - stops when stopScan is called)
    FlutterBluePlus.startScan(
      androidUsesFineLocation: true,
      // Android specific: scan in low latency mode for better results
      androidScanMode: AndroidScanMode.lowLatency,
      // Continuous updates for RSSI changes
      continuousUpdates: true,
    );
  }

  void _startClassicScan() {
    print('[BT] Starting Classic scan...');
    _classicScanSubscription = classic.FlutterBluetoothSerial.instance
        .startDiscovery()
        .listen((result) {
      final deviceId = result.device.address.toUpperCase();
      final cachedName = _bondedDeviceNames[deviceId];
      final isBonded = cachedName != null;
      var model = BluetoothDeviceModel.fromClassicDevice(
        result.device,
        rssi: result.rssi,
        isBonded: isBonded,
      );
      // Use cached name if scan didn't provide one
      if (model.name == 'Appareil inconnu' && cachedName != null) {
        model = model.copyWith(name: cachedName);
      }
      print('[BT] Classic scan: ${model.id} -> ${model.name} (bonded: $isBonded, rssi: ${model.rssi})');
      _mergeDevice(model);
      // Emit real-time RSSI for radar
      _emitRssi(model.id, model.rssi);
      _emitUpdate();
    }, onError: (e) {
      print('[BT] Classic scan error: $e');
    }, onDone: () {
      print('[BT] Classic scan done');
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
    _bondedBleDevices.clear();

    // Get bonded BLE devices and add them to the list immediately
    try {
      final bondedDevices = await FlutterBluePlus.bondedDevices;
      print('[BT] Found ${bondedDevices.length} BLE bonded devices');
      for (final device in bondedDevices) {
        final name = device.platformName;
        final id = device.remoteId.str.toUpperCase();
        print('[BT] BLE bonded: $id -> $name');
        if (name.isNotEmpty) {
          _bondedDeviceNames[id] = name;
          _bondedBleDevices.add(device);

          // Add bonded device to the list immediately with unknown RSSI
          final model = BluetoothDeviceModel(
            id: id,
            name: name,
            rssi: -100, // Will be updated when we connect
            lastSeen: DateTime.now(),
            type: BluetoothDeviceModel.inferDeviceType(name),
            isBonded: true,
            source: BluetoothSource.ble,
          );
          _devices[id] = model;
        }
      }
    } catch (e) {
      print('[BT] Error getting BLE bonded: $e');
    }

    // Collect Classic bonded device names (Android only)
    if (Platform.isAndroid) {
      try {
        final classicBonded = await classic.FlutterBluetoothSerial.instance.getBondedDevices();
        print('[BT] Found ${classicBonded.length} Classic bonded devices');
        for (final device in classicBonded) {
          final name = device.name;
          final id = device.address.toUpperCase();
          print('[BT] Classic bonded: $id -> $name');
          if (name != null && name.isNotEmpty) {
            _bondedDeviceNames[id] = name;

            // Add Classic bonded device if not already added via BLE
            if (!_devices.containsKey(id)) {
              final model = BluetoothDeviceModel(
                id: id,
                name: name,
                rssi: -100,
                lastSeen: DateTime.now(),
                type: BluetoothDeviceModel.inferDeviceType(name),
                isBonded: true,
                source: BluetoothSource.classic,
              );
              _devices[id] = model;
            }
          }
        }
      } catch (e) {
        print('[BT] Error getting Classic bonded: $e');
      }
    }

    print('[BT] Total bonded devices: ${_devices.length}');
    _emitUpdate(force: true);

    // Start polling RSSI for bonded devices
    _startRssiPolling();
  }

  /// Poll RSSI for bonded devices by connecting briefly
  void _startRssiPolling() {
    _rssiPollingTimer?.cancel();
    _rssiPollingTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      _pollBondedDevicesRssi();
    });
    // Also poll immediately
    _pollBondedDevicesRssi();
  }

  Future<void> _pollBondedDevicesRssi() async {
    // First check system-connected BLE devices
    try {
      final connectedDevices = await FlutterBluePlus.connectedDevices;
      for (final device in connectedDevices) {
        final id = device.remoteId.str.toUpperCase();
        try {
          final rssi = await device.readRssi();
          print('[BT] Connected device RSSI ${device.platformName}: $rssi');
          final existing = _devices[id];
          if (existing != null) {
            _devices[id] = existing.copyWith(
              rssi: rssi,
              lastSeen: DateTime.now(),
            );
            // Emit real-time RSSI for radar
            _emitRssi(id, rssi);
          }
        } catch (e) {
          print('[BT] Cannot read RSSI for connected ${device.platformName}: $e');
        }
      }
    } catch (e) {
      print('[BT] Error getting connected devices: $e');
    }

    // Then try to connect to bonded devices that aren't system-connected
    for (final device in _bondedBleDevices) {
      try {
        final id = device.remoteId.str.toUpperCase();

        // Skip if already has recent RSSI (was found via scan or connected devices)
        final existing = _devices[id];
        if (existing != null && existing.rssi > -90 &&
            DateTime.now().difference(existing.lastSeen).inSeconds < 5) {
          continue;
        }

        // Only try to connect if device reports as connectable
        if (!device.isConnected) {
          try {
            await device.connect(timeout: const Duration(seconds: 3), autoConnect: true);
          } catch (_) {
            // Connection failed - device might not be reachable
          }
        }

        if (device.isConnected) {
          final rssi = await device.readRssi();
          print('[BT] RSSI for ${device.platformName}: $rssi');
          if (existing != null) {
            _devices[id] = existing.copyWith(
              rssi: rssi,
              lastSeen: DateTime.now(),
            );
            // Emit real-time RSSI for radar
            _emitRssi(id, rssi);
          }
        }
      } catch (e) {
        print('[BT] Cannot reach ${device.platformName}: $e');
      }
    }
    _emitUpdate();
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

    _rssiPollingTimer?.cancel();
    _rssiPollingTimer = null;

    _updateDebounceTimer?.cancel();
    _updateDebounceTimer = null;

    // Disconnect from all bonded devices
    for (final device in _bondedBleDevices) {
      try {
        if (device.isConnected) {
          await device.disconnect();
        }
      } catch (_) {}
    }
  }

  void _removeStaleDevices() {
    final now = DateTime.now();
    // Increase threshold to 30 seconds for regular devices
    const staleThreshold = Duration(seconds: 30);

    final countBefore = _devices.length;

    _devices.removeWhere((_, device) {
      // Never remove bonded devices - they should always be visible
      if (device.isBonded) return false;
      return now.difference(device.lastSeen) > staleThreshold;
    });

    // Only emit if something changed
    if (_devices.length != countBefore) {
      _emitUpdate();
    }
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
    _rssiController.close();
  }
}
