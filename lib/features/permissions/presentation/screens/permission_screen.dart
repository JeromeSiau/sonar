import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:bluetooth_finder/core/theme/app_colors.dart';
import 'package:bluetooth_finder/l10n/app_localizations.dart';

class PermissionScreen extends StatelessWidget {
  const PermissionScreen({super.key});

  Future<void> _requestPermissions(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    // Check if Bluetooth adapter is OFF (applies to both platforms)
    final btState = await FlutterBluePlus.adapterState.first.timeout(
      const Duration(seconds: 2),
      onTimeout: () => BluetoothAdapterState.unknown,
    );

    if (btState == BluetoothAdapterState.off) {
      // Bluetooth is physically off - ask user to enable it in Settings
      if (context.mounted) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(l10n.bluetooth),
            content: Text(l10n.pleaseEnableBluetoothSettings),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  openAppSettings();
                },
                child: Text(l10n.openSettings),
              ),
            ],
          ),
        );
      }
      return;
    }

    if (Platform.isIOS) {
      // iOS: The Bluetooth permission dialog appears automatically when scanning.
      // If we got here with BT not definitively OFF, let user proceed.
      // They'll see the permission dialog when the scanner starts.
      if (context.mounted) {
        context.go('/');
      }
      return;
    }

    // Android 12+ needs bluetoothScan, bluetoothConnect, and location
    final permissions = <Permission>[
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ];

    final statuses = await permissions.request();

    final allGranted = statuses.values.every(
      (status) => status.isGranted || status.isLimited,
    );

    // Check if any permission is permanently denied
    final hasPermanentlyDenied = statuses.values.any(
      (status) => status.isPermanentlyDenied,
    );

    if (allGranted && context.mounted) {
      context.go('/');
    } else if (hasPermanentlyDenied) {
      // Open app settings so user can enable permissions manually
      await openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.bluetooth,
                  size: 60,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 40),
              Text(
                l10n.permissionsRequired,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.permissionsDescription,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              _buildPermissionItem(
                context,
                Icons.bluetooth,
                l10n.bluetooth,
                l10n.bluetoothPermissionDescription,
              ),
              if (!Platform.isIOS)
                _buildPermissionItem(
                  context,
                  Icons.location_on,
                  l10n.location,
                  l10n.locationPermissionDescription,
                ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _requestPermissions(context),
                  child: Text(l10n.authorize),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
