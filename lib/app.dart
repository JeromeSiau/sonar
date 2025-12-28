import 'package:flutter/material.dart';
import 'package:bluetooth_finder/core/theme/app_theme.dart';
import 'package:bluetooth_finder/core/router/app_router.dart';

class BluetoothFinderApp extends StatelessWidget {
  const BluetoothFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Sonar',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: appRouter,
    );
  }
}
