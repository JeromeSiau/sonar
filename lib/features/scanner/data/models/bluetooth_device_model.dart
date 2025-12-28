import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fbp;

enum DeviceType { airpods, headphones, watch, speaker, other }

class BluetoothDeviceModel {
  final String id;
  final String name;
  final int rssi;
  final DateTime lastSeen;
  final DeviceType type;

  const BluetoothDeviceModel({
    required this.id,
    required this.name,
    required this.rssi,
    required this.lastSeen,
    required this.type,
  });

  factory BluetoothDeviceModel.fromScanResult(fbp.ScanResult result) {
    final name = result.device.platformName.isNotEmpty
        ? result.device.platformName
        : 'Appareil inconnu';

    return BluetoothDeviceModel(
      id: result.device.remoteId.str,
      name: name,
      rssi: result.rssi,
      lastSeen: DateTime.now(),
      type: _inferDeviceType(name),
    );
  }

  static DeviceType _inferDeviceType(String name) {
    final lowerName = name.toLowerCase();
    if (lowerName.contains('airpod') || lowerName.contains('pod')) {
      return DeviceType.airpods;
    }
    if (lowerName.contains('headphone') || lowerName.contains('buds') ||
        lowerName.contains('earphone') || lowerName.contains('beats')) {
      return DeviceType.headphones;
    }
    if (lowerName.contains('watch') || lowerName.contains('band') ||
        lowerName.contains('fit')) {
      return DeviceType.watch;
    }
    if (lowerName.contains('speaker') || lowerName.contains('jbl') ||
        lowerName.contains('bose') || lowerName.contains('sonos')) {
      return DeviceType.speaker;
    }
    return DeviceType.other;
  }

  BluetoothDeviceModel copyWith({
    String? id,
    String? name,
    int? rssi,
    DateTime? lastSeen,
    DeviceType? type,
  }) {
    return BluetoothDeviceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      rssi: rssi ?? this.rssi,
      lastSeen: lastSeen ?? this.lastSeen,
      type: type ?? this.type,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BluetoothDeviceModel && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
