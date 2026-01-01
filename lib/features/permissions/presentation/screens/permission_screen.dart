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
    print('[PERM] Button pressed! Requesting permissions...');

    // First check if Bluetooth is enabled at system level
    final btState = await FlutterBluePlus.adapterState.first;
    print('[PERM] Bluetooth adapter state: $btState');

    if (btState != BluetoothAdapterState.on) {
      print('[PERM] Bluetooth is OFF, asking user to enable it...');
      // On iOS, we can't programmatically enable Bluetooth - show a dialog
      if (context.mounted) {
        final l10n = AppLocalizations.of(context)!;
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

    // Platform-specific permissions
    if (Platform.isIOS) {
      // iOS 13+: Bluetooth permission is enough, location not required for BLE
      // If we got here with Bluetooth ON, we have all we need
      print('[PERM] iOS: Bluetooth is ON, navigating to home...');
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

    // Debug: log permission statuses
    for (final entry in statuses.entries) {
      print('[PERM] ${entry.key}: ${entry.value}');
    }

    final allGranted = statuses.values.every(
      (status) => status.isGranted || status.isLimited,
    );

    // Check if any permission is permanently denied
    final hasPermanentlyDenied = statuses.values.any(
      (status) => status.isPermanentlyDenied,
    );

    print('[PERM] allGranted: $allGranted, permanentlyDenied: $hasPermanentlyDenied');

    if (allGranted && context.mounted) {
      print('[PERM] Navigating to home...');
      context.go('/');
    } else if (hasPermanentlyDenied) {
      // Open app settings so user can enable permissions manually
      print('[PERM] Opening app settings...');
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
