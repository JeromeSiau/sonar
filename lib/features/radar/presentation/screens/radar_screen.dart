import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bluetooth_finder/features/scanner/presentation/providers/scanner_provider.dart';
import 'package:bluetooth_finder/features/favorites/presentation/providers/favorites_provider.dart';
import 'package:bluetooth_finder/features/radar/presentation/widgets/radar_widget.dart';
import 'package:bluetooth_finder/shared/widgets/heart_button.dart';

class RadarScreen extends ConsumerWidget {
  final String deviceId;

  const RadarScreen({super.key, required this.deviceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final device = ref.watch(selectedDeviceProvider);
    final rssiAsync = ref.watch(deviceRssiStreamProvider(deviceId));
    final isFavorite = ref.watch(isFavoriteProvider(deviceId));

    if (device == null) {
      return const Scaffold(
        body: Center(child: Text('Appareil non trouvé')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(device.name),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: HeartButton(
              isFavorite: isFavorite,
              size: 28,
              onPressed: () {
                ref.read(favoritesProvider.notifier).toggleFavorite(device);
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: rssiAsync.when(
          data: (rssi) => RadarWidget(
            rssi: rssi,
            deviceName: device.name,
          ),
          loading: () => RadarWidget(
            rssi: device.rssi,
            deviceName: device.name,
          ),
          error: (_, __) => const Center(
            child: Text('Signal perdu'),
          ),
        ),
      ),
    );
  }
}
