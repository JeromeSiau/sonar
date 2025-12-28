import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bluetooth_finder/core/utils/rssi_utils.dart';
import 'package:bluetooth_finder/core/theme/app_colors.dart';

void main() {
  group('RssiUtils', () {
    group('getSignalStrength', () {
      test('returns strong for RSSI > -50', () {
        expect(RssiUtils.getSignalStrength(-30), SignalStrength.strong);
        expect(RssiUtils.getSignalStrength(-49), SignalStrength.strong);
      });

      test('returns medium for RSSI between -50 and -70', () {
        expect(RssiUtils.getSignalStrength(-50), SignalStrength.medium);
        expect(RssiUtils.getSignalStrength(-60), SignalStrength.medium);
        expect(RssiUtils.getSignalStrength(-69), SignalStrength.medium);
      });

      test('returns weak for RSSI < -70', () {
        expect(RssiUtils.getSignalStrength(-70), SignalStrength.weak);
        expect(RssiUtils.getSignalStrength(-90), SignalStrength.weak);
      });
    });

    group('getSignalColor', () {
      test('returns green for strong signal', () {
        expect(RssiUtils.getSignalColor(-30), AppColors.signalStrong);
      });

      test('returns orange for medium signal', () {
        expect(RssiUtils.getSignalColor(-60), AppColors.signalMedium);
      });

      test('returns red for weak signal', () {
        expect(RssiUtils.getSignalColor(-80), AppColors.signalWeak);
      });
    });

    group('getDistanceEstimate', () {
      test('returns < 1m for strong signal', () {
        expect(RssiUtils.getDistanceEstimate(-40), '< 1m');
      });

      test('returns 1-5m for medium signal', () {
        expect(RssiUtils.getDistanceEstimate(-60), '1-5m');
      });

      test('returns > 5m for weak signal', () {
        expect(RssiUtils.getDistanceEstimate(-80), '> 5m');
      });
    });

    group('getSignalPercentage', () {
      test('returns 100 for very strong signal', () {
        expect(RssiUtils.getSignalPercentage(-30), 100);
      });

      test('returns 0 for very weak signal', () {
        expect(RssiUtils.getSignalPercentage(-100), 0);
      });

      test('returns value between 0-100 for normal signals', () {
        final percentage = RssiUtils.getSignalPercentage(-65);
        expect(percentage, greaterThan(0));
        expect(percentage, lessThan(100));
      });
    });
  });
}
