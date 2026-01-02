import 'dart:io';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:bluetooth_finder/features/favorites/presentation/screens/home_screen.dart';
import 'package:bluetooth_finder/features/scanner/presentation/screens/scanner_screen.dart';
import 'package:bluetooth_finder/features/radar/presentation/screens/radar_screen.dart';
import 'package:bluetooth_finder/features/permissions/presentation/screens/permission_screen.dart';
import 'package:bluetooth_finder/features/paywall/presentation/screens/paywall_screen.dart';
import 'package:bluetooth_finder/features/settings/presentation/screens/settings_screen.dart';
import 'package:bluetooth_finder/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:bluetooth_finder/features/onboarding/data/repositories/onboarding_repository.dart';
import 'package:bluetooth_finder/features/map/presentation/screens/device_map_screen.dart';

/// Checks if Bluetooth is enabled and all required permissions are granted
Future<bool> _arePermissionsGranted() async {
  // First check if Bluetooth is enabled at system level
  try {
    // Wait for a definitive Bluetooth state (not unknown/turningOn/turningOff)
    // with a timeout to avoid blocking forever
    final btState = await FlutterBluePlus.adapterState
        .where((state) =>
            state == BluetoothAdapterState.on ||
            state == BluetoothAdapterState.off)
        .first
        .timeout(const Duration(seconds: 3), onTimeout: () async {
      // If timeout, check current state
      return await FlutterBluePlus.adapterState.first;
    });
    if (btState != BluetoothAdapterState.on) {
      return false;
    }
  } catch (e) {
    // If we can't check, assume Bluetooth is off
    return false;
  }

  // Platform-specific permissions
  if (Platform.isIOS) {
    // iOS 13+: Bluetooth permission is enough, location not required for BLE
    // If Bluetooth is ON (checked above), we have all permissions we need
    return true;
  }

  // Android 12+ needs bluetoothScan, bluetoothConnect, and location
  final permissions = <Future<PermissionStatus>>[
    Permission.bluetoothScan.status,
    Permission.bluetoothConnect.status,
    Permission.location.status,
  ];

  final statuses = await Future.wait(permissions);
  return statuses.every((status) => status.isGranted || status.isLimited);
}

final appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) async {
    final location = state.matchedLocation;

    // Skip checks for onboarding and permissions pages
    if (location == '/onboarding' || location == '/permissions') {
      return null;
    }

    // Check if onboarding has been seen (first launch)
    final hasSeenOnboarding = OnboardingRepository.instance.hasSeenOnboarding;
    if (!hasSeenOnboarding) {
      return '/onboarding';
    }

    // Check permissions on app start and when navigating to protected routes
    final hasPermissions = await _arePermissionsGranted();
    if (!hasPermissions) {
      return '/permissions';
    }

    return null;
  },
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/scanner',
      builder: (context, state) => const ScannerScreen(),
    ),
    GoRoute(
      path: '/radar/:deviceId',
      builder: (context, state) {
        final deviceId = state.pathParameters['deviceId']!;
        return RadarScreen(deviceId: deviceId);
      },
    ),
    GoRoute(
      path: '/map/:deviceId',
      builder: (context, state) {
        final deviceId = state.pathParameters['deviceId']!;
        return DeviceMapScreen(deviceId: deviceId);
      },
    ),
    GoRoute(
      path: '/permissions',
      builder: (context, state) => const PermissionScreen(),
    ),
    GoRoute(
      path: '/paywall',
      builder: (context, state) => const PaywallScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
