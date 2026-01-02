import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:bluetooth_finder/core/theme/app_colors.dart';
import 'package:bluetooth_finder/features/favorites/data/models/favorite_device_model.dart';
import 'package:bluetooth_finder/features/favorites/presentation/providers/favorites_provider.dart';
import 'package:bluetooth_finder/l10n/app_localizations.dart';

class DeviceMapScreen extends ConsumerWidget {
  final String deviceId;

  const DeviceMapScreen({super.key, required this.deviceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorite = ref.watch(favoriteByIdProvider(deviceId));
    final l10n = AppLocalizations.of(context)!;

    if (favorite == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.deviceNotFound)),
        body: Center(child: Text(l10n.deviceNotFound)),
      );
    }

    if (!favorite.hasLastLocation) {
      return Scaffold(
        appBar: AppBar(title: Text(favorite.customName)),
        body: Container(
          decoration: BoxDecoration(gradient: AppColors.backgroundGradient),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_off_rounded,
                    size: 80,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.noLocationHistory,
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.noLocationHistoryDescription,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final deviceLocation = LatLng(favorite.lastLatitude!, favorite.lastLongitude!);

    return Scaffold(
      appBar: AppBar(
        title: Text(favorite.customName),
      ),
      body: Stack(
        children: [
          // Map
          FlutterMap(
            options: MapOptions(
              initialCenter: deviceLocation,
              initialZoom: 16.0,
              minZoom: 3.0,
              maxZoom: 18.0,
            ),
            children: [
              // OpenStreetMap tiles (free)
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.music.bluetoothfinder',
                maxZoom: 19,
              ),
              // Device marker
              MarkerLayer(
                markers: [
                  Marker(
                    point: deviceLocation,
                    width: 80,
                    height: 80,
                    child: _DeviceMarker(
                      deviceName: favorite.customName,
                      deviceType: favorite.deviceType,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Info card at bottom
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: _LocationInfoCard(favorite: favorite, l10n: l10n),
          ),
        ],
      ),
    );
  }
}

class _DeviceMarker extends StatelessWidget {
  final String deviceName;
  final dynamic deviceType;

  const _DeviceMarker({
    required this.deviceName,
    required this.deviceType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.4),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Icon(
            _getDeviceIcon(),
            color: Colors.black,
            size: 24,
          ),
        ),
        // Triangle pointer
        CustomPaint(
          size: const Size(16, 8),
          painter: _TrianglePainter(color: AppColors.primary),
        ),
      ],
    );
  }

  IconData _getDeviceIcon() {
    final typeName = deviceType.toString().split('.').last;
    switch (typeName) {
      case 'airpods':
      case 'earbuds':
        return Icons.earbuds_rounded;
      case 'headphones':
        return Icons.headphones_rounded;
      case 'speaker':
        return Icons.speaker_rounded;
      case 'watch':
        return Icons.watch_rounded;
      default:
        return Icons.bluetooth_rounded;
    }
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;

  _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = ui.Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LocationInfoCard extends StatelessWidget {
  final FavoriteDeviceModel favorite;
  final AppLocalizations l10n;

  const _LocationInfoCard({
    required this.favorite,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on_rounded,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.lastSeenLocation,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            favorite.lastLocationName ?? _formatCoordinates(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            _formatDate(favorite.lastSeenAt),
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCoordinates() {
    final lat = favorite.lastLatitude!.toStringAsFixed(5);
    final lng = favorite.lastLongitude!.toStringAsFixed(5);
    return '$lat, $lng';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) {
      return l10n.justNow;
    } else if (diff.inHours < 1) {
      return l10n.minutesAgo(diff.inMinutes);
    } else if (diff.inDays < 1) {
      return l10n.hoursAgo(diff.inHours);
    } else {
      return l10n.daysAgo(diff.inDays);
    }
  }
}
