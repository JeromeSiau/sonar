import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:bluetooth_finder/core/theme/app_colors.dart';
import 'package:bluetooth_finder/core/utils/rssi_utils.dart';

class RadarWidget extends StatefulWidget {
  final int rssi;
  final String deviceName;

  const RadarWidget({
    super.key,
    required this.rssi,
    required this.deviceName,
  });

  @override
  State<RadarWidget> createState() => _RadarWidgetState();
}

class _RadarWidgetState extends State<RadarWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _sweepController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _sweepController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _sweepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final signalColor = RssiUtils.getSignalColor(widget.rssi);
    final percentage = RssiUtils.getSignalPercentage(widget.rssi);
    final distance = RssiUtils.getDistanceEstimate(widget.rssi);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Radar circles
        SizedBox(
          width: 300,
          height: 300,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Concentric circles
              ...List.generate(4, (index) {
                final size = 75.0 + (index * 60);
                return AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Container(
                      width: size * (index == 3 ? _pulseAnimation.value : 1),
                      height: size * (index == 3 ? _pulseAnimation.value : 1),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: signalColor.withOpacity(0.3 - (index * 0.05)),
                          width: 2,
                        ),
                      ),
                    );
                  },
                );
              }),
              // Sweep line
              AnimatedBuilder(
                animation: _sweepController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _sweepController.value * 2 * math.pi,
                    child: Container(
                      width: 280,
                      height: 2,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            signalColor.withOpacity(0.5),
                            signalColor,
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              // Center dot (device)
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: signalColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: signalColor.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        // Device name
        Text(
          widget.deviceName,
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        // Distance estimate
        Text(
          distance,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: signalColor,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        // Signal strength bar
        SizedBox(
          width: 200,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: AppColors.surfaceLight,
              valueColor: AlwaysStoppedAnimation<Color>(signalColor),
              minHeight: 8,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${widget.rssi} dBm',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
