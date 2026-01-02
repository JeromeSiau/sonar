import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:bluetooth_finder/app.dart';
import 'package:bluetooth_finder/features/favorites/data/models/favorite_device_model.dart';
import 'package:bluetooth_finder/features/favorites/data/repositories/favorites_repository.dart';
import 'package:bluetooth_finder/core/services/review_service.dart';
import 'package:bluetooth_finder/features/onboarding/data/repositories/onboarding_repository.dart';
import 'package:bluetooth_finder/core/services/widget_service.dart';
import 'package:bluetooth_finder/core/services/background_scan_service.dart';
import 'package:bluetooth_finder/core/services/location_tracking_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(FavoriteDeviceModelAdapter());
  await Hive.openBox('settings');

  // Initialize Favorites Repository
  await FavoritesRepository.instance.init();

  // Initialize Review Service
  await ReviewService.instance.init();

  // Initialize Onboarding Repository
  await OnboardingRepository.instance.init();

  // Initialize Widget Service for home screen widgets
  await WidgetService.instance.init();
  await WidgetService.instance.updateWidget();

  // Initialize Background Scan Service for periodic location updates (Android only)
  await BackgroundScanService.initialize();
  await BackgroundScanService.registerPeriodicTask();

  // Start location tracking for significant location changes (iOS + Android)
  // This updates favorite locations when user moves significantly (~500m)
  await LocationTrackingService.instance.startTracking();

  // Initialize RevenueCat (skip if no valid key)
  // TODO: Replace with your actual API keys
  try {
    await Purchases.configure(
      PurchasesConfiguration('test_bNVWFNdQpzUgWdVFtcDArCyKEGF'),
    );
  } catch (_) {
    // Ignore - RevenueCat not configured yet
  }

  runApp(const ProviderScope(child: BluetoothFinderApp()));
}
