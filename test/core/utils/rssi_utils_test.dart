import 'package:flutter_test/flutter_test.dart';
import 'package:bluetooth_finder/core/utils/rssi_utils.dart';
import 'package:bluetooth_finder/core/theme/app_colors.dart';
import 'package:bluetooth_finder/features/scanner/data/models/bluetooth_device_model.dart';

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
      test('returns 100% when RSSI equals txPowerLevel (0 dB loss)', () {
        expect(RssiUtils.getSignalPercentage(-59, txPowerLevel: -59), 100);
        expect(RssiUtils.getSignalPercentage(-50, txPowerLevel: -50), 100);
      });

      test('returns 0% when signal loss is 45 dB or more', () {
        // txPower -55, RSSI -100 = 45 dB loss
        expect(RssiUtils.getSignalPercentage(-100, txPowerLevel: -55), 0);
        // txPower -59, RSSI -110 = 51 dB loss (clamped to 0)
        expect(RssiUtils.getSignalPercentage(-110, txPowerLevel: -59), 0);
      });

      test('calculates intermediate percentages correctly', () {
        // txPower -59, RSSI -60 = 1 dB loss = (45-1)/45*100 = 98%
        expect(RssiUtils.getSignalPercentage(-60, txPowerLevel: -59), 98);
        // txPower -55, RSSI -78 = 23 dB loss = (45-23)/45*100 = 49%
        expect(RssiUtils.getSignalPercentage(-78, txPowerLevel: -55), 49);
      });

      test(
        'uses default txPower for DeviceType when txPowerLevel not provided',
        () {
          // AirPods default txPower = -59, RSSI -59 = 0 dB loss = 100%
          expect(
            RssiUtils.getSignalPercentage(-59, type: DeviceType.airpods),
            100,
          );
          // Speaker default txPower = -45, RSSI -50 = 5 dB loss = (45-5)/45*100 = 89%
          expect(
            RssiUtils.getSignalPercentage(-50, type: DeviceType.speaker),
            89,
          );
          // Watch default txPower = -50, RSSI -60 = 10 dB loss = (45-10)/45*100 = 78%
          expect(
            RssiUtils.getSignalPercentage(-60, type: DeviceType.watch),
            78,
          );
        },
      );

      test('explicit txPowerLevel overrides DeviceType default', () {
        // Even with airpods type, explicit txPower takes precedence
        expect(
          RssiUtils.getSignalPercentage(
            -50,
            txPowerLevel: -50,
            type: DeviceType.airpods,
          ),
          100,
        );
      });

      test('uses other device default when no type specified', () {
        // Default (other) txPower = -55, RSSI -55 = 0 dB loss = 100%
        expect(RssiUtils.getSignalPercentage(-55), 100);
      });
    });
  });
}
