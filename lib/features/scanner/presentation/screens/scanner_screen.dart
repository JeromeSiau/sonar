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
    Future.microtask(_startScan);
  }

  Future<void> _startScan() async {
    if (!mounted) return;
    ref.read(isScanningProvider.notifier).state = true;
    await ref.read(bluetoothRepositoryProvider).startScan();
  }

  // No dispose needed - scan will be stopped by provider when app closes
  // Trying to access ref in dispose causes StateError

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

    // Activate auto-update of favorite locations when scanning
    ref.watch(favoriteLocationUpdaterProvider);

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
            loading: () =>
                _SonarSearchAnimation(isScanning: isScanning, l10n: l10n),
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
    final devices = ref.watch(allDevicesProvider);
    final isEmpty = devices.isEmpty;

    if (isEmpty && isScanning) {
      return _SonarSearchAnimation(isScanning: isScanning, l10n: l10n);
    }

    final trialUsed = ref.watch(radarTrialUsedProvider);

    return Column(
      children: [
        // Mini sonar at top when scanning with results
        if (isScanning && !isEmpty) _MiniSonarIndicator(l10n: l10n),
        // Show trial status for free users
        if (!isPremium) _buildTrialBanner(context, trialUsed, l10n),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _startScan,
            color: AppColors.primary,
            backgroundColor: AppColors.surface,
            child: devices.isNotEmpty
                ? ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                    // +1 for the header
                    itemCount: devices.length + 1,
                    itemBuilder: (context, index) {
                      // First item is the section header
                      if (index == 0) {
                        return SectionHeader(
                          icon: Icons.radar_rounded,
                          title: l10n.nearbyDevices,
                          count: devices.length,
                        );
                      }
                      // Device cards (index - 1 because of header)
                      final deviceIndex = index - 1;
                      final device = devices[deviceIndex];
                      return StaggeredListItem(
                        index: deviceIndex,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: DeviceCard(
                            device: device,
                            onTap: () => _onDeviceTap(context, ref, device),
                          ),
                        ),
                      );
                    },
                  )
                : ListView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                    children: [if (!isScanning) _buildEmptyState(l10n)],
                  ),
          ),
        ),
        // Floating bottom panel
        _buildBottomPanel(context),
      ],
    );
  }

  Widget _buildBottomPanel(BuildContext context) {
    final showUnnamed = ref.watch(showUnnamedDevicesProvider);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Checkbox for unnamed devices
          Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: showUnnamed,
                  onChanged: (value) {
                    ref.read(showUnnamedDevicesProvider.notifier).state =
                        value ?? false;
                  },
                  activeColor: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.showUnnamedDevices,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Help text
          GestureDetector(
            onTap: () => _showHelpDialog(context),
            child: Row(
              children: [
                Icon(
                  Icons.help_outline_rounded,
                  size: 20,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)!.whyDeviceNotVisible,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(l10n.whyDeviceNotVisible),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${l10n.deviceVisibleConditions}\n'),
            Text('• ${l10n.deviceMustBeOn}'),
            Text('• ${l10n.bluetoothMustBeEnabledOnDevice}'),
            Text('• ${l10n.deviceMustBeInRange}'),
            Text('• ${l10n.someDevicesDontBroadcastName}'),
            const SizedBox(height: 12),
            Text(
              l10n.tipShowUnnamedDevices,
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.understood),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 24),
          // Static radar icon (no animation)
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
                width: 2,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Static concentric circles
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      width: 1,
                    ),
                  ),
                ),
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                ),
                // Center dot
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.noDevicesFound,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.checkBluetoothEnabled,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          // Troubleshooting tips
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline_rounded,
                      size: 18,
                      color: AppColors.signalMedium,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.deviceVisibleConditions,
                      style: TextStyle(
                        color: AppColors.signalMedium,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildTipItem(
                  Icons.power_settings_new_rounded,
                  l10n.deviceMustBeOn,
                ),
                const SizedBox(height: 8),
                _buildTipItem(
                  Icons.bluetooth_rounded,
                  l10n.bluetoothMustBeEnabledOnDevice,
                ),
                const SizedBox(height: 8),
                _buildTipItem(Icons.near_me_rounded, l10n.deviceMustBeInRange),
                const SizedBox(height: 8),
                _buildTipItem(
                  Icons.visibility_off_rounded,
                  l10n.someDevicesDontBroadcastName,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Retry button
          ElevatedButton.icon(
            onPressed: _startScan,
            icon: const Icon(Icons.refresh_rounded),
            label: Text(l10n.retry),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              height: 1.3,
            ),
          ),
        ),
      ],
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

  Widget _buildTrialBanner(
    BuildContext context,
    bool trialUsed,
    AppLocalizations l10n,
  ) {
    if (trialUsed) {
      // Trial used - show upgrade prompt
      return Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.textSecondary.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.radar, color: AppColors.textSecondary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l10n.trialUsed,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
            ),
            TextButton(
              onPressed: () => context.push('/paywall'),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
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

    // Free trial available - enhanced two-line banner
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.signalStrong.withValues(alpha: 0.15),
            AppColors.primary.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.signalStrong.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          // Gift icon with glow
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.signalStrong.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.card_giftcard_rounded,
              color: AppColors.signalStrong,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // FREE badge + title row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.signalStrong,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        l10n.free,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          fontSize: 9,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        l10n.trialAvailable,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Subtitle
                Text(
                  l10n.tapDeviceToLocate,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 14,
            color: AppColors.signalStrong,
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

    return Semantics(
      // Accessibility: announce scanning status to screen readers
      label: '${widget.l10n.scanning}. ${widget.l10n.searchingDevices}',
      liveRegion: true,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Sonar display - exclude visual elements from semantics
            ExcludeSemantics(
              child: RepaintBoundary(
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
    with TickerProviderStateMixin {
  late AnimationController _radarController;
  late AnimationController _dotsController;

  @override
  void initState() {
    super.initState();
    _radarController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _dotsController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _radarController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Spinning radar icon
          RepaintBoundary(
            child: SizedBox(
              width: 24,
              height: 24,
              child: AnimatedBuilder(
                animation: _radarController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _radarController.value * 2 * math.pi,
                    child: Icon(
                      Icons.radar_rounded,
                      size: 24,
                      color: AppColors.primary,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            widget.l10n.scanning,
            style: TextStyle(
              color: AppColors.primary,
              fontFamily: 'SF Mono',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(width: 4),
          // Animated dots
          AnimatedBuilder(
            animation: _dotsController,
            builder: (context, child) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(3, (index) {
                  final delay = index * 0.25;
                  final progress = (_dotsController.value + delay) % 1.0;
                  final opacity = (math.sin(
                    progress * math.pi,
                  )).clamp(0.3, 1.0);

                  return Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: opacity),
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }),
              );
            },
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
    canvas.drawLine(
      Offset(center.dx, 0),
      Offset(center.dx, size.height),
      paint,
    );
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
