import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bluetooth_finder/features/onboarding/data/repositories/onboarding_repository.dart';

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  return OnboardingRepository.instance;
});

final hasSeenOnboardingProvider = StateProvider<bool>((ref) {
  return ref.watch(onboardingRepositoryProvider).hasSeenOnboarding;
});

final onboardingNotifierProvider =
    StateNotifierProvider<OnboardingNotifier, bool>((ref) {
  final repo = ref.watch(onboardingRepositoryProvider);
  return OnboardingNotifier(repo);
});

class OnboardingNotifier extends StateNotifier<bool> {
  final OnboardingRepository _repo;

  OnboardingNotifier(this._repo) : super(_repo.hasSeenOnboarding);

  Future<void> completeOnboarding() async {
    await _repo.completeOnboarding();
    state = true;
  }
}
