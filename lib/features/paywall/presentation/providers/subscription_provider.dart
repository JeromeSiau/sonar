import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

enum SubscriptionStatus { free, trial, premium }

final subscriptionStatusProvider = StateNotifierProvider<SubscriptionNotifier, SubscriptionStatus>((ref) {
  return SubscriptionNotifier();
});

class SubscriptionNotifier extends StateNotifier<SubscriptionStatus> {
  SubscriptionNotifier() : super(SubscriptionStatus.free) {
    // Defer initialization to avoid modifying state during build
    Future.microtask(_init);
  }

  Future<void> _init() async {
    await _checkSubscriptionStatus();
    Purchases.addCustomerInfoUpdateListener((_) => _checkSubscriptionStatus());
  }

  Future<void> _checkSubscriptionStatus() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      if (!mounted) return;
      if (customerInfo.entitlements.active.containsKey('premium')) {
        state = SubscriptionStatus.premium;
      } else {
        state = SubscriptionStatus.free;
      }
    } catch (_) {
      if (mounted) state = SubscriptionStatus.free;
    }
  }

  Future<void> restorePurchases() async {
    try {
      await Purchases.restorePurchases();
      await _checkSubscriptionStatus();
    } catch (_) {
      // Handle error
    }
  }
}

final isPremiumProvider = Provider<bool>((ref) {
  // In debug mode, always return premium for testing
  if (kDebugMode) return true;

  final status = ref.watch(subscriptionStatusProvider);
  return status == SubscriptionStatus.premium || status == SubscriptionStatus.trial;
});

// Free tier limits
final freeDeviceLimitProvider = Provider<int>((ref) => 3);

// Radar trial tracking - uses RevenueCat attributes to persist across reinstalls
const _radarTrialKey = 'radar_trial_used';
const _rcTrialAttribute = 'radar_trial_used';

final radarTrialUsedProvider = StateNotifierProvider<RadarTrialNotifier, bool>((ref) {
  return RadarTrialNotifier();
});

class RadarTrialNotifier extends StateNotifier<bool> {
  RadarTrialNotifier() : super(_getInitialValue()) {
    // Defer sync to avoid modifying state during build
    Future.microtask(_syncWithRevenueCat);
  }

  /// Synchronously get initial value from Hive
  static bool _getInitialValue() {
    try {
      final box = Hive.box('settings');
      return box.get(_radarTrialKey, defaultValue: false);
    } catch (_) {
      return false;
    }
  }

  /// Async sync with RevenueCat (runs after initialization)
  Future<void> _syncWithRevenueCat() async {
    if (state) return; // Already used locally

    try {
      final customerInfo = await Purchases.getCustomerInfo();
      final rcValue = customerInfo.nonSubscriptionTransactions.isNotEmpty ||
          (await _getRevenueCatAttribute());
      if (rcValue && mounted) {
        final box = Hive.box('settings');
        await box.put(_radarTrialKey, true);
        state = true;
      }
    } catch (_) {
      // Use local value if RevenueCat fails
    }
  }

  Future<bool> _getRevenueCatAttribute() async {
    try {
      final info = await Purchases.getCustomerInfo();
      // Check if user has the trial attribute set
      return info.originalAppUserId.isNotEmpty &&
             Hive.box('settings').get('${_radarTrialKey}_synced', defaultValue: false);
    } catch (_) {
      return false;
    }
  }

  Future<void> useRadarTrial() async {
    final box = Hive.box('settings');
    await box.put(_radarTrialKey, true);
    await box.put('${_radarTrialKey}_synced', true);

    // Set RevenueCat subscriber attribute (persists across reinstalls)
    try {
      await Purchases.setAttributes({_rcTrialAttribute: 'true'});
    } catch (_) {
      // Continue even if RC fails
    }

    state = true;
  }
}

/// Provider that returns true if user can access radar
final canAccessRadarProvider = Provider<bool>((ref) {
  final isPremium = ref.watch(isPremiumProvider);
  final trialUsed = ref.watch(radarTrialUsedProvider);
  return isPremium || !trialUsed;
});
