import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:bluetooth_finder/core/theme/app_colors.dart';
import 'package:bluetooth_finder/features/paywall/presentation/providers/subscription_provider.dart';
import 'package:bluetooth_finder/l10n/app_localizations.dart';

enum PricingTier { weekly, monthly, lifetime }

class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  Map<PricingTier, Package?> _packages = {};
  PricingTier _selectedTier = PricingTier.lifetime;
  bool _isLoading = true;
  bool _isPurchasing = false;
  String? _loadingError;

  @override
  void initState() {
    super.initState();
    _loadOfferings();
  }

  Future<void> _loadOfferings() async {
    setState(() {
      _isLoading = true;
      _loadingError = null;
    });

    try {
      final offerings = await Purchases.getOfferings();
      final packages = offerings.current?.availablePackages ?? [];

      // Map packages to tiers
      final Map<PricingTier, Package?> tierPackages = {};

      for (final package in packages) {
        switch (package.packageType) {
          case PackageType.weekly:
            tierPackages[PricingTier.weekly] = package;
            break;
          case PackageType.monthly:
            tierPackages[PricingTier.monthly] = package;
            break;
          case PackageType.lifetime:
            tierPackages[PricingTier.lifetime] = package;
            break;
          default:
            // Check identifier for custom packages
            if (package.identifier.contains('weekly')) {
              tierPackages[PricingTier.weekly] = package;
            } else if (package.identifier.contains('monthly')) {
              tierPackages[PricingTier.monthly] = package;
            } else if (package.identifier.contains('lifetime')) {
              tierPackages[PricingTier.lifetime] = package;
            }
        }
      }

      // Fallback: if only one package, use it as lifetime
      if (tierPackages.isEmpty && packages.isNotEmpty) {
        tierPackages[PricingTier.lifetime] = packages.first;
      }

      setState(() {
        _packages = tierPackages;
        _isLoading = false;
        // Default to lifetime if available
        if (tierPackages.containsKey(PricingTier.lifetime)) {
          _selectedTier = PricingTier.lifetime;
        } else if (tierPackages.isNotEmpty) {
          _selectedTier = tierPackages.keys.first;
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _loadingError = e.toString();
      });
    }
  }

  Future<void> _purchase() async {
    final selectedPackage = _packages[_selectedTier];
    if (selectedPackage == null || _isPurchasing) return;

    final l10n = AppLocalizations.of(context)!;
    setState(() => _isPurchasing = true);

    try {
      await Purchases.purchasePackage(selectedPackage);
      if (mounted) {
        context.pop();
      }
    } on PurchasesErrorCode catch (e) {
      if (mounted) {
        _showErrorSnackBar(_getErrorMessage(l10n, e));
      }
    } catch (e) {
      if (mounted && e.toString().contains('PurchaseCancelledError') == false) {
        _showErrorSnackBar(l10n.purchaseErrorDescription);
      }
    } finally {
      if (mounted) {
        setState(() => _isPurchasing = false);
      }
    }
  }

  String _getErrorMessage(AppLocalizations l10n, PurchasesErrorCode errorCode) {
    switch (errorCode) {
      case PurchasesErrorCode.purchaseCancelledError:
        return l10n.purchaseCancelled;
      case PurchasesErrorCode.networkError:
        return l10n.networkErrorDescription;
      default:
        return l10n.purchaseErrorDescription;
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade800,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Premium icon with glow effect
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.radar_rounded,
                  size: 56,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.unlockRadar,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.locateAllDevices,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Feature list
              _buildFeatureList(l10n),
              const SizedBox(height: 24),
              // Pricing tiers
              _isLoading
                  ? const SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : _loadingError != null
                  ? _buildErrorState(l10n)
                  : _buildPricingTiers(l10n),
              const SizedBox(height: 24),
              _buildPurchaseButton(l10n),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  ref
                      .read(subscriptionStatusProvider.notifier)
                      .restorePurchases();
                },
                child: Text(
                  l10n.restorePurchases,
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.shade900.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red.shade700.withValues(alpha: 0.5)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade300, size: 32),
          const SizedBox(height: 12),
          Text(
            l10n.loadingError,
            style: TextStyle(
              color: Colors.red.shade300,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.loadingErrorDescription,
            style: TextStyle(color: Colors.red.shade200, fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: _loadOfferings,
            icon: const Icon(Icons.refresh),
            label: Text(l10n.retry),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingTiers(AppLocalizations l10n) {
    return Column(
      children: [
        // Lifetime (Best Value) - Featured
        if (_packages.containsKey(PricingTier.lifetime))
          _PricingTierCard(
            tier: PricingTier.lifetime,
            title: l10n.lifetimePlan,
            price:
                _packages[PricingTier.lifetime]?.storeProduct.priceString ??
                l10n.lifetimePrice,
            period: l10n.oneTimePurchaseBadge,
            isSelected: _selectedTier == PricingTier.lifetime,
            isBestValue: true,
            onTap: () => setState(() => _selectedTier = PricingTier.lifetime),
          ),
        const SizedBox(height: 12),
        // Row for weekly and monthly
        Row(
          children: [
            if (_packages.containsKey(PricingTier.weekly))
              Expanded(
                child: _PricingTierCard(
                  tier: PricingTier.weekly,
                  title: l10n.weekly,
                  price:
                      _packages[PricingTier.weekly]?.storeProduct.priceString ??
                      l10n.weeklyPrice,
                  period: l10n.perWeek,
                  isSelected: _selectedTier == PricingTier.weekly,
                  onTap: () =>
                      setState(() => _selectedTier = PricingTier.weekly),
                ),
              ),
            if (_packages.containsKey(PricingTier.weekly) &&
                _packages.containsKey(PricingTier.monthly))
              const SizedBox(width: 12),
            if (_packages.containsKey(PricingTier.monthly))
              Expanded(
                child: _PricingTierCard(
                  tier: PricingTier.monthly,
                  title: l10n.monthly,
                  price:
                      _packages[PricingTier.monthly]
                          ?.storeProduct
                          .priceString ??
                      l10n.monthlyPrice,
                  period: l10n.perMonth,
                  isSelected: _selectedTier == PricingTier.monthly,
                  onTap: () =>
                      setState(() => _selectedTier = PricingTier.monthly),
                ),
              ),
          ],
        ),
        // Fallback if no tiers loaded (show single lifetime option)
        if (_packages.isEmpty ||
            (!_packages.containsKey(PricingTier.weekly) &&
                !_packages.containsKey(PricingTier.monthly) &&
                !_packages.containsKey(PricingTier.lifetime)))
          _buildFallbackPriceCard(l10n),
      ],
    );
  }

  Widget _buildFallbackPriceCard(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.15),
            AppColors.primary.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            l10n.lifetimePrice,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.signalStrong,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              l10n.oneTimePurchaseBadge,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 11,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureList(AppLocalizations l10n) {
    final features = [
      (l10n.featureUnlimitedRadar, Icons.radar_rounded),
      (l10n.featureFindAllDevices, Icons.devices_rounded),
      (l10n.featureAudioAlerts, Icons.volume_up_rounded),
      (l10n.featureNoAds, Icons.block_rounded),
      (l10n.featureLifetimeUpdates, Icons.update_rounded),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        children: features.map((feature) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.signalStrong.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    size: 16,
                    color: AppColors.signalStrong,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    feature.$1,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(feature.$2, size: 18, color: AppColors.textMuted),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPurchaseButton(AppLocalizations l10n) {
    final hasPackage = _packages[_selectedTier] != null;

    return _ShimmerButton(
      onPressed: (hasPackage || _packages.isEmpty) && !_isPurchasing
          ? _purchase
          : null,
      isLoading: _isPurchasing,
      text: l10n.unlockNow,
    );
  }
}

class _PricingTierCard extends StatelessWidget {
  final PricingTier tier;
  final String title;
  final String price;
  final String period;
  final bool isSelected;
  final bool isBestValue;
  final VoidCallback onTap;

  const _PricingTierCard({
    required this.tier,
    required this.title,
    required this.price,
    required this.period,
    required this.isSelected,
    this.isBestValue = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: isBestValue
                      ? [
                          const Color(0xFFFFD700).withValues(alpha: 0.15),
                          const Color(0xFFFF8C00).withValues(alpha: 0.08),
                        ]
                      : [
                          AppColors.primary.withValues(alpha: 0.2),
                          AppColors.primary.withValues(alpha: 0.1),
                        ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : AppColors.surface.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isBestValue
                ? const Color(0xFFFFD700)
                : isSelected
                ? AppColors.primary
                : AppColors.glassBorder,
            width: isSelected || isBestValue ? 2 : 1,
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Diagonal ribbon for Best Value
            if (isBestValue)
              Positioned(
                top: -4,
                right: -28,
                child: Transform.rotate(
                  angle: math.pi / 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 4,
                    ),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFFFD700), Color(0xFFFF8C00)],
                      ),
                    ),
                    child: const Text(
                      'BEST VALUE',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 8,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            // Main content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (isBestValue) const SizedBox(height: 4),
                  // Title
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isSelected
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Price
                  Text(
                    price,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Period
                  Text(
                    period,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textMuted,
                      fontSize: 11,
                    ),
                  ),
                  // Selection indicator
                  const SizedBox(height: 12),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textMuted,
                        width: 2,
                      ),
                      color: isSelected
                          ? AppColors.primary
                          : Colors.transparent,
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, size: 16, color: Colors.black)
                        : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer button with animated shine effect
class _ShimmerButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final String text;

  const _ShimmerButton({
    required this.onPressed,
    required this.isLoading,
    required this.text,
  });

  @override
  State<_ShimmerButton> createState() => _ShimmerButtonState();
}

class _ShimmerButtonState extends State<_ShimmerButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(
      begin: -1.5,
      end: 1.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onPressed,
          borderRadius: BorderRadius.circular(16),
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withValues(alpha: 0.9),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      spreadRadius: 0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Shimmer effect
                    if (!widget.isLoading)
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Transform.translate(
                            offset: Offset(_animation.value * 200, 0),
                            child: Container(
                              width: 80,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    Colors.white.withValues(alpha: 0.15),
                                    Colors.white.withValues(alpha: 0.25),
                                    Colors.white.withValues(alpha: 0.15),
                                    Colors.transparent,
                                  ],
                                  stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    // Content
                    Center(
                      child: widget.isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black,
                              ),
                            )
                          : Text(
                              widget.text,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
