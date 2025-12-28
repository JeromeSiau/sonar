import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bluetooth_finder/core/theme/app_colors.dart';
import 'package:bluetooth_finder/features/paywall/presentation/providers/subscription_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionStatus = ref.watch(subscriptionStatusProvider);
    final isPremium = subscriptionStatus == SubscriptionStatus.premium;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('RÉGLAGES'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // === SUBSCRIPTION SECTION ===
              _buildSectionHeader(context, 'ABONNEMENT'),
              const SizedBox(height: 12),
              _SettingsCard(
                child: Column(
                  children: [
                    _buildSubscriptionStatus(context, isPremium),
                    if (!isPremium) ...[
                      const Divider(color: AppColors.surfaceLight, height: 24),
                      _SettingsTile(
                        icon: Icons.workspace_premium_rounded,
                        iconColor: AppColors.signalMedium,
                        title: 'Passer Premium',
                        subtitle: 'Débloquez toutes les fonctionnalités',
                        onTap: () => context.push('/paywall'),
                      ),
                    ],
                    const Divider(color: AppColors.surfaceLight, height: 24),
                    _SettingsTile(
                      icon: Icons.refresh_rounded,
                      title: 'Restaurer les achats',
                      subtitle: 'Récupérer un abonnement existant',
                      onTap: () {
                        ref
                            .read(subscriptionStatusProvider.notifier)
                            .restorePurchases();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Restauration en cours...'),
                            backgroundColor: AppColors.surface,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // === ABOUT SECTION ===
              _buildSectionHeader(context, 'À PROPOS'),
              const SizedBox(height: 12),
              _SettingsCard(
                child: Column(
                  children: [
                    _SettingsTile(
                      icon: Icons.description_outlined,
                      title: 'Conditions d\'utilisation',
                      onTap: () => _launchUrl('https://example.com/terms'),
                    ),
                    const Divider(color: AppColors.surfaceLight, height: 24),
                    _SettingsTile(
                      icon: Icons.privacy_tip_outlined,
                      title: 'Politique de confidentialité',
                      onTap: () => _launchUrl('https://example.com/privacy'),
                    ),
                    const Divider(color: AppColors.surfaceLight, height: 24),
                    _SettingsTile(
                      icon: Icons.mail_outline_rounded,
                      title: 'Nous contacter',
                      subtitle: 'support@example.com',
                      onTap: () => _launchUrl('mailto:support@example.com'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // === APP INFO ===
              Center(
                child: Column(
                  children: [
                    Text(
                      'SONAR',
                      style: TextStyle(
                        fontFamily: 'SF Mono',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 4,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Version 1.0.0',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.textMuted,
              letterSpacing: 2,
            ),
      ),
    );
  }

  Widget _buildSubscriptionStatus(BuildContext context, bool isPremium) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isPremium
                  ? [AppColors.signalMedium, const Color(0xFFFF8C00)]
                  : [AppColors.surfaceGlow, AppColors.surfaceLight],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            isPremium ? Icons.star_rounded : Icons.person_outline_rounded,
            color: isPremium ? Colors.white : AppColors.textSecondary,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isPremium ? 'Premium' : 'Gratuit',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: isPremium ? AppColors.signalMedium : null,
                    ),
              ),
              Text(
                isPremium
                    ? 'Accès illimité à toutes les fonctionnalités'
                    : 'Fonctionnalités limitées',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _SettingsCard extends StatelessWidget {
  final Widget child;

  const _SettingsCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
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
          child: child,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    this.iconColor,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor ?? AppColors.primary,
              size: 22,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.textPrimary,
                        ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textMuted,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
