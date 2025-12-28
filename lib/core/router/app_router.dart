import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:bluetooth_finder/features/favorites/presentation/screens/home_screen.dart';
import 'package:bluetooth_finder/features/scanner/presentation/screens/scanner_screen.dart';
import 'package:bluetooth_finder/features/radar/presentation/screens/radar_screen.dart';
import 'package:bluetooth_finder/features/permissions/presentation/screens/permission_screen.dart';
import 'package:bluetooth_finder/features/paywall/presentation/screens/paywall_screen.dart';
import 'package:bluetooth_finder/features/settings/presentation/screens/settings_screen.dart';

/// Checks if all required Bluetooth permissions are granted
Future<bool> _arePermissionsGranted() async {
  final statuses = await Future.wait([
    Permission.bluetooth.status,
    Permission.bluetoothScan.status,
    Permission.bluetoothConnect.status,
    Permission.location.status,
  ]);

  return statuses.every((status) => status.isGranted || status.isLimited);
}

final appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) async {
    // Skip permission check for the permissions page itself
    if (state.matchedLocation == '/permissions') {
      return null;
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
