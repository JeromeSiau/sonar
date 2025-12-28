import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

enum SubscriptionStatus { free, trial, premium }

final subscriptionStatusProvider = StateNotifierProvider<SubscriptionNotifier, SubscriptionStatus>((ref) {
  return SubscriptionNotifier();
});

class SubscriptionNotifier extends StateNotifier<SubscriptionStatus> {
  SubscriptionNotifier() : super(SubscriptionStatus.free) {
    _init();
  }

  Future<void> _init() async {
    await _checkSubscriptionStatus();
    Purchases.addCustomerInfoUpdateListener((_) => _checkSubscriptionStatus());
  }

  Future<void> _checkSubscriptionStatus() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      if (customerInfo.entitlements.active.containsKey('premium')) {
        state = SubscriptionStatus.premium;
      } else {
        state = SubscriptionStatus.free;
      }
    } catch (_) {
      state = SubscriptionStatus.free;
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
  final status = ref.watch(subscriptionStatusProvider);
  return status == SubscriptionStatus.premium || status == SubscriptionStatus.trial;
});

// Free tier limits
final freeDeviceLimitProvider = Provider<int>((ref) => 3);
final freeRadarSecondsProvider = Provider<int>((ref) => 30);
