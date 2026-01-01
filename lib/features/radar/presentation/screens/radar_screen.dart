import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bluetooth_finder/core/theme/app_colors.dart';
import 'package:bluetooth_finder/core/services/locator_sound_service.dart';
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
                      // Play Sound button
                      _PlaySoundButton(
                        deviceName: currentDevice.name,
                        isBonded: currentDevice.isBonded,
                      ),

                      const SizedBox(height: 12),

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

/// Button to play a locator sound through connected Bluetooth audio devices.
class _PlaySoundButton extends ConsumerStatefulWidget {
  final String deviceName;
  final bool isBonded;

  const _PlaySoundButton({
    required this.deviceName,
    required this.isBonded,
  });

  @override
  ConsumerState<_PlaySoundButton> createState() => _PlaySoundButtonState();
}

class _PlaySoundButtonState extends ConsumerState<_PlaySoundButton> {
  bool _isPlaying = false;
  bool _showTooltip = false;

  Future<void> _toggleSound() async {
    final soundService = ref.read(locatorSoundServiceProvider);

    if (_isPlaying) {
      await soundService.stop();
      setState(() => _isPlaying = false);
    } else {
      setState(() => _isPlaying = true);
      try {
        await soundService.playLocatorSound();
        // Auto-stop after 10 seconds
        await Future.delayed(const Duration(seconds: 10));
        if (mounted) {
          setState(() => _isPlaying = false);
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isPlaying = false);
        }
      }
    }
  }

  void _showInfo() {
    setState(() => _showTooltip = !_showTooltip);
    if (_showTooltip) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() => _showTooltip = false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        // Info tooltip
        AnimatedOpacity(
          opacity: _showTooltip ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.textMuted.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              l10n.deviceMustBeConnected,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),

        // Play Sound button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: _toggleSound,
            onLongPress: _showInfo,
            style: ElevatedButton.styleFrom(
              backgroundColor: _isPlaying
                  ? AppColors.signalStrong
                  : AppColors.primary.withValues(alpha: 0.2),
              foregroundColor: _isPlaying ? Colors.white : AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            icon: Icon(
              _isPlaying ? Icons.stop_rounded : Icons.volume_up_rounded,
              size: 24,
            ),
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _isPlaying ? l10n.stopSound : l10n.playSound,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _showInfo,
                  child: Icon(
                    Icons.info_outline_rounded,
                    size: 18,
                    color: _isPlaying
                        ? Colors.white.withValues(alpha: 0.7)
                        : AppColors.primary.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
