import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:bluetooth_finder/features/favorites/data/repositories/favorites_repository.dart';
import 'package:bluetooth_finder/core/services/widget_service.dart';

/// Service that tracks significant location changes and updates favorite device locations.
/// On iOS, this uses the significant-change location service which works in background.
/// On Android, this supplements the workmanager periodic task.
class LocationTrackingService {
  static final LocationTrackingService instance = LocationTrackingService._();
  LocationTrackingService._();

  StreamSubscription<Position>? _positionSubscription;
  bool _isTracking = false;

  /// Minimum distance in meters before triggering an update.
  /// iOS significant location changes typically triggers at ~500m.
  static const int distanceFilter = 500;

  /// Duration for quick BLE scan when location changes.
  static const Duration scanDuration = Duration(seconds: 5);

  /// Minimum time between location updates to avoid API throttling.
  static const Duration minUpdateInterval = Duration(minutes: 2);

  /// Last processed location update time.
  DateTime? _lastUpdateTime;

  /// Cached place name to avoid excessive geocoding.
  String? _cachedPlaceName;
  double? _cachedLat;
  double? _cachedLng;

  /// Start tracking significant location changes.
  Future<void> startTracking() async {
    if (_isTracking) return;

    // Check permissions
    final permission = await Geolocator.checkPermission();
    if (permission != LocationPermission.always &&
        permission != LocationPermission.whileInUse) {
      return;
    }

    // Check if location services are enabled
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    _isTracking = true;

    // Configure location settings for significant changes
    late LocationSettings locationSettings;

    if (Platform.isIOS) {
      // iOS: Use significant location changes for background tracking
      // This is battery efficient and works when app is suspended
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.reduced, // Uses less battery
        distanceFilter: distanceFilter,
        activityType: ActivityType.other,
        pauseLocationUpdatesAutomatically: false,
        showBackgroundLocationIndicator: false,
        allowBackgroundLocationUpdates: true,
      );
    } else {
      // Android: Standard location updates with distance filter
      locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.medium,
        distanceFilter: distanceFilter,
        forceLocationManager: false,
        intervalDuration: const Duration(minutes: 5),
      );
    }

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen(_onLocationChanged);
  }

  /// Stop tracking location changes.
  Future<void> stopTracking() async {
    _isTracking = false;
    await _positionSubscription?.cancel();
    _positionSubscription = null;
  }

  /// Called when device location changes significantly.
  Future<void> _onLocationChanged(Position position) async {
    // Rate limit: skip if we processed an update recently
    final now = DateTime.now();
    if (_lastUpdateTime != null &&
        now.difference(_lastUpdateTime!) < minUpdateInterval) {
      return;
    }
    _lastUpdateTime = now;

    // Get place name for the new location (with caching)
    String? placeName = _getCachedPlaceName(
      position.latitude,
      position.longitude,
    );

    if (placeName == null) {
      try {
        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          placeName = place.subLocality ?? place.thoroughfare ?? place.locality;
          _cachePlaceName(position.latitude, position.longitude, placeName);
        }
      } catch (_) {
        // Geocoding failed (possibly throttled), use cached value if available
        placeName = _cachedPlaceName;
      }
    }

    // Do a quick BLE scan to find nearby favorites
    await _scanAndUpdateFavorites(position, placeName);
  }

  /// Returns cached place name if location is within 100m of cached location.
  String? _getCachedPlaceName(double lat, double lng) {
    if (_cachedPlaceName == null || _cachedLat == null || _cachedLng == null) {
      return null;
    }

    // Check if within ~100m (rough approximation)
    final latDiff = (lat - _cachedLat!).abs();
    final lngDiff = (lng - _cachedLng!).abs();
    if (latDiff < 0.001 && lngDiff < 0.001) {
      return _cachedPlaceName;
    }
    return null;
  }

  /// Cache the place name for a location.
  void _cachePlaceName(double lat, double lng, String? name) {
    _cachedLat = lat;
    _cachedLng = lng;
    _cachedPlaceName = name;
  }

  /// Performs a quick BLE scan and updates found favorites with current location.
  Future<void> _scanAndUpdateFavorites(
    Position position,
    String? placeName,
  ) async {
    final favorites = FavoritesRepository.instance.getAll();
    if (favorites.isEmpty) return;

    final favoriteIds = favorites.map((f) => f.id.toUpperCase()).toSet();
    final foundDeviceIds = <String>{};

    try {
      // Listen for scan results
      final subscription = FlutterBluePlus.scanResults.listen((results) {
        for (final result in results) {
          final deviceId = result.device.remoteId.str.toUpperCase();
          if (favoriteIds.contains(deviceId)) {
            foundDeviceIds.add(deviceId);
          }
        }
      });

      // Start quick scan
      await FlutterBluePlus.startScan(timeout: scanDuration);
      await Future.delayed(scanDuration);
      await subscription.cancel();
      await FlutterBluePlus.stopScan();
    } catch (_) {
      // BLE scan may fail in background - that's okay
    }

    // Update found favorites with new location
    if (foundDeviceIds.isNotEmpty) {
      for (final favorite in favorites) {
        if (foundDeviceIds.contains(favorite.id.toUpperCase())) {
          favorite.lastSeenAt = DateTime.now();
          favorite.lastLatitude = position.latitude;
          favorite.lastLongitude = position.longitude;
          favorite.lastLocationName = placeName;
          await favorite.save();
        }
      }

      // Update home screen widget
      try {
        await WidgetService.instance.updateWidget();
      } catch (_) {}
    }
  }
}
