import 'package:flutter/material.dart';
import 'package:bluetooth_finder/core/utils/rssi_utils.dart';

class SignalIndicator extends StatelessWidget {
  final int rssi;
  final bool showDistance;
  final double height;

  const SignalIndicator({
    super.key,
    required this.rssi,
    this.showDistance = true,
    this.height = 24,
  });

  @override
  Widget build(BuildContext context) {
    final color = RssiUtils.getSignalColor(rssi);
    final percentage = RssiUtils.getSignalPercentage(rssi);
    final distance = RssiUtils.getDistanceEstimate(rssi);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Signal bars
        SizedBox(
          width: 32,
          height: height,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(4, (index) {
              final barHeight = (index + 1) / 4 * height;
              final isActive = percentage > index * 25;
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  height: barHeight,
                  decoration: BoxDecoration(
                    color: isActive ? color : color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
        ),
        if (showDistance) ...[
          const SizedBox(width: 8),
          Text(
            distance,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}
