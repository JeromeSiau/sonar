import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bluetooth_finder/core/theme/app_colors.dart';
import 'package:bluetooth_finder/features/scanner/presentation/providers/scanner_provider.dart';
import 'package:bluetooth_finder/features/scanner/presentation/widgets/device_card.dart';
import 'package:bluetooth_finder/features/paywall/presentation/providers/subscription_provider.dart';

class ScannerScreen extends ConsumerStatefulWidget {
  const ScannerScreen({super.key});

  @override
  ConsumerState<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends ConsumerState<ScannerScreen> {
  @override
  void initState() {
    super.initState();
    _startScan();
  }

  Future<void> _startScan() async {
    final repo = ref.read(bluetoothRepositoryProvider);
    ref.read(isScanningProvider.notifier).state = true;
    await repo.startScan();
    if (mounted) {
      ref.read(isScanningProvider.notifier).state = false;
    }
  }

  @override
  void dispose() {
    ref.read(bluetoothRepositoryProvider).stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isScanning = ref.watch(isScanningProvider);
    final devicesAsync = ref.watch(devicesStreamProvider);
    final isPremium = ref.watch(isPremiumProvider);
    final deviceLimit = ref.watch(freeDeviceLimitProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner'),
        actions: [
          if (isScanning)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
      body: devicesAsync.when(
        data: (devices) {
          if (devices.isEmpty) {
            return _buildSearchingState();
          }

          final displayDevices = isPremium
              ? devices
              : devices.take(deviceLimit).toList();

          return Column(
            children: [
              if (!isPremium && devices.length > deviceLimit)
                _buildUpgradeBanner(context, devices.length),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _startScan,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: displayDevices.length,
                    itemBuilder: (context, index) {
                      final device = displayDevices[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: DeviceCard(
                          device: device,
                          onTap: () {
                            ref.read(selectedDeviceProvider.notifier).state = device;
                            context.push('/radar/${device.id}');
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => _buildSearchingState(),
        error: (_, __) => _buildErrorState(),
      ),
    );
  }

  Widget _buildSearchingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Recherche en cours...',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Appareils Bluetooth à proximité',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 60,
            color: AppColors.signalWeak,
          ),
          const SizedBox(height: 24),
          Text(
            'Erreur de scan',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _startScan,
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }

  Widget _buildUpgradeBanner(BuildContext context, int totalDevices) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.lock_outline, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '$totalDevices appareils trouvés. Passez Premium pour tout voir.',
              style: const TextStyle(color: AppColors.textPrimary),
            ),
          ),
          TextButton(
            onPressed: () => context.push('/paywall'),
            child: const Text('Upgrade'),
          ),
        ],
      ),
    );
  }
}
