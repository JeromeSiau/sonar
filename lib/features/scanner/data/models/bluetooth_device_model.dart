import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fbp;
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart' as fbs;

enum DeviceType { airpods, headphones, watch, speaker, other }

enum BluetoothSource { ble, classic, both }

class BluetoothDeviceModel {
  final String id;
  final String name;
  final int rssi;
  final int? txPowerLevel;
  final DateTime lastSeen;
  final DeviceType type;
  final bool isBonded;
  final BluetoothSource source;

  const BluetoothDeviceModel({
    required this.id,
    required this.name,
    required this.rssi,
    this.txPowerLevel,
    required this.lastSeen,
    required this.type,
    this.isBonded = false,
    this.source = BluetoothSource.ble,
  });

  factory BluetoothDeviceModel.fromScanResult(
    fbp.ScanResult result, {
    bool isBonded = false,
  }) {
    // Check advertisementData.localName first (often contains the name)
    // Then fall back to platformName, then to unknown
    final advertisedName = result.advertisementData.advName;
    final platformName = result.device.platformName;

    final name = advertisedName.isNotEmpty
        ? advertisedName
        : platformName.isNotEmpty
        ? platformName
        : 'Appareil inconnu';

    return BluetoothDeviceModel(
      id: result.device.remoteId.str,
      name: name,
      rssi: result.rssi,
      txPowerLevel: result.advertisementData.txPowerLevel,
      lastSeen: DateTime.now(),
      type: inferDeviceType(name),
      isBonded: isBonded,
      source: BluetoothSource.ble,
    );
  }

  /// Create from a bonded/paired BLE device (has cached name)
  factory BluetoothDeviceModel.fromBondedDevice(fbp.BluetoothDevice device) {
    final name = device.platformName.isNotEmpty
        ? device.platformName
        : 'Appareil inconnu';

    return BluetoothDeviceModel(
      id: device.remoteId.str,
      name: name,
      rssi: -100, // Unknown RSSI for bonded devices not currently seen
      lastSeen: DateTime.now(),
      type: inferDeviceType(name),
      isBonded: true,
      source: BluetoothSource.ble,
    );
  }

  /// Create from Classic Bluetooth discovery (Android only)
  factory BluetoothDeviceModel.fromClassicDevice(
    fbs.BluetoothDevice device, {
    required int rssi,
    bool isBonded = false,
  }) {
    final name = device.name ?? 'Appareil inconnu';

    return BluetoothDeviceModel(
      id: device.address,
      name: name,
      rssi: rssi,
      lastSeen: DateTime.now(),
      type: inferDeviceType(name),
      isBonded: isBonded,
      source: BluetoothSource.classic,
    );
  }

  static DeviceType inferDeviceType(String name) {
    final lowerName = name.toLowerCase();
    if (lowerName.contains('airpod') || lowerName.contains('pod')) {
      return DeviceType.airpods;
    }
    if (lowerName.contains('headphone') ||
        lowerName.contains('buds') ||
        lowerName.contains('earphone') ||
        lowerName.contains('beats')) {
      return DeviceType.headphones;
    }
    if (lowerName.contains('watch') ||
        lowerName.contains('band') ||
        lowerName.contains('fit')) {
      return DeviceType.watch;
    }
    if (lowerName.contains('speaker') ||
        lowerName.contains('jbl') ||
        lowerName.contains('bose') ||
        lowerName.contains('sonos')) {
      return DeviceType.speaker;
    }
    return DeviceType.other;
  }

  BluetoothDeviceModel copyWith({
    String? id,
    String? name,
    int? rssi,
    int? txPowerLevel,
    DateTime? lastSeen,
    DeviceType? type,
    bool? isBonded,
    BluetoothSource? source,
  }) {
    return BluetoothDeviceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      rssi: rssi ?? this.rssi,
      txPowerLevel: txPowerLevel ?? this.txPowerLevel,
      lastSeen: lastSeen ?? this.lastSeen,
      type: type ?? this.type,
      isBonded: isBonded ?? this.isBonded,
      source: source ?? this.source,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is BluetoothDeviceModel && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
