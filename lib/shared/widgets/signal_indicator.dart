import 'package:flutter/material.dart';
import 'package:bluetooth_finder/core/theme/app_colors.dart';
import 'package:bluetooth_finder/core/utils/rssi_utils.dart';

class SignalIndicator extends StatefulWidget {
  final int rssi;
  final bool showDistance;
  final double height;
  final bool animate;

  const SignalIndicator({
    super.key,
    required this.rssi,
    this.showDistance = true,
    this.height = 20,
    this.animate = true,
  });

  @override
  State<SignalIndicator> createState() => _SignalIndicatorState();
}

class _SignalIndicatorState extends State<SignalIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.animate) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = RssiUtils.getSignalColor(widget.rssi);
    final percentage = RssiUtils.getSignalPercentage(widget.rssi);
    final distance = RssiUtils.getDistanceEstimate(widget.rssi);
    final signalStrength = RssiUtils.getSignalStrength(widget.rssi);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Signal bars with glow effect
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Container(
              decoration: signalStrength == SignalStrength.strong
                  ? BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(
                              alpha: 0.3 * _pulseAnimation.value),
                          blurRadius: 8,
                          spreadRadius: 0,
                        ),
                      ],
                    )
                  : null,
              child: SizedBox(
                width: 36,
                height: widget.height,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(4, (index) {
                    final barHeight = (index + 1) / 4 * widget.height;
                    final isActive = percentage > index * 25;
                    final isTopBar = index == 3 && isActive;

                    return Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                        margin: const EdgeInsets.symmetric(horizontal: 1.5),
                        height: barHeight,
                        decoration: BoxDecoration(
                          gradient: isActive
                              ? LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    color.withValues(alpha: 0.7),
                                    color,
                                  ],
                                )
                              : null,
                          color: isActive
                              ? null
                              : AppColors.surfaceLight.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(3),
                          boxShadow: isTopBar && widget.animate
                              ? [
                                  BoxShadow(
                                    color: color.withValues(
                                        alpha: 0.4 * _pulseAnimation.value),
                                    blurRadius: 4,
                                    spreadRadius: 0,
                                  ),
                                ]
                              : null,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            );
          },
        ),

        if (widget.showDistance) ...[
          const SizedBox(width: 10),
          // Distance pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: color.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Text(
              distance,
              style: TextStyle(
                fontFamily: 'SF Mono',
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Compact signal indicator for tight spaces
class SignalDots extends StatelessWidget {
  final int rssi;

  const SignalDots({super.key, required this.rssi});

  @override
  Widget build(BuildContext context) {
    final color = RssiUtils.getSignalColor(rssi);
    final percentage = RssiUtils.getSignalPercentage(rssi);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        final isActive = percentage > (index + 1) * 25;
        return Container(
          width: 6,
          height: 6,
          margin: EdgeInsets.only(left: index > 0 ? 3 : 0),
          decoration: BoxDecoration(
            color: isActive ? color : color.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}
