import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bluetooth_finder/core/theme/app_colors.dart';
import 'package:bluetooth_finder/core/utils/rssi_utils.dart';
import 'package:bluetooth_finder/features/scanner/data/models/bluetooth_device_model.dart';
import 'package:bluetooth_finder/features/favorites/presentation/providers/favorites_provider.dart';
import 'package:bluetooth_finder/features/favorites/data/models/favorite_device_model.dart';
import 'package:bluetooth_finder/shared/widgets/signal_indicator.dart';
import 'package:bluetooth_finder/shared/widgets/staggered_list_item.dart';
import 'package:bluetooth_finder/l10n/app_localizations.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fabController;
  late Animation<double> _fabGlowAnimation;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _fabGlowAnimation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _fabController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favorites = ref.watch(favoritesProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(context, l10n),
              // Content
              Expanded(
                child: favorites.isEmpty
                    ? _buildEmptyState(context, l10n)
                    : _buildFavoritesList(context, ref, favorites, l10n),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildAnimatedFAB(context, l10n),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Row(
        children: [
          // Logo / Title
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primaryGlow,
                  ],
                ).createShader(bounds),
                child: Text(
                  l10n.appName,
                  style: TextStyle(
                    fontFamily: 'SF Mono',
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 6,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                l10n.appSubtitle,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.textMuted,
                      letterSpacing: 1,
                    ),
              ),
            ],
          ),
          const Spacer(),
          // Settings button
          GestureDetector(
            onTap: () => context.push('/settings'),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.glassBorder),
              ),
              child: const Icon(
                Icons.tune_rounded,
                color: AppColors.textSecondary,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated radar icon
            _AnimatedRadarIcon(),
            const SizedBox(height: 32),
            Text(
              l10n.noSavedDevices,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.noSavedDevicesDescription,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 80), // Space for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritesList(
    BuildContext context,
    WidgetRef ref,
    List<FavoriteDeviceModel> favorites,
    AppLocalizations l10n,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final favorite = favorites[index];
        return StaggeredListItem(
          index: index,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _FavoriteDeviceCard(
              favorite: favorite,
              onTap: () => context.push('/radar/${favorite.id}'),
              onDismiss: () {
                ref
                    .read(favoritesProvider.notifier)
                    .removeFavorite(favorite.id);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedFAB(BuildContext context, AppLocalizations l10n) {
    return AnimatedBuilder(
      animation: _fabGlowAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary
                    .withValues(alpha: 0.4 * _fabGlowAnimation.value),
                blurRadius: 24,
                spreadRadius: 0,
              ),
            ],
          ),
          child: FloatingActionButton.extended(
            onPressed: () => context.push('/scanner'),
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.background,
            elevation: 0,
            icon: const Icon(Icons.radar_rounded, size: 24),
            label: Text(
              l10n.scanner,
              style: TextStyle(
                fontFamily: 'SF Mono',
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
                fontSize: 14,
              ),
            ),
          ),
        );
      },
    );
  }
}

// Animated radar icon for empty state
class _AnimatedRadarIcon extends StatefulWidget {
  @override
  State<_AnimatedRadarIcon> createState() => _AnimatedRadarIconState();
}

class _AnimatedRadarIconState extends State<_AnimatedRadarIcon>
    with TickerProviderStateMixin {
  late AnimationController _pingController;
  late AnimationController _rotateController;

  @override
  void initState() {
    super.initState();
    _pingController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _rotateController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _pingController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 140,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Expanding rings
          ...List.generate(3, (index) {
            return AnimatedBuilder(
              animation: _pingController,
              builder: (context, child) {
                final delay = index * 0.33;
                final progress = (_pingController.value + delay) % 1.0;
                final size = 40.0 + (progress * 100);
                final opacity = (1.0 - progress) * 0.4;

                return Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: opacity),
                      width: 2,
                    ),
                  ),
                );
              },
            );
          }),
          // Center icon
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.5),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.bluetooth_searching_rounded,
              color: AppColors.primary,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }
}

// Favorite device card with swipe to delete
class _FavoriteDeviceCard extends StatelessWidget {
  final FavoriteDeviceModel favorite;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const _FavoriteDeviceCard({
    required this.favorite,
    required this.onTap,
    required this.onDismiss,
  });

  IconData _getDeviceIcon() {
    return switch (favorite.deviceType) {
      DeviceType.airpods => Icons.headphones_rounded,
      DeviceType.headphones => Icons.headset_rounded,
      DeviceType.watch => Icons.watch_rounded,
      DeviceType.speaker => Icons.speaker_rounded,
      DeviceType.other => Icons.bluetooth_rounded,
    };
  }

  String _formatLastSeen(BuildContext context, DateTime lastSeen) {
    final l10n = AppLocalizations.of(context)!;
    final diff = DateTime.now().difference(lastSeen);
    if (diff.inMinutes < 1) return l10n.justNow;
    if (diff.inHours < 1) return l10n.minutesAgo(diff.inMinutes);
    if (diff.inDays < 1) return l10n.hoursAgo(diff.inHours);
    return l10n.daysAgo(diff.inDays);
  }

  @override
  Widget build(BuildContext context) {
    final signalColor = RssiUtils.getSignalColor(favorite.lastRssi);

    return Dismissible(
      key: Key(favorite.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: AppColors.signalWeak.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          Icons.delete_outline_rounded,
          color: AppColors.signalWeak,
          size: 28,
        ),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.glassBorder),
              ),
              child: Row(
                children: [
                  // Icon
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.surfaceGlow,
                          AppColors.surfaceLight,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      _getDeviceIcon(),
                      color: AppColors.primary,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          favorite.customName,
                          style: Theme.of(context).textTheme.titleLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: signalColor.withValues(alpha: 0.7),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _formatLastSeen(context, favorite.lastSeenAt),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Signal
                  SignalIndicator(
                    rssi: favorite.lastRssi,
                    showDistance: false,
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textMuted,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
