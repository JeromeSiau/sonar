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

  // Note: @HiveField(6) was lastLocation - removed as unused
  // Keep field index 6 reserved to maintain Hive compatibility

  FavoriteDeviceModel({
    required this.id,
    required this.customName,
    required this.deviceTypeIndex,
    required this.addedAt,
    required this.lastSeenAt,
    required this.lastRssi,
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

  void updateFromScan(BluetoothDeviceModel device) {
    lastSeenAt = device.lastSeen;
    lastRssi = device.rssi;
    save();
  }
}
