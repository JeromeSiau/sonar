import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:bluetooth_finder/app.dart';
import 'package:bluetooth_finder/features/favorites/data/models/favorite_device_model.dart';
import 'package:bluetooth_finder/features/favorites/data/repositories/favorites_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(FavoriteDeviceModelAdapter());

  // Initialize Favorites Repository
  final favoritesRepo = FavoritesRepository();
  await favoritesRepo.init();

  // Initialize RevenueCat
  // TODO: Replace with your actual API keys
  await Purchases.configure(
    PurchasesConfiguration('your_revenuecat_api_key'),
  );

  runApp(
    const ProviderScope(
      child: BluetoothFinderApp(),
    ),
  );
}
