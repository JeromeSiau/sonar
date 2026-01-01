// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'SONAR';

  @override
  String get appSubtitle => 'Find AirPods & Headphones';

  @override
  String get scanner => 'SCANNER';

  @override
  String get settings => 'EINSTELLUNGEN';

  @override
  String get noSavedDevices => 'Keine gespeicherten Geräte';

  @override
  String get noSavedDevicesDescription =>
      'Scannen Sie Bluetooth-Geräte in der Nähe\nund fügen Sie Ihre Favoriten hinzu, um sie leicht zu finden';

  @override
  String get justNow => 'gerade eben';

  @override
  String minutesAgo(int minutes) {
    return 'vor $minutes Min.';
  }

  @override
  String hoursAgo(int hours) {
    return 'vor $hours Std.';
  }

  @override
  String daysAgo(int days) {
    return 'vor $days T.';
  }

  @override
  String get permissionsRequired => 'Berechtigungen erforderlich';

  @override
  String get permissionsDescription =>
      'Um Ihre Bluetooth-Geräte zu finden, benötigen wir Zugriff auf Bluetooth und Ihren Standort.';

  @override
  String get bluetooth => 'Bluetooth';

  @override
  String get bluetoothPermissionDescription => 'Geräte in der Nähe scannen';

  @override
  String get location => 'Standort';

  @override
  String get locationPermissionDescription => 'Erforderlich für Bluetooth-Scan';

  @override
  String get authorize => 'Autorisieren';

  @override
  String get scanError => 'Scan-Fehler';

  @override
  String get checkBluetoothEnabled => 'Prüfen Sie, ob Bluetooth aktiviert ist';

  @override
  String get retry => 'ERNEUT VERSUCHEN';

  @override
  String get trialUsed => 'Kostenlose Testversion verwendet';

  @override
  String get trialAvailable => '1 kostenlose Radar-Testversion verfügbar';

  @override
  String get unlock => 'FREISCHALTEN';

  @override
  String devicesFound(int count) {
    return '$count Geräte gefunden';
  }

  @override
  String get premium => 'PREMIUM';

  @override
  String get scanning => 'SCANNEN';

  @override
  String get searchingDevices => 'Suche nach Bluetooth-Geräten...';

  @override
  String get scanInProgress => 'Scan läuft...';

  @override
  String get deviceNotFound => 'Gerät nicht gefunden';

  @override
  String get searchingForDevice => 'Suche nach Gerät...';

  @override
  String get deviceNotInRange => 'Gerät außer Reichweite';

  @override
  String get deviceNotInRangeDescription =>
      'Das Gerät wurde nicht erkannt. Stellen Sie sicher, dass es eingeschaltet und in der Nähe ist.';

  @override
  String get backToHome => 'Zurück';

  @override
  String get radarInstruction =>
      'Bewegen Sie sich und folgen Sie der Signalstärke, um Ihr Gerät zu finden';

  @override
  String get signalLost => 'Signal verloren';

  @override
  String get found => 'Gefunden!';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get playSound => 'Ton abspielen';

  @override
  String get stopSound => 'Ton stoppen';

  @override
  String get playSoundDescription =>
      'Spielt einen Ton auf dem Gerät ab, wenn verbunden';

  @override
  String get soundPlaying => 'Ton wird abgespielt...';

  @override
  String get deviceMustBeConnected =>
      'Gerät muss verbunden sein (nicht nur sichtbar)';

  @override
  String get subscription => 'ABONNEMENT';

  @override
  String get goPremium => 'Premium werden';

  @override
  String get unlockAllFeatures => 'Alle Funktionen freischalten';

  @override
  String get restorePurchases => 'Käufe wiederherstellen';

  @override
  String get restorePurchasesDescription =>
      'Ein bestehendes Abonnement wiederherstellen';

  @override
  String get restoringPurchases => 'Käufe werden wiederhergestellt...';

  @override
  String get about => 'ÜBER';

  @override
  String get termsOfService => 'Nutzungsbedingungen';

  @override
  String get privacyPolicy => 'Datenschutzrichtlinie';

  @override
  String get contactUs => 'Kontaktieren Sie uns';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get premiumStatus => 'Premium';

  @override
  String get freeStatus => 'Kostenlos';

  @override
  String get premiumDescription => 'Unbegrenzter Zugang zu allen Funktionen';

  @override
  String get freeDescription => 'Eingeschränkte Funktionen';

  @override
  String get unlockRadar => 'Radar freischalten';

  @override
  String get locateAllDevices => 'Finden Sie alle Ihre Bluetooth-Geräte';

  @override
  String get unlimitedRadar => 'Unbegrenztes Radar';

  @override
  String get unlimitedRadarDescription =>
      'Finden Sie Ihre Geräte ohne Einschränkungen';

  @override
  String get fullScan => 'Vollständiger Scan';

  @override
  String get fullScanDescription => 'Alle Geräte in der Nähe sehen';

  @override
  String get favorites => 'Favoriten';

  @override
  String get favoritesDescription => 'Speichern Sie Ihre wichtigen Geräte';

  @override
  String get oneTimePurchase => 'Einmalkauf';

  @override
  String get oneTimePurchaseDescription => 'Einmal zahlen, für immer nutzen';

  @override
  String get oneTimePurchaseBadge => 'EINMALKAUF';

  @override
  String get unlockNow => 'Jetzt freischalten';

  @override
  String get defaultPrice => '4,99 €';

  @override
  String get weekly => 'Wöchentlich';

  @override
  String get monthly => 'Monatlich';

  @override
  String get lifetimePlan => 'Lebenslang';

  @override
  String get bestValue => 'BESTER WERT';

  @override
  String get perWeek => '/Woche';

  @override
  String get perMonth => '/Monat';

  @override
  String get weeklyPrice => '2,99 €';

  @override
  String get monthlyPrice => '5,99 €';

  @override
  String get lifetimePrice => '14,99 €';

  @override
  String get language => 'Sprache';

  @override
  String get languageDescription => 'App-Sprache wählen';

  @override
  String get systemLanguage => 'Systemsprache';

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
  String get bluetoothDisabled => 'Bluetooth ist aus';

  @override
  String get enableBluetoothDescription =>
      'Aktivieren Sie Bluetooth, um Geräte in der Nähe zu scannen';

  @override
  String get openSettings => 'EINSTELLUNGEN ÖFFNEN';

  @override
  String get myDevices => 'Meine Geräte';

  @override
  String get nearbyDevices => 'In der Nähe';

  @override
  String get noDevicesFound => 'Keine Geräte gefunden';

  @override
  String get purchaseError => 'Kauffehler';

  @override
  String get purchaseErrorDescription =>
      'Beim Kauf ist ein Fehler aufgetreten. Bitte versuchen Sie es erneut.';

  @override
  String get purchaseCancelled => 'Kauf abgebrochen';

  @override
  String get networkError => 'Netzwerkfehler';

  @override
  String get networkErrorDescription =>
      'Bitte überprüfen Sie Ihre Internetverbindung und versuchen Sie es erneut.';

  @override
  String get loadingError => 'Angebote konnten nicht geladen werden';

  @override
  String get loadingErrorDescription =>
      'Bitte überprüfen Sie Ihre Verbindung und versuchen Sie es erneut.';

  @override
  String get ok => 'OK';

  @override
  String get showUnnamedDevices => 'Unbenannte Geräte anzeigen';

  @override
  String get whyDeviceNotVisible => 'Warum sehe ich mein Gerät nicht?';

  @override
  String get deviceVisibleConditions => 'Damit ein Gerät sichtbar ist:';

  @override
  String get deviceMustBeOn => 'Das Gerät muss eingeschaltet sein';

  @override
  String get bluetoothMustBeEnabledOnDevice =>
      'Bluetooth muss auf dem Gerät aktiviert sein';

  @override
  String get deviceMustBeInRange =>
      'Das Gerät muss in Reichweite sein (< 10 Meter)';

  @override
  String get someDevicesDontBroadcastName =>
      'Einige Geräte senden ihren Namen nicht';

  @override
  String get tipShowUnnamedDevices =>
      'Tipp: Aktivieren Sie \"Unbenannte Geräte anzeigen\", um alle Bluetooth-Geräte in der Nähe zu sehen.';

  @override
  String get understood => 'Verstanden';

  @override
  String get pleaseEnableBluetoothSettings =>
      'Bitte aktivieren Sie Bluetooth in den Geräteeinstellungen.';
}
