import 'package:flutter/material.dart';
import 'package:bluetooth_finder/core/theme/app_colors.dart';

enum SignalStrength { strong, medium, weak }

abstract final class RssiUtils {
  static SignalStrength getSignalStrength(int rssi) {
    if (rssi > -50) return SignalStrength.strong;
    if (rssi > -70) return SignalStrength.medium;
    return SignalStrength.weak;
  }

  static Color getSignalColor(int rssi) {
    return switch (getSignalStrength(rssi)) {
      SignalStrength.strong => AppColors.signalStrong,
      SignalStrength.medium => AppColors.signalMedium,
      SignalStrength.weak => AppColors.signalWeak,
    };
  }

  static String getDistanceEstimate(int rssi) {
    return switch (getSignalStrength(rssi)) {
      SignalStrength.strong => '< 1m',
      SignalStrength.medium => '1-5m',
      SignalStrength.weak => '> 5m',
    };
  }

  static int getSignalPercentage(int rssi) {
    // RSSI typically ranges from -30 (strongest) to -100 (weakest)
    const minRssi = -100;
    const maxRssi = -30;
    final clamped = rssi.clamp(minRssi, maxRssi);
    return ((clamped - minRssi) / (maxRssi - minRssi) * 100).round();
  }
}
