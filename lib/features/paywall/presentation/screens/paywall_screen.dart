import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:bluetooth_finder/core/theme/app_colors.dart';
import 'package:bluetooth_finder/features/paywall/presentation/providers/subscription_provider.dart';

class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  Offerings? _offerings;
  bool _isLoading = true;
  int _selectedIndex = 1; // Annual by default

  @override
  void initState() {
    super.initState();
    _loadOfferings();
  }

  Future<void> _loadOfferings() async {
    try {
      final offerings = await Purchases.getOfferings();
      setState(() {
        _offerings = offerings;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _purchase(Package package) async {
    try {
      await Purchases.purchasePackage(package);
      if (mounted) {
        context.pop();
      }
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Icon(
                Icons.workspace_premium,
                size: 80,
                color: AppColors.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'Passez Premium',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 16),
              _buildFeatureList(),
              const SizedBox(height: 32),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                _buildPricingOptions(),
              const Spacer(),
              _buildPurchaseButton(),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  ref.read(subscriptionStatusProvider.notifier).restorePurchases();
                },
                child: const Text('Restaurer les achats'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureList() {
    final features = [
      'Scan illimité d\'appareils',
      'Radar sans limite de temps',
      'Sauvegarde des favoris',
      'Historique complet',
    ];

    return Column(
      children: features.map((feature) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: AppColors.signalStrong),
              const SizedBox(width: 12),
              Text(feature, style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPricingOptions() {
    final packages = _offerings?.current?.availablePackages ?? [];

    if (packages.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      children: packages.asMap().entries.map((entry) {
        final index = entry.key;
        final package = entry.value;
        final isSelected = index == _selectedIndex;
        final isAnnual = package.packageType == PackageType.annual;

        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedIndex = index),
            child: Container(
              margin: EdgeInsets.only(left: index > 0 ? 12 : 0),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary.withOpacity(0.1) : AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  if (isAnnual)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.signalStrong,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '-45%',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  Text(
                    isAnnual ? 'Annuel' : 'Mensuel',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    package.storeProduct.priceString,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppColors.primary,
                        ),
                  ),
                  Text(
                    isAnnual ? '/an' : '/mois',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPurchaseButton() {
    final packages = _offerings?.current?.availablePackages ?? [];
    if (packages.isEmpty) return const SizedBox.shrink();

    final selectedPackage = packages.length > _selectedIndex
        ? packages[_selectedIndex]
        : packages.first;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _purchase(selectedPackage),
        child: const Text('Commencer l\'essai gratuit'),
      ),
    );
  }
}
