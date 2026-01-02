import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:bluetooth_finder/core/theme/app_colors.dart';
import 'package:bluetooth_finder/core/utils/rssi_utils.dart';
import 'package:bluetooth_finder/features/scanner/data/models/bluetooth_device_model.dart';
import 'package:bluetooth_finder/l10n/app_localizations.dart';

class RadarWidget extends StatefulWidget {
  final int rssi;
  final String deviceName;
  final DeviceType deviceType;

  const RadarWidget({
    super.key,
    required this.rssi,
    required this.deviceName,
    this.deviceType = DeviceType.other,
  });

  @override
  State<RadarWidget> createState() => _RadarWidgetState();
}

class _RadarWidgetState extends State<RadarWidget>
    with TickerProviderStateMixin {
  late AnimationController _sweepController;
  late AnimationController _pingController;
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    // Sweep rotation - smooth 360° rotation
    _sweepController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat();

    // Ping expanding rings
    _pingController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    // Center glow pulsing
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _sweepController.dispose();
    _pingController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final signalColor = RssiUtils.getSignalColor(widget.rssi);
    final percentage = RssiUtils.getSignalPercentage(
      widget.rssi,
      type: widget.deviceType,
    );
    final distance = RssiUtils.getDistanceEstimate(widget.rssi);
    final screenWidth = MediaQuery.of(context).size.width;
    final radarSize = math.min(screenWidth * 0.85, 320.0);

    return Semantics(
      // Accessibility: describe device, signal percentage, and distance estimate
      label: '${widget.deviceName}, ${l10n.signal} $percentage%, $distance',
      liveRegion: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // === RADAR DISPLAY ===
          // ExcludeSemantics to avoid redundant descriptions of visual elements
          ExcludeSemantics(
            child: RepaintBoundary(
              child: SizedBox(
                width: radarSize,
                height: radarSize,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background glow
                    _buildBackgroundGlow(radarSize, signalColor),
                    // Grid lines
                    CustomPaint(
                      size: Size(radarSize, radarSize),
                      painter: _RadarGridPainter(),
                    ),
                    // Concentric circles
                    _buildConcentricCircles(radarSize, signalColor),
                    // Expanding ping rings
                    _buildPingRings(radarSize, signalColor),
                    // Sweep beam
                    _buildSweepBeam(radarSize, signalColor),
                    // Center device indicator with percentage
                    _buildCenterIndicator(signalColor, percentage, l10n),
                    // CRT scanlines overlay
                    _buildScanlines(radarSize),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 48),

          // === DEVICE INFO ===
          _buildDeviceInfo(context, signalColor, distance, percentage),
        ],
      ),
    );
  }

  Widget _buildBackgroundGlow(double size, Color color) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          width: size * 0.7,
          height: size * 0.7,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                color.withValues(alpha: 0.15 * _glowAnimation.value),
                color.withValues(alpha: 0.05 * _glowAnimation.value),
                Colors.transparent,
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildConcentricCircles(double size, Color color) {
    return Stack(
      alignment: Alignment.center,
      children: List.generate(4, (index) {
        final circleSize = (size * 0.25) + (index * size * 0.2);
        final opacity = 0.4 - (index * 0.08);
        return Container(
          width: circleSize,
          height: circleSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: color.withValues(alpha: opacity),
              width: index == 0 ? 2 : 1,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildPingRings(double size, Color color) {
    return AnimatedBuilder(
      animation: _pingController,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: List.generate(3, (index) {
            final delay = index * 0.33;
            final progress = (_pingController.value + delay) % 1.0;
            final ringSize = size * 0.2 + (progress * size * 0.7);
            final opacity = (1.0 - progress) * 0.5;

            return Container(
              width: ringSize,
              height: ringSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: color.withValues(alpha: opacity),
                  width: 2,
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildSweepBeam(double size, Color color) {
    return AnimatedBuilder(
      animation: _sweepController,
      builder: (context, child) {
        return Transform.rotate(
          angle: _sweepController.value * 2 * math.pi,
          child: ClipOval(
            child: SizedBox(
              width: size,
              height: size,
              child: CustomPaint(painter: _SweepBeamPainter(color: color)),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCenterIndicator(
    Color color,
    int percentage,
    AppLocalizations l10n,
  ) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment(-0.5, -0.5),
              end: Alignment(0.5, 0.5),
              colors: [Color(0xFFFFFFFF), Color(0xFFF0F0F0)],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              // Outer glow based on signal color
              BoxShadow(
                color: color.withValues(alpha: 0.5 * _glowAnimation.value),
                blurRadius: 40 * _glowAnimation.value,
                spreadRadius: 5 * _glowAnimation.value,
              ),
              // Subtle shadow for depth
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 20,
                spreadRadius: 2,
              ),
              // Inner highlight (inset effect simulated with positioned gradient)
            ],
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$percentage%',
                  style: TextStyle(
                    fontFamily: 'SF Mono',
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: color,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.signal,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF666666),
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildScanlines(double size) {
    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(painter: _ScanlinesPainter()),
      ),
    );
  }

  Widget _buildDeviceInfo(
    BuildContext context,
    Color signalColor,
    String distance,
    int percentage,
  ) {
    return Column(
      children: [
        // RSSI value - small for technical users
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: signalColor.withValues(alpha: 0.7),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '${widget.rssi} dBm',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textSecondary.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// === CUSTOM PAINTERS ===

class _RadarGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = AppColors.gridLine.withValues(alpha: 0.3)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    // Draw cross lines
    canvas.drawLine(
      Offset(center.dx, 0),
      Offset(center.dx, size.height),
      paint,
    );
    canvas.drawLine(Offset(0, center.dy), Offset(size.width, center.dy), paint);

    // Draw diagonal lines
    canvas.drawLine(
      Offset(size.width * 0.15, size.height * 0.15),
      Offset(size.width * 0.85, size.height * 0.85),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.85, size.height * 0.15),
      Offset(size.width * 0.15, size.height * 0.85),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SweepBeamPainter extends CustomPainter {
  final Color color;

  _SweepBeamPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Create sweep gradient for the beam
    final sweepGradient = ui.Gradient.sweep(
      center,
      [
        Colors.transparent,
        Colors.transparent,
        color.withValues(alpha: 0.02),
        color.withValues(alpha: 0.15),
        color.withValues(alpha: 0.4),
        color,
      ],
      [0.0, 0.5, 0.7, 0.85, 0.95, 1.0],
      TileMode.clamp,
      0,
      math.pi / 6,
    );

    final paint = Paint()
      ..shader = sweepGradient
      ..style = PaintingStyle.fill;

    // Draw the sweep sector
    final path = Path()
      ..moveTo(center.dx, center.dy)
      ..lineTo(center.dx + radius, center.dy)
      ..arcTo(
        Rect.fromCircle(center: center, radius: radius),
        0,
        math.pi / 6,
        false,
      )
      ..close();

    canvas.drawPath(path, paint);

    // Draw the bright edge line
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    canvas.drawLine(center, Offset(center.dx + radius, center.dy), linePaint);
  }

  @override
  bool shouldRepaint(covariant _SweepBeamPainter oldDelegate) =>
      color != oldDelegate.color;
}

class _ScanlinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.background.withValues(alpha: 0.1)
      ..strokeWidth = 1;

    // Draw horizontal scanlines for CRT effect
    for (double y = 0; y < size.height; y += 3) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
