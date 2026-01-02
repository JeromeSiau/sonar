import 'package:hive_flutter/hive_flutter.dart';

/// Repository to track onboarding state.
class OnboardingRepository {
  static const String _boxName = 'onboarding';
  static const String _hasSeenOnboardingKey = 'hasSeenOnboarding';

  static OnboardingRepository? _instance;
  late Box<dynamic> _box;

  OnboardingRepository._();

  static OnboardingRepository get instance {
    _instance ??= OnboardingRepository._();
    return _instance!;
  }

  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
  }

  /// Whether the user has completed onboarding.
  bool get hasSeenOnboarding =>
      _box.get(_hasSeenOnboardingKey, defaultValue: false) as bool;

  /// Mark onboarding as completed.
  Future<void> completeOnboarding() async {
    await _box.put(_hasSeenOnboardingKey, true);
  }

  /// Reset onboarding (for testing).
  Future<void> resetOnboarding() async {
    await _box.put(_hasSeenOnboardingKey, false);
  }
}
