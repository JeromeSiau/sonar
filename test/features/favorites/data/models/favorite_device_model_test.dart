import 'package:flutter_test/flutter_test.dart';
import 'package:bluetooth_finder/features/favorites/data/models/favorite_device_model.dart';
import 'package:bluetooth_finder/features/scanner/data/models/bluetooth_device_model.dart';

void main() {
  group('FavoriteDeviceModel', () {
    test('creates instance with required fields', () {
      final now = DateTime.now();
      final favorite = FavoriteDeviceModel(
        id: 'test-id',
        customName: 'My AirPods',
        deviceTypeIndex: DeviceType.airpods.index,
        addedAt: now,
        lastSeenAt: now,
        lastRssi: -50,
      );

      expect(favorite.id, 'test-id');
      expect(favorite.customName, 'My AirPods');
      expect(favorite.deviceType, DeviceType.airpods);
      expect(favorite.lastRssi, -50);
    });

    test('deviceType getter returns correct type from index', () {
      final favorite = FavoriteDeviceModel(
        id: 'test-id',
        customName: 'Speaker',
        deviceTypeIndex: DeviceType.speaker.index,
        addedAt: DateTime.now(),
        lastSeenAt: DateTime.now(),
        lastRssi: -60,
      );

      expect(favorite.deviceType, DeviceType.speaker);
    });

    test('fromBluetoothDevice creates correct instance', () {
      final bluetoothDevice = BluetoothDeviceModel(
        id: 'device-123',
        name: 'AirPods Pro',
        rssi: -45,
        lastSeen: DateTime.now(),
        type: DeviceType.airpods,
        isBonded: true,
      );

      final favorite = FavoriteDeviceModel.fromBluetoothDevice(bluetoothDevice);

      expect(favorite.id, 'device-123');
      expect(favorite.customName, 'AirPods Pro');
      expect(favorite.deviceType, DeviceType.airpods);
      expect(favorite.lastRssi, -45);
    });

    test('all DeviceType values can be converted to index and back', () {
      for (final type in DeviceType.values) {
        final favorite = FavoriteDeviceModel(
          id: 'test',
          customName: 'Test',
          deviceTypeIndex: type.index,
          addedAt: DateTime.now(),
          lastSeenAt: DateTime.now(),
          lastRssi: -50,
        );

        expect(favorite.deviceType, type);
      }
    });
  });

  group('BluetoothDeviceModel', () {
    test('creates instance with required fields', () {
      final device = BluetoothDeviceModel(
        id: 'device-id',
        name: 'Test Device',
        rssi: -55,
        lastSeen: DateTime.now(),
        type: DeviceType.other,
      );

      expect(device.id, 'device-id');
      expect(device.name, 'Test Device');
      expect(device.rssi, -55);
      expect(device.type, DeviceType.other);
      expect(device.isBonded, false);
      expect(device.source, BluetoothSource.ble);
    });

    test('copyWith creates new instance with updated fields', () {
      final original = BluetoothDeviceModel(
        id: 'device-id',
        name: 'Original Name',
        rssi: -55,
        lastSeen: DateTime.now(),
        type: DeviceType.other,
      );

      final updated = original.copyWith(name: 'Updated Name', rssi: -40);

      expect(updated.id, 'device-id');
      expect(updated.name, 'Updated Name');
      expect(updated.rssi, -40);
      expect(updated.type, DeviceType.other);
    });

    test('equality is based on id', () {
      final device1 = BluetoothDeviceModel(
        id: 'same-id',
        name: 'Device 1',
        rssi: -50,
        lastSeen: DateTime.now(),
        type: DeviceType.other,
      );

      final device2 = BluetoothDeviceModel(
        id: 'same-id',
        name: 'Device 2', // Different name
        rssi: -60, // Different rssi
        lastSeen: DateTime.now(),
        type: DeviceType.headphones, // Different type
      );

      final device3 = BluetoothDeviceModel(
        id: 'different-id',
        name: 'Device 1',
        rssi: -50,
        lastSeen: DateTime.now(),
        type: DeviceType.other,
      );

      expect(device1 == device2, true);
      expect(device1 == device3, false);
      expect(device1.hashCode, device2.hashCode);
    });

    group('device type inference', () {
      test('infers airpods from name', () {
        final device = BluetoothDeviceModel(
          id: 'test',
          name: 'AirPods Pro',
          rssi: -50,
          lastSeen: DateTime.now(),
          type: DeviceType.airpods,
        );
        expect(device.type, DeviceType.airpods);
      });

      test('infers headphones from name with buds', () {
        final device = BluetoothDeviceModel(
          id: 'test',
          name: 'Galaxy Buds',
          rssi: -50,
          lastSeen: DateTime.now(),
          type: DeviceType.headphones,
        );
        expect(device.type, DeviceType.headphones);
      });

      test('infers watch from name', () {
        final device = BluetoothDeviceModel(
          id: 'test',
          name: 'Apple Watch',
          rssi: -50,
          lastSeen: DateTime.now(),
          type: DeviceType.watch,
        );
        expect(device.type, DeviceType.watch);
      });

      test('infers speaker from JBL name', () {
        final device = BluetoothDeviceModel(
          id: 'test',
          name: 'JBL Flip 5',
          rssi: -50,
          lastSeen: DateTime.now(),
          type: DeviceType.speaker,
        );
        expect(device.type, DeviceType.speaker);
      });
    });
  });
}
