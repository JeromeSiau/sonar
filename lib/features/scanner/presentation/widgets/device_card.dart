import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bluetooth_finder/core/theme/app_colors.dart';
import 'package:bluetooth_finder/core/utils/rssi_utils.dart';
import 'package:bluetooth_finder/features/scanner/data/models/bluetooth_device_model.dart';
import 'package:bluetooth_finder/features/favorites/presentation/providers/favorites_provider.dart';
import 'package:bluetooth_finder/shared/widgets/heart_button.dart';
import 'package:bluetooth_finder/shared/widgets/signal_indicator.dart';

class DeviceCard extends ConsumerStatefulWidget {
  final BluetoothDeviceModel device;
  final VoidCallback onTap;

  const DeviceCard({
    super.key,
    required this.device,
    required this.onTap,
  });

  @override
  ConsumerState<DeviceCard> createState() => _DeviceCardState();
}

class _DeviceCardState extends ConsumerState<DeviceCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.3, end: 0.6).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  IconData _getDeviceIcon() {
    return switch (widget.device.type) {
      DeviceType.airpods => Icons.headphones_rounded,
      DeviceType.headphones => Icons.headset_rounded,
      DeviceType.watch => Icons.watch_rounded,
      DeviceType.speaker => Icons.speaker_rounded,
      DeviceType.other => Icons.bluetooth_rounded,
    };
  }

  @override
  Widget build(BuildContext context) {
    final isFavorite = ref.watch(isFavoriteProvider(widget.device.id));
    final favoritesNotifier = ref.read(favoritesProvider.notifier);
    final signalColor = RssiUtils.getSignalColor(widget.device.rssi);
    final signalStrength = RssiUtils.getSignalStrength(widget.device.rssi);

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          return AnimatedScale(
            scale: _isPressed ? 0.98 : 1.0,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOut,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                // Glow effect based on signal strength
                boxShadow: signalStrength == SignalStrength.strong
                    ? [
                        BoxShadow(
                          color: signalColor
                              .withValues(alpha: 0.2 * _glowAnimation.value),
                          blurRadius: 20,
                          spreadRadius: 0,
                        ),
                      ]
                    : null,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: signalStrength == SignalStrength.strong
                            ? signalColor.withValues(alpha: 0.3)
                            : AppColors.glassBorder,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Device icon with animated background
                        _buildDeviceIcon(signalColor),
                        const SizedBox(width: 16),
                        // Device info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.device.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      letterSpacing: -0.3,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              SignalIndicator(rssi: widget.device.rssi),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Heart button
                        HeartButton(
                          isFavorite: isFavorite,
                          onPressed: () =>
                              favoritesNotifier.toggleFavorite(widget.device),
                        ),
                        const SizedBox(width: 8),
                        // Arrow indicator
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLight.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.chevron_right_rounded,
                            color: AppColors.textSecondary,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDeviceIcon(Color signalColor) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.surfaceGlow,
                AppColors.surfaceLight,
              ],
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: signalColor.withValues(alpha: 0.15 * _glowAnimation.value),
                blurRadius: 12,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Icon(
            _getDeviceIcon(),
            color: AppColors.primary,
            size: 26,
          ),
        );
      },
    );
  }
}
