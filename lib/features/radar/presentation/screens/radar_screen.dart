import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bluetooth_finder/core/theme/app_colors.dart';
import 'package:bluetooth_finder/features/scanner/presentation/providers/scanner_provider.dart';
import 'package:bluetooth_finder/features/scanner/data/models/bluetooth_device_model.dart';
import 'package:bluetooth_finder/features/favorites/presentation/providers/favorites_provider.dart';
import 'package:bluetooth_finder/features/radar/presentation/widgets/radar_widget.dart';
import 'package:bluetooth_finder/features/radar/presentation/widgets/found_celebration.dart';
import 'package:bluetooth_finder/shared/widgets/heart_button.dart';
import 'package:bluetooth_finder/l10n/app_localizations.dart';

class RadarScreen extends ConsumerStatefulWidget {
  final String deviceId;

  const RadarScreen({super.key, required this.deviceId});

  @override
  ConsumerState<RadarScreen> createState() => _RadarScreenState();
}

class _RadarScreenState extends ConsumerState<RadarScreen> {
  bool _showCelebration = false;
  bool _isSearching = true;
  bool _deviceNotFound = false;
  Timer? _searchTimeout;

  @override
  void initState() {
    super.initState();
    // Delay scan start to after the first frame to avoid ref.read() issues
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startScanAndSearch();
    });
  }

  @override
  void dispose() {
    _searchTimeout?.cancel();
    super.dispose();
  }

  void _startScanAndSearch() {
    if (!mounted) return;

    // Start scanning automatically
    final repo = ref.read(bluetoothRepositoryProvider);
    repo.startScan();
    ref.read(isScanningProvider.notifier).state = true;

    // Set a timeout to show "not found" if device is not detected
    _searchTimeout?.cancel();
    _searchTimeout = Timer(const Duration(seconds: 10), () {
      if (mounted && _isSearching) {
        setState(() {
          _deviceNotFound = true;
          _isSearching = false;
        });
      }
    });
  }

  void _onFoundIt() {
    setState(() {
      _showCelebration = true;
    });
  }

  void _onCelebrationComplete() {
    if (mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedDevice = ref.watch(selectedDeviceProvider);
    final favorite = ref.watch(favoriteByIdProvider(widget.deviceId));
    final devicesAsync = ref.watch(devicesStreamProvider);
    final isFavorite = ref.watch(isFavoriteProvider(widget.deviceId));
    final l10n = AppLocalizations.of(context)!;

    // Try to find device in current scan results (case-insensitive comparison)
    final deviceIdUpper = widget.deviceId.toUpperCase();
    final scannedDevice = devicesAsync.whenOrNull(
      data: (devices) => devices.where((d) => d.id.toUpperCase() == deviceIdUpper).firstOrNull,
    );

    // Use scanned device, selected device, or create from favorite
    BluetoothDeviceModel? device = scannedDevice ?? selectedDevice;

    // If device is found in scan, cancel timeout and update state
    if (scannedDevice != null && _isSearching) {
      _searchTimeout?.cancel();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _isSearching = false;
            _deviceNotFound = false;
          });
        }
      });
    }

    // If no device from scan, use favorite data to create a placeholder
    if (device == null && favorite != null) {
      device = BluetoothDeviceModel(
        id: favorite.id,
        name: favorite.customName,
        rssi: favorite.lastRssi,
        lastSeen: favorite.lastSeenAt,
        type: favorite.deviceType,
        isBonded: false,
        source: BluetoothSource.ble,
      );
    }

    // Show "not found" screen if device wasn't detected after timeout
    if (_deviceNotFound && scannedDevice == null) {
      return _buildNotFoundScreen(context, l10n, favorite?.customName);
    }

    // Show searching screen while waiting
    if (_isSearching && scannedDevice == null) {
      return _buildSearchingScreen(context, l10n, device?.name ?? favorite?.customName);
    }

    if (device == null) {
      return Scaffold(
        body: Center(child: Text(l10n.deviceNotFound)),
      );
    }

    // Use real-time RSSI for faster radar updates (use uppercase ID for consistency)
    final rssiAsync = ref.watch(radarRssiStreamProvider(deviceIdUpper));
    final currentDevice = device; // Non-null for closures

    return Scaffold(
      appBar: _showCelebration
          ? null
          : AppBar(
              title: Text(currentDevice.name),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: HeartButton(
                    isFavorite: isFavorite,
                    size: 28,
                    onPressed: () {
                      ref.read(favoritesProvider.notifier).toggleFavorite(currentDevice);
                    },
                  ),
                ),
              ],
            ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Main content
          SafeArea(
            child: Column(
              children: [
                // Instruction text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  child: Text(
                    l10n.radarInstruction,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),

                // Radar widget
                Expanded(
                  child: rssiAsync.when(
                    data: (rssi) => RadarWidget(
                      rssi: rssi,
                      deviceName: currentDevice.name,
                      deviceType: currentDevice.type,
                    ),
                    loading: () => RadarWidget(
                      rssi: currentDevice.rssi,
                      deviceName: currentDevice.name,
                      deviceType: currentDevice.type,
                    ),
                    error: (_, __) => Center(
                      child: Text(l10n.signalLost),
                    ),
                  ),
                ),

                // Bottom buttons
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                  child: Column(
                    children: [
                      // Found it! button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _onFoundIt,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            l10n.found,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Cancel button
                      TextButton(
                        onPressed: () => context.pop(),
                        child: Text(
                          l10n.cancel,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Celebration overlay
          if (_showCelebration)
            FoundCelebration(onComplete: _onCelebrationComplete, l10n: l10n),
        ],
      ),
    );
  }

  Widget _buildSearchingScreen(BuildContext context, AppLocalizations l10n, String? deviceName) {
    return Scaffold(
      appBar: AppBar(
        title: Text(deviceName ?? ''),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.backgroundGradient),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                l10n.searchingForDevice,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                deviceName ?? '',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotFoundScreen(BuildContext context, AppLocalizations l10n, String? deviceName) {
    return Scaffold(
      appBar: AppBar(
        title: Text(deviceName ?? ''),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.backgroundGradient),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bluetooth_disabled_rounded,
                  size: 80,
                  color: AppColors.textMuted,
                ),
                const SizedBox(height: 32),
                Text(
                  l10n.deviceNotInRange,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.deviceNotInRangeDescription,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isSearching = true;
                        _deviceNotFound = false;
                      });
                      _startScanAndSearch();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(l10n.retry),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => context.pop(),
                  child: Text(
                    l10n.backToHome,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
