import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bluetooth_finder/core/theme/app_colors.dart';
import 'package:bluetooth_finder/features/scanner/presentation/providers/scanner_provider.dart';
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
    final device = ref.watch(selectedDeviceProvider);
    final rssiAsync = ref.watch(deviceRssiStreamProvider(widget.deviceId));
    final isFavorite = ref.watch(isFavoriteProvider(widget.deviceId));
    final l10n = AppLocalizations.of(context)!;

    if (device == null) {
      return Scaffold(
        body: Center(child: Text(l10n.deviceNotFound)),
      );
    }

    return Scaffold(
      appBar: _showCelebration
          ? null
          : AppBar(
              title: Text(device.name),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: HeartButton(
                    isFavorite: isFavorite,
                    size: 28,
                    onPressed: () {
                      ref.read(favoritesProvider.notifier).toggleFavorite(device);
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
                      deviceName: device.name,
                    ),
                    loading: () => RadarWidget(
                      rssi: device.rssi,
                      deviceName: device.name,
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
}
