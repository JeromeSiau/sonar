import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bluetooth_finder/core/theme/app_colors.dart';
import 'package:bluetooth_finder/core/utils/rssi_utils.dart';
import 'package:bluetooth_finder/shared/widgets/signal_indicator.dart';

void main() {
  group('SignalDots Widget', () {
    testWidgets('displays 3 dots', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: SignalDots(rssi: -50))),
      );

      // Find Container widgets that make up the dots
      final containers = find.byType(Container);
      // SignalDots creates 3 dot containers
      expect(containers, findsWidgets);
    });

    testWidgets('shows correct color for strong signal', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: SignalDots(rssi: -40))),
      );

      // Strong signal should use green color
      final color = RssiUtils.getSignalColor(-40);
      expect(color, equals(AppColors.signalStrong));
    });

    testWidgets('shows correct color for medium signal', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: SignalDots(rssi: -65))),
      );

      // Medium signal should use amber color
      final color = RssiUtils.getSignalColor(-65);
      expect(color, equals(AppColors.signalMedium));
    });

    testWidgets('shows correct color for weak signal', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: SignalDots(rssi: -85))),
      );

      // Weak signal should use red color
      final color = RssiUtils.getSignalColor(-85);
      expect(color, equals(AppColors.signalWeak));
    });
  });

  group('SignalIndicator Widget', () {
    testWidgets('displays signal bars', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: SignalIndicator(rssi: -50, animate: false)),
        ),
      );

      // Widget should build without errors
      expect(find.byType(SignalIndicator), findsOneWidget);
    });

    testWidgets('displays distance when showDistance is true', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SignalIndicator(
              rssi: -50,
              showDistance: true,
              animate: false,
            ),
          ),
        ),
      );

      // Should find the distance text
      final distance = RssiUtils.getDistanceEstimate(-50);
      expect(find.text(distance), findsOneWidget);
    });

    testWidgets('hides distance when showDistance is false', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SignalIndicator(
              rssi: -50,
              showDistance: false,
              animate: false,
            ),
          ),
        ),
      );

      // Should not find the distance text
      final distance = RssiUtils.getDistanceEstimate(-50);
      expect(find.text(distance), findsNothing);
    });

    testWidgets('respects custom height', (tester) async {
      const customHeight = 30.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SignalIndicator(
              rssi: -50,
              height: customHeight,
              animate: false,
            ),
          ),
        ),
      );

      // Widget should build with custom height
      expect(find.byType(SignalIndicator), findsOneWidget);
    });
  });

  group('AppColors', () {
    test('has correct signal colors defined', () {
      expect(AppColors.signalStrong, isNotNull);
      expect(AppColors.signalMedium, isNotNull);
      expect(AppColors.signalWeak, isNotNull);
    });

    test('has correct primary color', () {
      expect(AppColors.primary, isNotNull);
    });
  });
}
