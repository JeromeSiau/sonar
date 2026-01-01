// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_device_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoriteDeviceModelAdapter extends TypeAdapter<FavoriteDeviceModel> {
  @override
  final int typeId = 0;

  @override
  FavoriteDeviceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoriteDeviceModel(
      id: fields[0] as String,
      customName: fields[1] as String,
      deviceTypeIndex: fields[2] as int,
      addedAt: fields[3] as DateTime,
      lastSeenAt: fields[4] as DateTime,
      lastRssi: fields[5] as int,
      lastLatitude: fields[6] as double?,
      lastLongitude: fields[7] as double?,
      lastLocationName: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, FavoriteDeviceModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.customName)
      ..writeByte(2)
      ..write(obj.deviceTypeIndex)
      ..writeByte(3)
      ..write(obj.addedAt)
      ..writeByte(4)
      ..write(obj.lastSeenAt)
      ..writeByte(5)
      ..write(obj.lastRssi)
      ..writeByte(6)
      ..write(obj.lastLatitude)
      ..writeByte(7)
      ..write(obj.lastLongitude)
      ..writeByte(8)
      ..write(obj.lastLocationName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteDeviceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
