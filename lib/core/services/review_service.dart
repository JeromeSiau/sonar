import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:in_app_review/in_app_review.dart';

final reviewServiceProvider = Provider<ReviewService>((ref) {
  return ReviewService.instance;
});

/// Service to track device finds and request app reviews at the right moment.
///
/// Strategy:
/// - Request review after the 3rd successful device find
/// - Only request once per user (even if they reinstall, the stores remember)
/// - Use in_app_review which shows native review dialog on iOS/Android
class ReviewService {
  static const String _boxName = 'review';
  static const String _devicesFoundCountKey = 'devicesFoundCount';
  static const String _hasRequestedReviewKey = 'hasRequestedReview';
  static const int _reviewThreshold = 3; // Request after 3 finds

  static ReviewService? _instance;
  late Box<dynamic> _box;
  final InAppReview _inAppReview = InAppReview.instance;

  ReviewService._();

  static ReviewService get instance {
    _instance ??= ReviewService._();
    return _instance!;
  }

  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
  }

  /// Number of devices the user has successfully found.
  int get devicesFoundCount => _box.get(_devicesFoundCountKey, defaultValue: 0) as int;

  /// Whether we've already requested a review.
  bool get hasRequestedReview => _box.get(_hasRequestedReviewKey, defaultValue: false) as bool;

  /// Whether it's the right moment to request a review.
  bool get shouldRequestReview =>
      !hasRequestedReview && devicesFoundCount >= _reviewThreshold;

  /// Record that the user found a device and potentially request a review.
  ///
  /// Returns true if a review was requested.
  Future<bool> recordDeviceFound() async {
    // Increment counter
    final newCount = devicesFoundCount + 1;
    await _box.put(_devicesFoundCountKey, newCount);

    // Check if we should request review
    if (shouldRequestReview) {
      return await requestReview();
    }
    return false;
  }

  /// Request the app review dialog.
  ///
  /// Returns true if the request was made (doesn't mean user left a review).
  Future<bool> requestReview() async {
    if (hasRequestedReview) return false;

    // Check if the device supports in-app review
    if (await _inAppReview.isAvailable()) {
      try {
        await _inAppReview.requestReview();
        // Mark as requested regardless of outcome (we can't know if user reviewed)
        await _box.put(_hasRequestedReviewKey, true);
        return true;
      } catch (_) {
        // Silently fail - review is not critical
        return false;
      }
    }
    return false;
  }
}
