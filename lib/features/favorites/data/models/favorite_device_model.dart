import 'package:hive_flutter/hive_flutter.dart';
import 'package:bluetooth_finder/features/scanner/data/models/bluetooth_device_model.dart';

part 'favorite_device_model.g.dart';

@HiveType(typeId: 0)
class FavoriteDeviceModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String customName;

  @HiveField(2)
  final int deviceTypeIndex;

  @HiveField(3)
  final DateTime addedAt;

  @HiveField(4)
  DateTime lastSeenAt;

  @HiveField(5)
  int lastRssi;

  @HiveField(6)
  double? lastLatitude;

  @HiveField(7)
  double? lastLongitude;

  @HiveField(8)
  String? lastLocationName;

  FavoriteDeviceModel({
    required this.id,
    required this.customName,
    required this.deviceTypeIndex,
    required this.addedAt,
    required this.lastSeenAt,
    required this.lastRssi,
    this.lastLatitude,
    this.lastLongitude,
    this.lastLocationName,
  });

  DeviceType get deviceType => DeviceType.values[deviceTypeIndex];

  factory FavoriteDeviceModel.fromBluetoothDevice(BluetoothDeviceModel device) {
    return FavoriteDeviceModel(
      id: device.id,
      customName: device.name,
      deviceTypeIndex: device.type.index,
      addedAt: DateTime.now(),
      lastSeenAt: device.lastSeen,
      lastRssi: device.rssi,
    );
  }

  void updateFromScan(
    BluetoothDeviceModel device, {
    double? latitude,
    double? longitude,
    String? locationName,
  }) {
    lastSeenAt = device.lastSeen;
    lastRssi = device.rssi;
    if (latitude != null && longitude != null) {
      lastLatitude = latitude;
      lastLongitude = longitude;
      lastLocationName = locationName;
    }
    save();
  }

  /// Returns true if we have a valid last known location
  bool get hasLastLocation => lastLatitude != null && lastLongitude != null;
}
