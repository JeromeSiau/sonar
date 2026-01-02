import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:bluetooth_finder/core/theme/app_colors.dart';
import 'package:bluetooth_finder/features/scanner/presentation/providers/scanner_provider.dart';
import 'package:bluetooth_finder/features/scanner/presentation/widgets/device_card.dart';
import 'package:bluetooth_finder/features/scanner/presentation/widgets/section_header.dart';
import 'package:bluetooth_finder/features/paywall/presentation/providers/subscription_provider.dart'
    show isPremiumProvider, canAccessRadarProvider, radarTrialUsedProvider;
import 'package:bluetooth_finder/shared/widgets/staggered_list_item.dart';
import 'package:bluetooth_finder/l10n/app_localizations.dart';

class ScannerScreen extends ConsumerStatefulWidget {
  const ScannerScreen({super.key});

  @override
  ConsumerState<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends ConsumerState<ScannerScreen> {
  @override
  void initState() {
    super.initState();
    // Defer scan to avoid modifying provider during build
    Future.microtask(_startScan);
  }

  Future<void> _startScan() async {
    if (!mounted) return;
    final repo = ref.read(bluetoothRepositoryProvider);
    ref.read(isScanningProvider.notifier).state = true;
    await repo.startScan();
    if (mounted) {
      ref.read(isScanningProvider.notifier).state = false;
    }
  }

  @override
  void dispose() {
    ref.read(bluetoothRepositoryProvider).stopScan();
    super.dispose();
  }

  void _onDeviceTap(BuildContext context, WidgetRef ref, device) {
    final canAccessRadar = ref.read(canAccessRadarProvider);
    final isPremium = ref.read(isPremiumProvider);

    ref.read(selectedDeviceProvider.notifier).state = device;

    if (canAccessRadar) {
      // If free user using trial, mark it as used
      if (!isPremium) {
        ref.read(radarTrialUsedProvider.notifier).useRadarTrial();
      }
      context.push('/radar/${device.id}');
    } else {
      // Show paywall
      context.push('/paywall');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isScanning = ref.watch(isScanningProvider);
    final isPremium = ref.watch(isPremiumProvider);
    final bluetoothState = ref.watch(bluetoothAdapterStateProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(l10n.scanner),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: bluetoothState.when(
            data: (state) {
              if (state != BluetoothAdapterState.on) {
                return _buildBluetoothOffState(l10n);
              }
              return _buildScannerContent(context, isScanning, isPremium, l10n);
            },
            loading: () => _SonarSearchAnimation(isScanning: isScanning, l10n: l10n),
            error: (_, __) => _buildErrorState(l10n),
          ),
        ),
      ),
    );
  }

