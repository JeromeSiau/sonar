import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bluetooth_finder/core/theme/app_colors.dart';
import 'package:bluetooth_finder/features/favorites/presentation/providers/favorites_provider.dart';
import 'package:bluetooth_finder/shared/widgets/signal_indicator.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sonar'),
      ),
      body: favorites.isEmpty
          ? _buildEmptyState(context)
          : _buildFavoritesList(context, ref, favorites),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/scanner'),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.bluetooth_searching),
        label: const Text('Scanner'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.bluetooth_disabled,
            size: 80,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 24),
          Text(
            'Aucun appareil favori',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Scannez pour trouver vos appareils\net ajoutez-les en favoris',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList(
    BuildContext context,
    WidgetRef ref,
    List favorites,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final favorite = favorites[index];
        return Dismissible(
          key: Key(favorite.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            color: AppColors.signalWeak,
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) {
            ref.read(favoritesProvider.notifier).removeFavorite(favorite.id);
          },
          child: Card(
            child: ListTile(
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.bluetooth,
                  color: AppColors.primary,
                ),
              ),
              title: Text(favorite.customName),
              subtitle: Text(
                'Vu ${_formatLastSeen(favorite.lastSeenAt)}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              trailing: SignalIndicator(
                rssi: favorite.lastRssi,
                showDistance: false,
              ),
              onTap: () => context.push('/scanner'),
            ),
          ),
        );
      },
    );
  }

  String _formatLastSeen(DateTime lastSeen) {
    final diff = DateTime.now().difference(lastSeen);
    if (diff.inMinutes < 1) return "à l'instant";
    if (diff.inHours < 1) return 'il y a ${diff.inMinutes} min';
    if (diff.inDays < 1) return 'il y a ${diff.inHours}h';
    return 'il y a ${diff.inDays}j';
  }
}
