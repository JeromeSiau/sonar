import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bluetooth_finder/core/theme/app_colors.dart';
import 'package:bluetooth_finder/core/utils/rssi_utils.dart';
import 'package:bluetooth_finder/features/scanner/data/models/bluetooth_device_model.dart';
import 'package:bluetooth_finder/features/favorites/presentation/providers/favorites_provider.dart';
import 'package:bluetooth_finder/shared/widgets/heart_button.dart';
import 'package:bluetooth_finder/l10n/app_localizations.dart';

class DeviceCard extends ConsumerStatefulWidget {
  final BluetoothDeviceModel device;
  final VoidCallback onTap;

  const DeviceCard({super.key, required this.device, required this.onTap});

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
    final l10n = AppLocalizations.of(context)!;
    final isFavorite = ref.watch(isFavoriteProvider(widget.device.id));
    final favoritesNotifier = ref.read(favoritesProvider.notifier);
    final signalColor = RssiUtils.getSignalColor(widget.device.rssi);
    final signalStrength = RssiUtils.getSignalStrength(widget.device.rssi);
    final deviceName = widget.device.name.isNotEmpty
        ? widget.device.name
        : l10n.unknownDevice;

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
                          color: signalColor.withValues(
                            alpha: 0.2 * _glowAnimation.value,
                          ),
                          blurRadius: 20,
                          spreadRadius: 0,
                        ),
                      ]
                    : null,
              ),
              // Removed BackdropFilter for GPU performance - blur is expensive per card
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  // Solid color instead of blur for better performance
                  color: AppColors.surface.withValues(alpha: 0.85),
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
                    // Left edge signal indicator (4px colored bar)
                    Container(
                      width: 4,
                      height: 52,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: signalColor,
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: [
                          BoxShadow(
                            color: signalColor.withValues(alpha: 0.4),
                            blurRadius: 6,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                    ),
                    // Device icon with animated background
                    _buildDeviceIcon(signalColor),
                    const SizedBox(width: 14),
                    // Device info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            deviceName,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.3,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            RssiUtils.getDistanceEstimate(widget.device.rssi),
                            style: TextStyle(
                              fontFamily: 'SF Mono',
                              fontSize: 12,
                              color: signalColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Circular signal ring
                    _CircularSignalRing(
                      percentage: RssiUtils.getSignalPercentage(
                        widget.device.rssi,
                        type: widget.device.type,
                      ),
                      color: signalColor,
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
              colors: [AppColors.surfaceGlow, AppColors.surfaceLight],
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: signalColor.withValues(
                  alpha: 0.15 * _glowAnimation.value,
                ),
                blurRadius: 12,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Icon(_getDeviceIcon(), color: AppColors.primary, size: 26),
        );
      },
    );
  }
}

/// Circular signal ring indicator with percentage
class _CircularSignalRing extends StatelessWidget {
  final int percentage;
  final Color color;

  const _CircularSignalRing({required this.percentage, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 44,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background track
          CustomPaint(
            size: const Size(44, 44),
            painter: _CircularProgressPainter(
              progress: 1.0,
              color: AppColors.surfaceLight.withValues(alpha: 0.3),
              strokeWidth: 3,
            ),
          ),
          // Active arc
          CustomPaint(
            size: const Size(44, 44),
            painter: _CircularProgressPainter(
              progress: percentage / 100,
              color: color,
              strokeWidth: 3,
            ),
          ),
          // Percentage text
          Text(
            '$percentage',
            style: TextStyle(
              fontFamily: 'SF Mono',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for circular progress arc
class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  _CircularProgressPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw arc from top (-90 degrees) going clockwise
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Start from top
      2 * math.pi * progress, // Sweep angle
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _CircularProgressPainter oldDelegate) {
    return progress != oldDelegate.progress || color != oldDelegate.color;
  }
}
