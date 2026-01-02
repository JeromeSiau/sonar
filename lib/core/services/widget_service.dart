import 'package:home_widget/home_widget.dart';
import 'package:bluetooth_finder/features/favorites/data/repositories/favorites_repository.dart';

/// Service to update home screen widgets with favorite device data
class WidgetService {
  static const String appGroupId = 'group.com.music.bluetoothfinder';
  static const String iOSWidgetName = 'SonarWidget';
  static const String androidWidgetName = 'SonarWidgetProvider';

  WidgetService._();
  static final WidgetService instance = WidgetService._();

  /// Initialize the widget service
  Future<void> init() async {
    // Set the app group ID for iOS
    await HomeWidget.setAppGroupId(appGroupId);
  }

  /// Update widget with latest favorite devices data
  Future<void> updateWidget() async {
    final favorites = FavoritesRepository.instance.getAll();

    if (favorites.isEmpty) {
      await HomeWidget.saveWidgetData<String>('device_count', '0');
      await HomeWidget.saveWidgetData<String>('device_names', '');
      await HomeWidget.saveWidgetData<String>('last_updated', DateTime.now().toIso8601String());
    } else {
      // Save device count
      await HomeWidget.saveWidgetData<int>('device_count', favorites.length);

      // Save first 3 device names for display
      final deviceNames = favorites
          .take(3)
          .map((f) => f.customName)
          .join('\n');
      await HomeWidget.saveWidgetData<String>('device_names', deviceNames);

      // Save most recent device info
      final mostRecent = favorites.reduce((a, b) =>
          a.lastSeenAt.isAfter(b.lastSeenAt) ? a : b);
      await HomeWidget.saveWidgetData<String>('recent_device_name', mostRecent.customName);
      await HomeWidget.saveWidgetData<String>('recent_device_time', mostRecent.lastSeenAt.toIso8601String());
      await HomeWidget.saveWidgetData<int>('recent_device_rssi', mostRecent.lastRssi);

      // Save last updated timestamp
      await HomeWidget.saveWidgetData<String>('last_updated', DateTime.now().toIso8601String());
    }

    // Request widget update
    await HomeWidget.updateWidget(
      iOSName: iOSWidgetName,
      androidName: androidWidgetName,
    );
  }

  /// Register callback for widget interactions
  Future<void> registerInteractiveCallback() async {
    await HomeWidget.registerInteractivityCallback(widgetBackgroundCallback);
  }
}

/// Background callback for widget interactions
@pragma('vm:entry-point')
Future<void> widgetBackgroundCallback(Uri? uri) async {
  if (uri?.host == 'openapp') {
    // Widget was tapped, app will open automatically
  } else if (uri?.host == 'scan') {
    // User requested a scan from widget
    // Note: Background Bluetooth scanning is limited on iOS
  }
}
