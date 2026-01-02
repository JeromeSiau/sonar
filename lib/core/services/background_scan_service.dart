import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:workmanager/workmanager.dart';
import 'package:bluetooth_finder/features/favorites/data/models/favorite_device_model.dart';
import 'package:bluetooth_finder/core/services/widget_service.dart';

const String backgroundScanTaskName = 'com.levelup.sonarapp.backgroundScan';
const String backgroundScanTaskTag = 'backgroundScanTask';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      await BackgroundScanService.performBackgroundScan();
      return true;
    } catch (e) {
      return false;
    }
  });
}

class BackgroundScanService {
  static const Duration scanDuration = Duration(seconds: 8);
  static const Duration scanInterval = Duration(minutes: 15);

  static Future<void> initialize() async {
    // Workmanager only needed on Android for periodic tasks
    if (!Platform.isAndroid) {
      return;
    }
    await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  }

  static Future<void> registerPeriodicTask() async {
    // iOS doesn't support periodic background tasks via workmanager
    // iOS relies on BGTaskScheduler which the system controls
    // For iOS, we rely on foreground scanning when app is open
    if (!Platform.isAndroid) {
      return;
    }

    await Workmanager().registerPeriodicTask(
      backgroundScanTaskName,
      backgroundScanTaskTag,
      frequency: scanInterval,
      constraints: Constraints(
        networkType: NetworkType.notRequired,
        requiresBatteryNotLow: true,
        requiresCharging: false,
        requiresDeviceIdle: false,
        requiresStorageNotLow: false,
      ),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
      backoffPolicy: BackoffPolicy.linear,
      backoffPolicyDelay: const Duration(minutes: 10),
    );
  }

  static Future<void> cancelPeriodicTask() async {
    if (!Platform.isAndroid) {
      return;
    }
    await Workmanager().cancelByUniqueName(backgroundScanTaskName);
  }

  static Future<void> performBackgroundScan() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(FavoriteDeviceModelAdapter());
    }

    final box = await Hive.openBox<FavoriteDeviceModel>('favorites');
    final favorites = box.values.toList();

    if (favorites.isEmpty) {
      await box.close();
      return;
    }

    final favoriteIds = favorites.map((f) => f.id.toUpperCase()).toSet();

    Position? currentPosition;
    String? placeName;

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (serviceEnabled) {
        final permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.always ||
            permission == LocationPermission.whileInUse) {
          currentPosition = await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.medium,
              timeLimit: Duration(seconds: 5),
            ),
          );

          try {
            final placemarks = await placemarkFromCoordinates(
              currentPosition.latitude,
              currentPosition.longitude,
            );
            if (placemarks.isNotEmpty) {
              final place = placemarks.first;
              placeName =
                  place.subLocality ?? place.thoroughfare ?? place.locality;
            }
          } catch (_) {}
        }
      }
    } catch (_) {}

    final foundDeviceIds = <String>{};

    try {
      final completer = Completer<void>();

      final subscription = FlutterBluePlus.scanResults.listen((results) {
        for (final result in results) {
          final deviceId = result.device.remoteId.str.toUpperCase();
          if (favoriteIds.contains(deviceId)) {
            foundDeviceIds.add(deviceId);
          }
        }
      });

      await FlutterBluePlus.startScan(timeout: scanDuration);

      await Future.delayed(scanDuration);
      await subscription.cancel();
      await FlutterBluePlus.stopScan();

      if (!completer.isCompleted) {
        completer.complete();
      }
    } catch (_) {}

    if (foundDeviceIds.isNotEmpty && currentPosition != null) {
      for (final favorite in favorites) {
        if (foundDeviceIds.contains(favorite.id.toUpperCase())) {
          favorite.lastSeenAt = DateTime.now();
          favorite.lastLatitude = currentPosition.latitude;
          favorite.lastLongitude = currentPosition.longitude;
          favorite.lastLocationName = placeName;
          await favorite.save();
        }
      }

      try {
        await WidgetService.instance.init();
        await WidgetService.instance.updateWidget();
      } catch (_) {}
    }

    await box.close();
  }
}
