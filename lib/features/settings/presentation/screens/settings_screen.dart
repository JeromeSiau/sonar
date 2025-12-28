import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bluetooth_finder/core/theme/app_colors.dart';
import 'package:bluetooth_finder/core/providers/locale_provider.dart';
import 'package:bluetooth_finder/features/paywall/presentation/providers/subscription_provider.dart';
import 'package:bluetooth_finder/l10n/app_localizations.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionStatus = ref.watch(subscriptionStatusProvider);
    final isPremium = subscriptionStatus == SubscriptionStatus.premium;
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(localeProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(l10n.settings),
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
              _buildSectionHeader(context, l10n.subscription),
              const SizedBox(height: 12),
              _SettingsCard(
                child: Column(
                  children: [
                    _buildSubscriptionStatus(context, isPremium, l10n),
                    if (!isPremium) ...[
                      const Divider(color: AppColors.surfaceLight, height: 24),
                      _SettingsTile(
                        icon: Icons.workspace_premium_rounded,
                        iconColor: AppColors.signalMedium,
                        title: l10n.goPremium,
                        subtitle: l10n.unlockAllFeatures,
                        onTap: () => context.push('/paywall'),
                      ),
                    ],
                    const Divider(color: AppColors.surfaceLight, height: 24),
                    _SettingsTile(
                      icon: Icons.refresh_rounded,
                      title: l10n.restorePurchases,
                      subtitle: l10n.restorePurchasesDescription,
                      onTap: () {
                        ref
                            .read(subscriptionStatusProvider.notifier)
                            .restorePurchases();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.restoringPurchases),
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

              // === LANGUAGE SECTION ===
              _buildSectionHeader(context, l10n.language.toUpperCase()),
              const SizedBox(height: 12),
              _SettingsCard(
                child: _SettingsTile(
                  icon: Icons.language_rounded,
                  title: l10n.language,
                  subtitle: _getLanguageName(currentLocale, l10n),
                  onTap: () => _showLanguageSelector(context, ref, l10n),
                ),
              ),

              const SizedBox(height: 32),

              // === ABOUT SECTION ===
              _buildSectionHeader(context, l10n.about),
              const SizedBox(height: 12),
              _SettingsCard(
                child: Column(
                  children: [
                    _SettingsTile(
                      icon: Icons.description_outlined,
                      title: l10n.termsOfService,
                      onTap: () => _launchUrl('https://levelup-dev.com/sonar/terms.html'),
                    ),
                    const Divider(color: AppColors.surfaceLight, height: 24),
                    _SettingsTile(
                      icon: Icons.privacy_tip_outlined,
                      title: l10n.privacyPolicy,
                      onTap: () => _launchUrl('https://levelup-dev.com/sonar/privacy.html'),
                    ),
                    const Divider(color: AppColors.surfaceLight, height: 24),
                    _SettingsTile(
                      icon: Icons.mail_outline_rounded,
                      title: l10n.contactUs,
                      subtitle: 'jerome@levelup-dev.com',
                      onTap: () => _launchUrl('mailto:jerome@levelup-dev.com'),
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
                      l10n.appName,
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
                      l10n.version('1.0.0'),
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

  String _getLanguageName(Locale? locale, AppLocalizations l10n) {
    if (locale == null) return l10n.systemLanguage;
    return switch (locale.languageCode) {
      'fr' => l10n.french,
      'en' => l10n.english,
      'es' => l10n.spanish,
      'de' => l10n.german,
      'it' => l10n.italian,
      _ => l10n.systemLanguage,
    };
  }

  void _showLanguageSelector(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textMuted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.language,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _LanguageOption(
              title: l10n.systemLanguage,
              isSelected: ref.read(localeProvider) == null,
              onTap: () {
                ref.read(localeProvider.notifier).setLocale(null);
                Navigator.pop(context);
              },
            ),
            _LanguageOption(
              title: l10n.french,
              isSelected: ref.read(localeProvider)?.languageCode == 'fr',
              onTap: () {
                ref.read(localeProvider.notifier).setLocale(const Locale('fr'));
                Navigator.pop(context);
              },
            ),
            _LanguageOption(
              title: l10n.english,
              isSelected: ref.read(localeProvider)?.languageCode == 'en',
              onTap: () {
                ref.read(localeProvider.notifier).setLocale(const Locale('en'));
                Navigator.pop(context);
              },
            ),
            _LanguageOption(
              title: l10n.spanish,
              isSelected: ref.read(localeProvider)?.languageCode == 'es',
              onTap: () {
                ref.read(localeProvider.notifier).setLocale(const Locale('es'));
                Navigator.pop(context);
              },
            ),
            _LanguageOption(
              title: l10n.german,
              isSelected: ref.read(localeProvider)?.languageCode == 'de',
              onTap: () {
                ref.read(localeProvider.notifier).setLocale(const Locale('de'));
                Navigator.pop(context);
              },
            ),
            _LanguageOption(
              title: l10n.italian,
              isSelected: ref.read(localeProvider)?.languageCode == 'it',
              onTap: () {
                ref.read(localeProvider.notifier).setLocale(const Locale('it'));
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 16),
          ],
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

  Widget _buildSubscriptionStatus(BuildContext context, bool isPremium, AppLocalizations l10n) {
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
                isPremium ? l10n.premiumStatus : l10n.freeStatus,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: isPremium ? AppColors.signalMedium : null,
                    ),
              ),
              Text(
                isPremium
                    ? l10n.premiumDescription
                    : l10n.freeDescription,
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

class _LanguageOption extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.textPrimary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_rounded, color: AppColors.primary)
          : null,
      onTap: onTap,
    );
  }
}
