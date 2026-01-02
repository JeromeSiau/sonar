import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

/// Service to get current location and reverse geocode to place names.
/// Includes caching, throttling, and in-flight deduplication to avoid
/// hitting Apple's geocoding rate limit (50 requests/minute).
class LocationService {
  /// Cached place name from last successful geocoding.
  String? _cachedPlaceName;
  double? _cachedLat;
  double? _cachedLng;
  DateTime? _lastGeocodingTime;

  /// In-flight geocoding request for deduplication.
  /// Multiple callers will await the same Future.
  Completer<String?>? _inFlightGeocoding;

  /// Minimum interval between geocoding requests (global throttle).
  /// Apple's iOS geocoder allows ~50 requests/minute; 60s is safe.
  static const _minGeocodingInterval = Duration(seconds: 60);

  /// Distance threshold for cache hit (~150m in degrees).
  /// If new coordinates are within this distance, return cached result.
  static const _cacheDistanceThreshold = 0.00135;

  /// Distance threshold to bypass throttle (~500m in degrees).
  /// If user moved significantly, allow geocoding even if throttled.
  static const _bypassThrottleDistance = 0.0045;

  /// Gets the current position if permissions are granted.
  /// Returns null if location services are disabled or permission denied.
  Future<Position?> getCurrentPosition() async {
    try {
      // Check if location services are enabled
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      // Check permission
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return null;
      }

      // Get current position with medium accuracy (good balance of precision vs battery)
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 10),
        ),
      );
    } catch (e) {
      return null;
    }
  }

  /// Reverse geocodes coordinates to a human-readable place name.
  /// Returns a short description like "Office", "Home area", or street name.
  ///
  /// Optimizations to avoid Apple's 50 requests/minute limit:
  /// - Spatial cache: returns cached result if within ~150m
  /// - Time throttle: minimum 60s between geocoding requests
  /// - In-flight dedupe: concurrent callers share the same request
  /// - Graceful degradation: returns stale cache on throttle/error
  Future<String?> getPlaceName(double latitude, double longitude) async {
    // 1. Check spatial cache - return cached if within ~150m
    if (_cachedPlaceName != null && _cachedLat != null && _cachedLng != null) {
      final latDiff = (latitude - _cachedLat!).abs();
      final lngDiff = (longitude - _cachedLng!).abs();
      if (latDiff < _cacheDistanceThreshold &&
          lngDiff < _cacheDistanceThreshold) {
        return _cachedPlaceName;
      }
    }

    // 2. Check if we should bypass throttle due to significant movement
    final movedSignificantly =
        _cachedLat != null &&
        _cachedLng != null &&
        ((latitude - _cachedLat!).abs() >= _bypassThrottleDistance ||
            (longitude - _cachedLng!).abs() >= _bypassThrottleDistance);

    // 3. Check global throttle - don't geocode more than once per minute
    if (!movedSignificantly &&
        _lastGeocodingTime != null &&
        DateTime.now().difference(_lastGeocodingTime!) <
            _minGeocodingInterval) {
      return _cachedPlaceName; // Return stale cache
    }

    // 4. In-flight deduplication - multiple callers await same Future
    if (_inFlightGeocoding != null) {
      return _inFlightGeocoding!.future;
    }

    _inFlightGeocoding = Completer<String?>();

    try {
      _lastGeocodingTime = DateTime.now();
      final placemarks = await placemarkFromCoordinates(latitude, longitude);

      String? placeName;
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        // Build a concise location name
        // Priority: subLocality > thoroughfare > locality
        if (place.subLocality?.isNotEmpty == true) {
          placeName = place.subLocality;
        } else if (place.thoroughfare?.isNotEmpty == true) {
          placeName = place.thoroughfare;
        } else if (place.locality?.isNotEmpty == true) {
          placeName = place.locality;
        }
      }

      // Update cache
      _cachedLat = latitude;
      _cachedLng = longitude;
      _cachedPlaceName = placeName;

      _inFlightGeocoding!.complete(placeName);
      return placeName;
    } catch (e) {
      // Geocoding failed (possibly throttled), return stale cache
      _inFlightGeocoding!.complete(_cachedPlaceName);
      return _cachedPlaceName;
    } finally {
      _inFlightGeocoding = null;
    }
  }

  /// Gets current position and place name in one call.
  /// Returns (latitude, longitude, placeName) or null if unavailable.
  Future<LocationData?> getCurrentLocationWithName() async {
    final position = await getCurrentPosition();
    if (position == null) return null;

    final placeName = await getPlaceName(position.latitude, position.longitude);

    return LocationData(
      latitude: position.latitude,
      longitude: position.longitude,
      placeName: placeName,
    );
  }
}

/// Data class holding location information.
class LocationData {
  final double latitude;
  final double longitude;
  final String? placeName;

  const LocationData({
    required this.latitude,
    required this.longitude,
    this.placeName,
  });
}

/// Provider for the location service.
final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});
