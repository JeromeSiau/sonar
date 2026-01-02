// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appName => 'SONAR';

  @override
  String get appSubtitle => 'Vind AirPods & Koptelefoons';

  @override
  String get scanner => 'SCANNER';

  @override
  String get settings => 'INSTELLINGEN';

  @override
  String get noSavedDevices => 'Geen opgeslagen apparaten';

  @override
  String get noSavedDevicesDescription =>
      'Scan Bluetooth-apparaten in de buurt\nen voeg je favorieten toe';

  @override
  String get justNow => 'zojuist';

  @override
  String minutesAgo(int minutes) {
    return '$minutes min geleden';
  }

  @override
  String hoursAgo(int hours) {
    return '${hours}u geleden';
  }

  @override
  String daysAgo(int days) {
    return '${days}d geleden';
  }

  @override
  String get permissionsRequired => 'Machtigingen vereist';

  @override
  String get permissionsDescription =>
      'Om je Bluetooth-apparaten te vinden, hebben we toegang nodig tot Bluetooth en je locatie.';

  @override
  String get bluetooth => 'Bluetooth';

  @override
  String get bluetoothPermissionDescription => 'Apparaten in de buurt scannen';

  @override
  String get location => 'Locatie';

  @override
  String get locationPermissionDescription => 'Vereist voor Bluetooth-scan';

  @override
  String get authorize => 'Toestaan';

  @override
  String get scanError => 'Scanfout';

  @override
  String get checkBluetoothEnabled => 'Controleer of Bluetooth is ingeschakeld';

  @override
  String get retry => 'OPNIEUW';

  @override
  String get trialUsed => 'Gratis proefperiode gebruikt';

  @override
  String get trialAvailable => '1 gratis radar proefperiode beschikbaar';

  @override
  String get unlock => 'ONTGRENDELEN';

  @override
  String devicesFound(int count) {
    return '$count apparaten gevonden';
  }

  @override
  String get premium => 'PREMIUM';

  @override
  String get scanning => 'SCANNEN';

  @override
  String get searchingDevices => 'Zoeken naar Bluetooth-apparaten...';

  @override
  String get scanInProgress => 'Scan bezig...';

  @override
  String get deviceNotFound => 'Apparaat niet gevonden';

  @override
  String get searchingForDevice => 'Apparaat zoeken...';

  @override
  String get deviceNotInRange => 'Apparaat buiten bereik';

  @override
  String get deviceNotInRangeDescription =>
      'Het apparaat wordt niet gedetecteerd. Zorg ervoor dat het aan staat en dichtbij is.';

  @override
  String get backToHome => 'Terug';

  @override
  String get radarInstruction =>
      'Beweeg je en volg de signaalsterkte om je apparaat te vinden';

  @override
  String get signalLost => 'Signaal verloren';

  @override
  String get found => 'Gevonden!';

  @override
  String get cancel => 'Annuleren';

  @override
  String get playSound => 'Geluid afspelen';

  @override
  String get stopSound => 'Geluid stoppen';

  @override
  String get playSoundDescription =>
      'Speelt een geluid af op het apparaat indien verbonden';

  @override
  String get soundPlaying => 'Geluid speelt...';

  @override
  String get deviceMustBeConnected =>
      'Het apparaat moet verbonden zijn (niet alleen zichtbaar)';

  @override
  String get subscription => 'ABONNEMENT';

  @override
  String get goPremium => 'Ga Premium';

  @override
  String get unlockAllFeatures => 'Ontgrendel alle functies';

  @override
  String get restorePurchases => 'Aankopen herstellen';

  @override
  String get restorePurchasesDescription =>
      'Een bestaand abonnement herstellen';

  @override
  String get restoringPurchases => 'Herstellen...';

  @override
  String get about => 'OVER';

  @override
  String get termsOfService => 'Gebruiksvoorwaarden';

  @override
  String get privacyPolicy => 'Privacybeleid';

  @override
  String get contactUs => 'Contact';

  @override
  String version(String version) {
    return 'Versie $version';
  }

  @override
  String get premiumStatus => 'Premium';

  @override
  String get freeStatus => 'Gratis';

  @override
  String get premiumDescription => 'Onbeperkte toegang tot alle functies';

  @override
  String get freeDescription => 'Beperkte functies';

  @override
  String get unlockRadar => 'Ontgrendel de Radar';

  @override
  String get locateAllDevices => 'Vind al je Bluetooth-apparaten';

  @override
  String get unlimitedRadar => 'Onbeperkte radar';

  @override
  String get unlimitedRadarDescription =>
      'Vind je apparaten zonder beperkingen';

  @override
  String get fullScan => 'Volledige scan';

  @override
  String get fullScanDescription => 'Zie alle apparaten in de buurt';

  @override
  String get favorites => 'Favorieten';

  @override
  String get favoritesDescription => 'Sla je belangrijke apparaten op';

  @override
  String get oneTimePurchase => 'Eenmalige aankoop';

  @override
  String get oneTimePurchaseDescription =>
      'Betaal eenmalig, gebruik voor altijd';

  @override
  String get oneTimePurchaseBadge => 'EENMALIG';

  @override
  String get unlockNow => 'Nu ontgrendelen';

  @override
  String get defaultPrice => '€ 4,99';

  @override
  String get weekly => 'Wekelijks';

  @override
  String get monthly => 'Maandelijks';

  @override
  String get lifetimePlan => 'Levenslang';

  @override
  String get bestValue => 'BESTE WAARDE';

  @override
  String get perWeek => '/week';

  @override
  String get perMonth => '/maand';

  @override
  String get weeklyPrice => '€ 2,99';

  @override
  String get monthlyPrice => '€ 5,99';

  @override
  String get lifetimePrice => '€ 14,99';

  @override
  String get language => 'Taal';

  @override
  String get languageDescription => 'Kies de app-taal';

  @override
  String get systemLanguage => 'Systeemtaal';

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
  String get bluetoothDisabled => 'Bluetooth uitgeschakeld';

  @override
  String get enableBluetoothDescription =>
      'Schakel Bluetooth in om apparaten te scannen';

  @override
  String get openSettings => 'INSTELLINGEN OPENEN';

  @override
  String get myDevices => 'Mijn apparaten';

  @override
  String get nearbyDevices => 'In de buurt';

  @override
  String get noDevicesFound => 'Geen apparaten gevonden';

  @override
  String get purchaseError => 'Aankoopfout';

  @override
  String get purchaseErrorDescription =>
      'Er is een fout opgetreden tijdens de aankoop. Probeer het opnieuw.';

  @override
  String get purchaseCancelled => 'Aankoop geannuleerd';

  @override
  String get networkError => 'Netwerkfout';

  @override
  String get networkErrorDescription =>
      'Controleer je internetverbinding en probeer het opnieuw.';

  @override
  String get loadingError => 'Kan aanbiedingen niet laden';

  @override
  String get loadingErrorDescription =>
      'Controleer je verbinding en probeer het opnieuw.';

  @override
  String get ok => 'OK';

  @override
  String get showUnnamedDevices => 'Naamloze apparaten tonen';

  @override
  String get whyDeviceNotVisible => 'Waarom zie ik mijn apparaat niet?';

  @override
  String get deviceVisibleConditions => 'Om een apparaat te zien:';

  @override
  String get deviceMustBeOn => 'Het apparaat moet aan staan';

  @override
  String get bluetoothMustBeEnabledOnDevice =>
      'Bluetooth moet ingeschakeld zijn op het apparaat';

  @override
  String get deviceMustBeInRange =>
      'Het apparaat moet binnen bereik zijn (< 10 meter)';

  @override
  String get someDevicesDontBroadcastName =>
      'Sommige apparaten zenden hun naam niet uit';

  @override
  String get tipShowUnnamedDevices =>
      'Tip: Schakel \"Naamloze apparaten tonen\" in om alle Bluetooth-apparaten te zien.';

  @override
  String get understood => 'Begrepen';

  @override
  String get pleaseEnableBluetoothSettings =>
      'Schakel Bluetooth in via je apparaatinstellingen.';

  @override
  String get onboardingSkip => 'Overslaan';

  @override
  String get onboardingNext => 'Volgende';

  @override
  String get onboardingStart => 'Starten';

  @override
  String get onboardingTitle1 => 'Vind je verloren apparaten';

  @override
  String get onboardingDesc1 =>
      'Onze precisieradar leidt je naar je oordopjes, AirPods en verloren Bluetooth-apparaten.';

  @override
  String get onboardingTitle2 => 'Sla je favorieten op';

  @override
  String get onboardingDesc2 =>
      'Voeg je belangrijke apparaten toe aan favorieten om ze direct te vinden.';

  @override
  String get onboardingTitle3 => 'Enkele machtigingen nodig';

  @override
  String get onboardingDesc3 =>
      'Om Bluetooth-apparaten te scannen en te vinden, hebben we je toestemming nodig.';

  @override
  String get lastSeenLocation => 'Laatst bekende locatie';

  @override
  String get noLocationHistory => 'Geen locatiegeschiedenis';

  @override
  String get noLocationHistoryDescription =>
      'De locatie wordt opgeslagen wanneer je dit apparaat vindt.';

  @override
  String get showOnMap => 'Op kaart bekijken';

  @override
  String get gpsAccuracyNotice =>
      'Algemene zone (~100m). Gebruik de radar voor precieze locatie.';

  @override
  String get openRadar => 'Radar openen';

  @override
  String get unknownDevice => 'Onbekend apparaat';

  @override
  String get featureUnlimitedRadar => 'Onbeperkte radarlocatie';

  @override
  String get featureFindAllDevices => 'Vind al je apparaten';

  @override
  String get featureAudioAlerts => 'Audio-waarschuwingen bij nadering';

  @override
  String get featureNoAds => 'Geen advertenties';

  @override
  String get featureLifetimeUpdates => 'Levenslange updates';

  @override
  String get free => 'GRATIS';

  @override
  String get tapDeviceToLocate => 'Tik op een apparaat om te vinden';

  @override
  String get signal => 'SIGNAAL';
}
