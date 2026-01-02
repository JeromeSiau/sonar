// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appName => 'SONAR';

  @override
  String get appSubtitle => 'Znajdź AirPods i słuchawki';

  @override
  String get scanner => 'SKANER';

  @override
  String get settings => 'USTAWIENIA';

  @override
  String get noSavedDevices => 'Brak zapisanych urządzeń';

  @override
  String get noSavedDevicesDescription =>
      'Skanuj pobliskie urządzenia Bluetooth\ni dodaj ulubione, aby łatwo je znaleźć';

  @override
  String get justNow => 'przed chwilą';

  @override
  String minutesAgo(int minutes) {
    return '$minutes min temu';
  }

  @override
  String hoursAgo(int hours) {
    return '$hours godz. temu';
  }

  @override
  String daysAgo(int days) {
    return '$days dni temu';
  }

  @override
  String get permissionsRequired => 'Wymagane uprawnienia';

  @override
  String get permissionsDescription =>
      'Aby zlokalizować urządzenia Bluetooth, potrzebujemy dostępu do Bluetooth i lokalizacji.';

  @override
  String get bluetooth => 'Bluetooth';

  @override
  String get bluetoothPermissionDescription => 'Skanowanie pobliskich urządzeń';

  @override
  String get location => 'Lokalizacja';

  @override
  String get locationPermissionDescription =>
      'Wymagane do skanowania Bluetooth';

  @override
  String get authorize => 'Zezwól';

  @override
  String get scanError => 'Błąd skanowania';

  @override
  String get checkBluetoothEnabled => 'Sprawdź, czy Bluetooth jest włączony';

  @override
  String get retry => 'PONÓW';

  @override
  String get trialUsed => 'Wykorzystano bezpłatną próbę';

  @override
  String get trialAvailable => 'Dostępna 1 bezpłatna próba radaru';

  @override
  String get unlock => 'ODBLOKUJ';

  @override
  String devicesFound(int count) {
    return 'Znaleziono $count urządzeń';
  }

  @override
  String get premium => 'PREMIUM';

  @override
  String get scanning => 'SKANOWANIE';

  @override
  String get searchingDevices => 'Wyszukiwanie urządzeń Bluetooth...';

  @override
  String get scanInProgress => 'Skanowanie w toku...';

  @override
  String get deviceNotFound => 'Nie znaleziono urządzenia';

  @override
  String get searchingForDevice => 'Szukanie urządzenia...';

  @override
  String get deviceNotInRange => 'Urządzenie poza zasięgiem';

  @override
  String get deviceNotInRangeDescription =>
      'Urządzenie nie zostało wykryte. Upewnij się, że jest włączone i w pobliżu.';

  @override
  String get backToHome => 'Wróć';

  @override
  String get radarInstruction =>
      'Poruszaj się i śledź siłę sygnału, aby znaleźć urządzenie';

  @override
  String get signalLost => 'Utracono sygnał';

  @override
  String get found => 'Znaleziono!';

  @override
  String get cancel => 'Anuluj';

  @override
  String get playSound => 'Odtwórz dźwięk';

  @override
  String get stopSound => 'Zatrzymaj dźwięk';

  @override
  String get playSoundDescription =>
      'Odtwarza dźwięk na urządzeniu, jeśli jest połączone';

  @override
  String get soundPlaying => 'Odtwarzanie...';

  @override
  String get deviceMustBeConnected =>
      'Urządzenie musi być połączone (nie tylko widoczne)';

  @override
  String get subscription => 'SUBSKRYPCJA';

  @override
  String get goPremium => 'Przejdź na Premium';

  @override
  String get unlockAllFeatures => 'Odblokuj wszystkie funkcje';

  @override
  String get restorePurchases => 'Przywróć zakupy';

  @override
  String get restorePurchasesDescription => 'Odzyskaj istniejącą subskrypcję';

  @override
  String get restoringPurchases => 'Przywracanie...';

  @override
  String get about => 'O APLIKACJI';

  @override
  String get termsOfService => 'Regulamin';

  @override
  String get privacyPolicy => 'Polityka prywatności';

  @override
  String get contactUs => 'Kontakt';

  @override
  String version(String version) {
    return 'Wersja $version';
  }

  @override
  String get premiumStatus => 'Premium';

  @override
  String get freeStatus => 'Bezpłatny';

  @override
  String get premiumDescription =>
      'Nieograniczony dostęp do wszystkich funkcji';

  @override
  String get freeDescription => 'Ograniczone funkcje';

  @override
  String get unlockRadar => 'Odblokuj Radar';

  @override
  String get locateAllDevices => 'Zlokalizuj wszystkie urządzenia Bluetooth';

  @override
  String get unlimitedRadar => 'Nieograniczony radar';

  @override
  String get unlimitedRadarDescription => 'Lokalizuj urządzenia bez ograniczeń';

  @override
  String get fullScan => 'Pełne skanowanie';

  @override
  String get fullScanDescription => 'Zobacz wszystkie pobliskie urządzenia';

  @override
  String get favorites => 'Ulubione';

  @override
  String get favoritesDescription => 'Zapisz ważne urządzenia';

  @override
  String get oneTimePurchase => 'Jednorazowy zakup';

  @override
  String get oneTimePurchaseDescription => 'Zapłać raz, używaj na zawsze';

  @override
  String get oneTimePurchaseBadge => 'JEDNORAZOWO';

  @override
  String get unlockNow => 'Odblokuj teraz';

  @override
  String get defaultPrice => '19,99 zł';

  @override
  String get weekly => 'Tygodniowo';

  @override
  String get monthly => 'Miesięcznie';

  @override
  String get lifetimePlan => 'Na zawsze';

  @override
  String get bestValue => 'NAJLEPSZA WARTOŚĆ';

  @override
  String get perWeek => '/tydzień';

  @override
  String get perMonth => '/miesiąc';

  @override
  String get weeklyPrice => '11,99 zł';

  @override
  String get monthlyPrice => '24,99 zł';

  @override
  String get lifetimePrice => '59,99 zł';

  @override
  String get language => 'Język';

  @override
  String get languageDescription => 'Wybierz język aplikacji';

  @override
  String get systemLanguage => 'Język systemowy';

  @override
  String get french => 'Français';

  @override
  String get english => 'English';

  @override
  String get spanish => 'Español';

  @override
  String get german => 'Deutsch';

  @override
  String get italian => 'Italiano';

  @override
  String get portuguese => 'Português';

  @override
  String get japanese => '日本語';

  @override
  String get korean => '한국어';

  @override
  String get dutch => 'Nederlands';

  @override
  String get polish => 'Polski';

  @override
  String get turkish => 'Türkçe';

  @override
  String get bluetoothDisabled => 'Bluetooth wyłączony';

  @override
  String get enableBluetoothDescription =>
      'Włącz Bluetooth, aby skanować urządzenia';

  @override
  String get openSettings => 'OTWÓRZ USTAWIENIA';

  @override
  String get myDevices => 'Moje urządzenia';

  @override
  String get nearbyDevices => 'W pobliżu';

  @override
  String get noDevicesFound => 'Nie znaleziono urządzeń';

  @override
  String get purchaseError => 'Błąd zakupu';

  @override
  String get purchaseErrorDescription =>
      'Wystąpił błąd podczas zakupu. Spróbuj ponownie.';

  @override
  String get purchaseCancelled => 'Zakup anulowany';

  @override
  String get networkError => 'Błąd sieci';

  @override
  String get networkErrorDescription =>
      'Sprawdź połączenie internetowe i spróbuj ponownie.';

  @override
  String get loadingError => 'Nie można załadować ofert';

  @override
  String get loadingErrorDescription =>
      'Sprawdź połączenie i spróbuj ponownie.';

  @override
  String get ok => 'OK';

  @override
  String get showUnnamedDevices => 'Pokaż urządzenia bez nazwy';

  @override
  String get whyDeviceNotVisible => 'Dlaczego nie widzę mojego urządzenia?';

  @override
  String get deviceVisibleConditions => 'Aby urządzenie było widoczne:';

  @override
  String get deviceMustBeOn => 'Urządzenie musi być włączone';

  @override
  String get bluetoothMustBeEnabledOnDevice =>
      'Bluetooth musi być włączony na urządzeniu';

  @override
  String get deviceMustBeInRange =>
      'Urządzenie musi być w zasięgu (< 10 metrów)';

  @override
  String get someDevicesDontBroadcastName =>
      'Niektóre urządzenia nie nadają swojej nazwy';

  @override
  String get tipShowUnnamedDevices =>
      'Wskazówka: Włącz \"Pokaż urządzenia bez nazwy\", aby zobaczyć wszystkie urządzenia Bluetooth.';

  @override
  String get understood => 'Rozumiem';

  @override
  String get pleaseEnableBluetoothSettings =>
      'Włącz Bluetooth w ustawieniach urządzenia.';

  @override
  String get onboardingSkip => 'Pomiń';

  @override
  String get onboardingNext => 'Dalej';

  @override
  String get onboardingStart => 'Rozpocznij';

  @override
  String get onboardingTitle1 => 'Znajdź zgubione urządzenia';

  @override
  String get onboardingDesc1 =>
      'Nasz precyzyjny radar prowadzi Cię do słuchawek, AirPods i zgubionych urządzeń Bluetooth.';

  @override
  String get onboardingTitle2 => 'Zapisz ulubione';

  @override
  String get onboardingDesc2 =>
      'Dodaj ważne urządzenia do ulubionych, aby natychmiast je znaleźć.';

  @override
  String get onboardingTitle3 => 'Potrzebne kilka uprawnień';

  @override
  String get onboardingDesc3 =>
      'Aby skanować i lokalizować urządzenia Bluetooth, potrzebujemy Twojej zgody.';

  @override
  String get lastSeenLocation => 'Ostatnia znana lokalizacja';

  @override
  String get noLocationHistory => 'Brak historii lokalizacji';

  @override
  String get noLocationHistoryDescription =>
      'Lokalizacja zostanie zapisana po znalezieniu tego urządzenia.';

  @override
  String get showOnMap => 'Pokaż na mapie';

  @override
  String get gpsAccuracyNotice =>
      'Ogólny obszar (~100m). Użyj radaru dla dokładnej lokalizacji.';

  @override
  String get openRadar => 'Otwórz Radar';

  @override
  String get unknownDevice => 'Nieznane urządzenie';

  @override
  String get featureUnlimitedRadar => 'Nieograniczona lokalizacja radarowa';

  @override
  String get featureFindAllDevices => 'Znajdź wszystkie urządzenia';

  @override
  String get featureAudioAlerts => 'Alerty dźwiękowe zbliżenia';

  @override
  String get featureNoAds => 'Bez reklam';

  @override
  String get featureLifetimeUpdates => 'Dożywotnie aktualizacje';

  @override
  String get free => 'BEZPŁATNIE';

  @override
  String get tapDeviceToLocate => 'Dotknij urządzenia, aby zlokalizować';

  @override
  String get signal => 'SYGNAŁ';
}
