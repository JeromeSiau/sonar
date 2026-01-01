import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

/// Service to get current location and reverse geocode to place names.
class LocationService {
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

      // Get current position with low accuracy for battery efficiency
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 10),
        ),
      );
    } catch (e) {
      return null;
    }
  }

  /// Reverse geocodes coordinates to a human-readable place name.
  /// Returns a short description like "Office", "Home area", or street name.
  Future<String?> getPlaceName(double latitude, double longitude) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isEmpty) return null;

      final place = placemarks.first;

      // Build a concise location name
      // Priority: subLocality > thoroughfare > locality
      if (place.subLocality?.isNotEmpty == true) {
        return place.subLocality;
      }
      if (place.thoroughfare?.isNotEmpty == true) {
        return place.thoroughfare;
      }
      if (place.locality?.isNotEmpty == true) {
        return place.locality;
      }

      return null;
    } catch (e) {
      return null;
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
