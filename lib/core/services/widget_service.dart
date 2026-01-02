import 'dart:convert';
import 'package:home_widget/home_widget.dart';
import 'package:bluetooth_finder/features/favorites/data/repositories/favorites_repository.dart';

class WidgetService {
  static const String appGroupId = 'group.com.levelup.sonarapp';
  static const String iOSWidgetName = 'SonarWidget';
  static const String androidWidgetName = 'SonarWidgetProvider';

  WidgetService._();
  static final WidgetService instance = WidgetService._();

  /// Initialize the widget service
  Future<void> init() async {
    // Set the app group ID for iOS
    await HomeWidget.setAppGroupId(appGroupId);
  }

  Future<void> updateWidget() async {
    final favorites = FavoritesRepository.instance.getAll();

    if (favorites.isEmpty) {
      await HomeWidget.saveWidgetData<int>('device_count', 0);
      await HomeWidget.saveWidgetData<String>('devices_json', '[]');
    } else {
      await HomeWidget.saveWidgetData<int>('device_count', favorites.length);

      // Store device data as JSON array (first 3 devices)
      final devicesData = favorites
          .take(3)
          .map(
            (f) => {
              'name': f.customName,
              'id': f.id,
              'lastSeenAt': f.lastSeenAt.toUtc().toIso8601String(),
              'location': f.lastLocationName ?? '',
            },
          )
          .toList();

      await HomeWidget.saveWidgetData<String>(
        'devices_json',
        jsonEncode(devicesData),
      );
    }

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