  Widget _buildBluetoothOffState(AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.bluetooth_disabled_rounded,
                size: 50,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              l10n.bluetoothDisabled,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.enableBluetoothDescription,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () async {
                await FlutterBluePlus.turnOn();
              },
              icon: const Icon(Icons.bluetooth_rounded),
              label: Text(l10n.openSettings),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScannerContent(
    BuildContext context,
    bool isScanning,
    bool isPremium,
    AppLocalizations l10n,
  ) {
    final myDevices = ref.watch(myDevicesProvider);
    final nearbyDevices = ref.watch(nearbyDevicesProvider);
    final allDevicesEmpty = myDevices.isEmpty && nearbyDevices.isEmpty;

    if (allDevicesEmpty && isScanning) {
      return _SonarSearchAnimation(isScanning: isScanning, l10n: l10n);
    }

    final trialUsed = ref.watch(radarTrialUsedProvider);

    return Column(
      children: [
        // Mini sonar at top when scanning with results
        if (isScanning && !allDevicesEmpty)
          _MiniSonarIndicator(l10n: l10n),
        // Show trial status for free users
        if (!isPremium)
          _buildTrialBanner(context, trialUsed, l10n),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _startScan,
            color: AppColors.primary,
            backgroundColor: AppColors.surface,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              children: [
                // My devices section
                if (myDevices.isNotEmpty) ...[
                  SectionHeader(
                    icon: Icons.smartphone_rounded,
                    title: l10n.myDevices,
                    count: myDevices.length,
                  ),
                  for (var i = 0; i < myDevices.length; i++)
                    StaggeredListItem(
                      index: i,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: DeviceCard(
                          device: myDevices[i],
                          onTap: () => _onDeviceTap(context, ref, myDevices[i]),
                        ),
                      ),
                    ),
                ],
                // Nearby devices section
                if (nearbyDevices.isNotEmpty) ...[
                  SectionHeader(
                    icon: Icons.radar_rounded,
                    title: l10n.nearbyDevices,
                    count: nearbyDevices.length,
                  ),
                  for (var i = 0; i < nearbyDevices.length; i++)
                    StaggeredListItem(
                      index: myDevices.length + i,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: DeviceCard(
                          device: nearbyDevices[i],
                          onTap: () => _onDeviceTap(context, ref, nearbyDevices[i]),
                        ),
                      ),
                    ),
                ],
                // Empty state
                if (allDevicesEmpty && !isScanning)
                  _buildEmptyState(l10n),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.bluetooth_searching_rounded,
              size: 48,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.noDevicesFound,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.signalWeak.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 40,
                color: AppColors.signalWeak,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.scanError,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.checkBluetoothEnabled,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _startScan,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(l10n.retry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrialBanner(BuildContext context, bool trialUsed, AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: trialUsed
            ? AppColors.surface
            : AppColors.signalStrong.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: trialUsed
              ? AppColors.textSecondary.withValues(alpha: 0.2)
              : AppColors.signalStrong.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            trialUsed ? Icons.radar : Icons.card_giftcard_rounded,
            color: trialUsed ? AppColors.textSecondary : AppColors.signalStrong,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              trialUsed
                  ? l10n.trialUsed
                  : l10n.trialAvailable,
              style: TextStyle(
                color: trialUsed ? AppColors.textSecondary : AppColors.signalStrong,
                fontWeight: trialUsed ? FontWeight.normal : FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          if (trialUsed)
            TextButton(
              onPressed: () => context.push('/paywall'),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                l10n.unlock,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

}

// === SONAR SEARCH ANIMATION ===
class _SonarSearchAnimation extends StatefulWidget {
  final bool isScanning;
  final AppLocalizations l10n;

  const _SonarSearchAnimation({required this.isScanning, required this.l10n});

  @override
  State<_SonarSearchAnimation> createState() => _SonarSearchAnimationState();
}

class _SonarSearchAnimationState extends State<_SonarSearchAnimation>
    with TickerProviderStateMixin {
  late AnimationController _sweepController;
  late AnimationController _pingController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();

    _sweepController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _pingController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _sweepController.dispose();
    _pingController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final sonarSize = math.min(screenWidth * 0.8, 300.0);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Sonar display
          RepaintBoundary(
            child: SizedBox(
              width: sonarSize,
              height: sonarSize,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Grid
                  CustomPaint(
                    size: Size(sonarSize, sonarSize),
                    painter: _SonarGridPainter(),
                  ),
                  // Concentric circles
                  _buildConcentricCircles(sonarSize),
                  // Ping waves
                  _buildPingWaves(sonarSize),
                  // Sweep beam
                  _buildSweepBeam(sonarSize),
                  // Center pulse
                  _buildCenterPulse(),
                ],
              ),
            ),
          ),

          const SizedBox(height: 48),

          // Status text
          Text(
            widget.l10n.scanning,
            style: TextStyle(
              fontFamily: 'SF Mono',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: 6,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Opacity(
                opacity: 0.5 + (_pulseController.value * 0.5),
                child: Text(
                  widget.l10n.searchingDevices,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildConcentricCircles(double size) {
    return Stack(
      alignment: Alignment.center,
      children: List.generate(4, (index) {
        final circleSize = (size * 0.2) + (index * size * 0.2);
        final opacity = 0.4 - (index * 0.08);
        return Container(
          width: circleSize,
          height: circleSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primary.withValues(alpha: opacity),
              width: index == 0 ? 2 : 1,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildPingWaves(double size) {
    return AnimatedBuilder(
      animation: _pingController,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: List.generate(3, (index) {
            final delay = index * 0.33;
            final progress = (_pingController.value + delay) % 1.0;
            final waveSize = size * 0.15 + (progress * size * 0.75);
            final opacity = (1.0 - progress) * 0.6;

            return Container(
              width: waveSize,
              height: waveSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: opacity),
                  width: 2.5 * (1 - progress) + 0.5,
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildSweepBeam(double size) {
    return AnimatedBuilder(
      animation: _sweepController,
      builder: (context, child) {
        return Transform.rotate(
          angle: _sweepController.value * 2 * math.pi,
          child: ClipOval(
            child: SizedBox(
              width: size,
              height: size,
              child: CustomPaint(
                painter: _SweepBeamPainter(
                  color: AppColors.primary,
                  sweepAngle: math.pi / 4,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCenterPulse() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final scale = 0.9 + (_pulseController.value * 0.2);
        return Transform.scale(
          scale: scale,
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.6),
                  blurRadius: 20,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Mini sonar indicator when results are showing
class _MiniSonarIndicator extends StatefulWidget {
  final AppLocalizations l10n;

  const _MiniSonarIndicator({required this.l10n});

  @override
  State<_MiniSonarIndicator> createState() => _MiniSonarIndicatorState();
}

class _MiniSonarIndicatorState extends State<_MiniSonarIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          // Mini animated radar
          RepaintBoundary(
            child: SizedBox(
              width: 32,
              height: 32,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _MiniRadarPainter(
                      progress: _controller.value,
                      color: AppColors.primary,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            widget.l10n.scanInProgress,
            style: TextStyle(
              color: AppColors.primary,
              fontFamily: 'SF Mono',
              fontSize: 12,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

// === CUSTOM PAINTERS ===

class _SonarGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = AppColors.gridLine.withValues(alpha: 0.3)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    // Cross lines
    canvas.drawLine(Offset(center.dx, 0), Offset(center.dx, size.height), paint);
    canvas.drawLine(Offset(0, center.dy), Offset(size.width, center.dy), paint);

    // Diagonal lines
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
  final double sweepAngle;

  _SweepBeamPainter({required this.color, required this.sweepAngle});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Sweep gradient
    final gradient = ui.Gradient.sweep(
      center,
      [
        Colors.transparent,
        Colors.transparent,
        color.withValues(alpha: 0.02),
        color.withValues(alpha: 0.1),
        color.withValues(alpha: 0.3),
        color,
      ],
      [0.0, 0.4, 0.6, 0.8, 0.95, 1.0],
      TileMode.clamp,
      0,
      sweepAngle,
    );

    final paint = Paint()
      ..shader = gradient
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(center.dx, center.dy)
      ..lineTo(center.dx + radius, center.dy)
      ..arcTo(
        Rect.fromCircle(center: center, radius: radius),
        0,
        sweepAngle,
        false,
      )
      ..close();

    canvas.drawPath(path, paint);

    // Bright edge line
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    canvas.drawLine(center, Offset(center.dx + radius, center.dy), linePaint);
  }

  @override
  bool shouldRepaint(covariant _SweepBeamPainter oldDelegate) => false;
}

class _MiniRadarPainter extends CustomPainter {
  final double progress;
  final Color color;

  _MiniRadarPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw circles
    final circlePaint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius * 0.5, circlePaint);
    canvas.drawCircle(center, radius, circlePaint);

    // Draw sweep line
    final angle = progress * 2 * math.pi;
    final endX = center.dx + radius * math.cos(angle);
    final endY = center.dy + radius * math.sin(angle);

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(center, Offset(endX, endY), linePaint);

    // Center dot
    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 3, dotPaint);
  }

  @override
  bool shouldRepaint(covariant _MiniRadarPainter oldDelegate) =>
      progress != oldDelegate.progress;
}
