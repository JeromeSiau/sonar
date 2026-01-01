import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:bluetooth_finder/core/theme/app_colors.dart';
import 'package:bluetooth_finder/features/scanner/data/models/bluetooth_device_model.dart';

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

  /// Returns default txPower calibration value for a device type.
  /// These values represent the expected RSSI at 1 meter distance.
  static int _getDefaultTxPower(DeviceType type) => switch (type) {
    DeviceType.airpods => -59, // Apple standard calibration
    DeviceType.headphones => -55,
    DeviceType.watch => -50,
    DeviceType.speaker => -45,
    DeviceType.other => -59, // Use Apple calibration as default
  };

  /// Calculates signal percentage based on signal loss.
  ///
  /// Uses [txPowerLevel] if provided, otherwise falls back to a default
  /// value based on [type]. The formula uses a sqrt curve to be more
  /// generous for close devices.
  ///
  /// Example with AirPods (txPower = -59):
  /// - -40 dBm → 100% (very close)
  /// - -59 dBm → 100% (1 meter - reference point)
  /// - -70 dBm → 82%  (few meters)
  /// - -80 dBm → 63%  (same room)
  /// - -90 dBm → 0%   (far)
  static int getSignalPercentage(
    int rssi, {
    int? txPowerLevel,
    DeviceType type = DeviceType.other,
  }) {
    final txPower = txPowerLevel ?? _getDefaultTxPower(type);

    // If signal is stronger than reference, it's 100%
    if (rssi >= txPower) return 100;

    // Calculate how much weaker the signal is compared to reference
    // At txPower = 100%, at txPower - 40dB = 0%
    const maxLoss = 40.0; // 40 dB loss = 0%
    final signalLoss = (txPower - rssi).toDouble();

    if (signalLoss >= maxLoss) return 0;

    // Normalize and apply sqrt curve for more generous close values
    final normalized = 1.0 - (signalLoss / maxLoss);
    return (math.sqrt(normalized) * 100).round();
  }
}
