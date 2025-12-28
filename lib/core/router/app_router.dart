import 'package:go_router/go_router.dart';
import 'package:bluetooth_finder/features/favorites/presentation/screens/home_screen.dart';
import 'package:bluetooth_finder/features/scanner/presentation/screens/scanner_screen.dart';
import 'package:bluetooth_finder/features/radar/presentation/screens/radar_screen.dart';
import 'package:bluetooth_finder/features/permissions/presentation/screens/permission_screen.dart';
import 'package:bluetooth_finder/features/paywall/presentation/screens/paywall_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
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
      path: '/permissions',
      builder: (context, state) => const PermissionScreen(),
    ),
    GoRoute(
      path: '/paywall',
      builder: (context, state) => const PaywallScreen(),
    ),
  ],
);
