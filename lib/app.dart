import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';
import 'package:bluetooth_finder/core/theme/app_theme.dart';
import 'package:bluetooth_finder/core/router/app_router.dart';
import 'package:bluetooth_finder/core/providers/locale_provider.dart';
import 'package:bluetooth_finder/l10n/app_localizations.dart';

class BluetoothFinderApp extends ConsumerStatefulWidget {
  const BluetoothFinderApp({super.key});

  @override
  ConsumerState<BluetoothFinderApp> createState() => _BluetoothFinderAppState();
}

class _BluetoothFinderAppState extends ConsumerState<BluetoothFinderApp> {
  StreamSubscription<Uri?>? _widgetClickSubscription;

  @override
  void initState() {
    super.initState();
    _setupWidgetDeepLinks();
  }

  @override
  void dispose() {
    _widgetClickSubscription?.cancel();
    super.dispose();
  }

  void _setupWidgetDeepLinks() {
    HomeWidget.initiallyLaunchedFromHomeWidget().then(_handleWidgetUri);
    _widgetClickSubscription = HomeWidget.widgetClicked.listen(
      _handleWidgetUri,
    );
  }

  void _handleWidgetUri(Uri? uri) {
    if (uri == null) return;

    if (uri.host == 'radar' && uri.pathSegments.isNotEmpty) {
      final deviceId = Uri.decodeComponent(uri.pathSegments.first);
      appRouter.push('/radar/$deviceId');
    } else if (uri.host == 'scanner') {
      appRouter.push('/scanner');
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'Sonar',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: appRouter,
      locale: locale,
      supportedLocales: LocaleNotifier.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
