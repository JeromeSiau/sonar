import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

const _localeBoxName = 'locale_settings';
const _localeKey = 'selected_locale';

class LocaleNotifier extends StateNotifier<Locale?> {
  LocaleNotifier() : super(null) {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final box = await Hive.openBox<String>(_localeBoxName);
    final savedLocale = box.get(_localeKey);
    if (savedLocale != null) {
      state = Locale(savedLocale);
    }
  }

  Future<void> setLocale(Locale? locale) async {
    final box = await Hive.openBox<String>(_localeBoxName);
    if (locale == null) {
      await box.delete(_localeKey);
    } else {
      await box.put(_localeKey, locale.languageCode);
    }
    state = locale;
  }

  static const supportedLocales = [
    Locale('fr'),
    Locale('en'),
    Locale('es'),
    Locale('de'),
    Locale('it'),
  ];

  static String getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'fr':
        return 'Français';
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      case 'de':
        return 'Deutsch';
      case 'it':
        return 'Italiano';
      default:
        return languageCode;
    }
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale?>((ref) {
  return LocaleNotifier();
});
