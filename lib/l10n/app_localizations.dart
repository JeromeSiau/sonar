import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('nl'),
    Locale('pl'),
    Locale('pt'),
    Locale('tr'),
  ];

  /// No description provided for @appName.
  ///
  /// In fr, this message translates to:
  /// **'SONAR'**
  String get appName;

  /// No description provided for @appSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Find AirPods & Headphones'**
  String get appSubtitle;

  /// No description provided for @scanner.
  ///
  /// In fr, this message translates to:
  /// **'SCANNER'**
  String get scanner;

  /// No description provided for @settings.
  ///
  /// In fr, this message translates to:
  /// **'RÉGLAGES'**
  String get settings;

  /// No description provided for @noSavedDevices.
  ///
  /// In fr, this message translates to:
  /// **'Aucun appareil sauvegardé'**
  String get noSavedDevices;

  /// No description provided for @noSavedDevicesDescription.
  ///
  /// In fr, this message translates to:
  /// **'Scannez les appareils Bluetooth à proximité\net ajoutez vos favoris pour les retrouver facilement'**
  String get noSavedDevicesDescription;

  /// No description provided for @justNow.
  ///
  /// In fr, this message translates to:
  /// **'à l\'instant'**
  String get justNow;

  /// No description provided for @minutesAgo.
  ///
  /// In fr, this message translates to:
  /// **'il y a {minutes} min'**
  String minutesAgo(int minutes);

  /// No description provided for @hoursAgo.
  ///
  /// In fr, this message translates to:
  /// **'il y a {hours}h'**
  String hoursAgo(int hours);

  /// No description provided for @daysAgo.
  ///
  /// In fr, this message translates to:
  /// **'il y a {days}j'**
  String daysAgo(int days);

  /// No description provided for @permissionsRequired.
  ///
  /// In fr, this message translates to:
  /// **'Autorisations requises'**
  String get permissionsRequired;

  /// No description provided for @permissionsDescription.
  ///
  /// In fr, this message translates to:
  /// **'Pour localiser vos appareils Bluetooth, nous avons besoin d\'accéder au Bluetooth et à votre position.'**
  String get permissionsDescription;

  /// No description provided for @bluetooth.
  ///
  /// In fr, this message translates to:
  /// **'Bluetooth'**
  String get bluetooth;

  /// No description provided for @bluetoothPermissionDescription.
  ///
  /// In fr, this message translates to:
  /// **'Scanner les appareils à proximité'**
  String get bluetoothPermissionDescription;

  /// No description provided for @location.
  ///
  /// In fr, this message translates to:
  /// **'Localisation'**
  String get location;

  /// No description provided for @locationPermissionDescription.
  ///
  /// In fr, this message translates to:
  /// **'Requis pour le scan Bluetooth'**
  String get locationPermissionDescription;

  /// No description provided for @authorize.
  ///
  /// In fr, this message translates to:
  /// **'Autoriser'**
  String get authorize;

  /// No description provided for @scanError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur de scan'**
  String get scanError;

  /// No description provided for @checkBluetoothEnabled.
  ///
  /// In fr, this message translates to:
  /// **'Vérifiez que le Bluetooth est activé'**
  String get checkBluetoothEnabled;

  /// No description provided for @retry.
  ///
  /// In fr, this message translates to:
  /// **'RÉESSAYER'**
  String get retry;

  /// No description provided for @trialUsed.
  ///
  /// In fr, this message translates to:
  /// **'Essai gratuit utilisé'**
  String get trialUsed;

  /// No description provided for @trialAvailable.
  ///
  /// In fr, this message translates to:
  /// **'1 essai radar gratuit disponible'**
  String get trialAvailable;

  /// No description provided for @unlock.
  ///
  /// In fr, this message translates to:
  /// **'DÉBLOQUER'**
  String get unlock;

  /// No description provided for @devicesFound.
  ///
  /// In fr, this message translates to:
  /// **'{count} appareils trouvés'**
  String devicesFound(int count);

  /// No description provided for @premium.
  ///
  /// In fr, this message translates to:
  /// **'PREMIUM'**
  String get premium;

  /// No description provided for @scanning.
  ///
  /// In fr, this message translates to:
  /// **'SCANNING'**
  String get scanning;

  /// No description provided for @searchingDevices.
  ///
  /// In fr, this message translates to:
  /// **'Recherche d\'appareils Bluetooth...'**
  String get searchingDevices;

  /// No description provided for @scanInProgress.
  ///
  /// In fr, this message translates to:
  /// **'Scan en cours...'**
  String get scanInProgress;

  /// No description provided for @deviceNotFound.
  ///
  /// In fr, this message translates to:
  /// **'Appareil non trouvé'**
  String get deviceNotFound;

  /// No description provided for @searchingForDevice.
  ///
  /// In fr, this message translates to:
  /// **'Recherche de l\'appareil...'**
  String get searchingForDevice;

  /// No description provided for @deviceNotInRange.
  ///
  /// In fr, this message translates to:
  /// **'Appareil hors de portée'**
  String get deviceNotInRange;

  /// No description provided for @deviceNotInRangeDescription.
  ///
  /// In fr, this message translates to:
  /// **'L\'appareil n\'est pas détecté. Assurez-vous qu\'il est allumé et à proximité.'**
  String get deviceNotInRangeDescription;

  /// No description provided for @backToHome.
  ///
  /// In fr, this message translates to:
  /// **'Retour'**
  String get backToHome;

  /// No description provided for @radarInstruction.
  ///
  /// In fr, this message translates to:
  /// **'Déplacez-vous et suivez la force du signal pour trouver votre appareil'**
  String get radarInstruction;

  /// No description provided for @signalLost.
  ///
  /// In fr, this message translates to:
  /// **'Signal perdu'**
  String get signalLost;

  /// No description provided for @found.
  ///
  /// In fr, this message translates to:
  /// **'Trouvé !'**
  String get found;

  /// No description provided for @cancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get cancel;

  /// No description provided for @playSound.
  ///
  /// In fr, this message translates to:
  /// **'Jouer un son'**
  String get playSound;

  /// No description provided for @stopSound.
  ///
  /// In fr, this message translates to:
  /// **'Arrêter le son'**
  String get stopSound;

  /// No description provided for @playSoundDescription.
  ///
  /// In fr, this message translates to:
  /// **'Fait sonner l\'appareil s\'il est connecté'**
  String get playSoundDescription;

  /// No description provided for @soundPlaying.
  ///
  /// In fr, this message translates to:
  /// **'Son en cours...'**
  String get soundPlaying;

  /// No description provided for @deviceMustBeConnected.
  ///
  /// In fr, this message translates to:
  /// **'L\'appareil doit être connecté (pas seulement visible)'**
  String get deviceMustBeConnected;

  /// No description provided for @subscription.
  ///
  /// In fr, this message translates to:
  /// **'ABONNEMENT'**
  String get subscription;

  /// No description provided for @goPremium.
  ///
  /// In fr, this message translates to:
  /// **'Passer Premium'**
  String get goPremium;

  /// No description provided for @unlockAllFeatures.
  ///
  /// In fr, this message translates to:
  /// **'Débloquez toutes les fonctionnalités'**
  String get unlockAllFeatures;

  /// No description provided for @restorePurchases.
  ///
  /// In fr, this message translates to:
  /// **'Restaurer les achats'**
  String get restorePurchases;

  /// No description provided for @restorePurchasesDescription.
  ///
  /// In fr, this message translates to:
  /// **'Récupérer un abonnement existant'**
  String get restorePurchasesDescription;

  /// No description provided for @restoringPurchases.
  ///
  /// In fr, this message translates to:
  /// **'Restauration en cours...'**
  String get restoringPurchases;

  /// No description provided for @about.
  ///
  /// In fr, this message translates to:
  /// **'À PROPOS'**
  String get about;

  /// No description provided for @termsOfService.
  ///
  /// In fr, this message translates to:
  /// **'Conditions d\'utilisation'**
  String get termsOfService;

  /// No description provided for @privacyPolicy.
  ///
  /// In fr, this message translates to:
  /// **'Politique de confidentialité'**
  String get privacyPolicy;

  /// No description provided for @contactUs.
  ///
  /// In fr, this message translates to:
  /// **'Nous contacter'**
  String get contactUs;

  /// No description provided for @version.
  ///
  /// In fr, this message translates to:
  /// **'Version {version}'**
  String version(String version);

  /// No description provided for @premiumStatus.
  ///
  /// In fr, this message translates to:
  /// **'Premium'**
  String get premiumStatus;

  /// No description provided for @freeStatus.
  ///
  /// In fr, this message translates to:
  /// **'Gratuit'**
  String get freeStatus;

  /// No description provided for @premiumDescription.
  ///
  /// In fr, this message translates to:
  /// **'Accès illimité à toutes les fonctionnalités'**
  String get premiumDescription;

  /// No description provided for @freeDescription.
  ///
  /// In fr, this message translates to:
  /// **'Fonctionnalités limitées'**
  String get freeDescription;

  /// No description provided for @unlockRadar.
  ///
  /// In fr, this message translates to:
  /// **'Débloquez le Radar'**
  String get unlockRadar;

  /// No description provided for @locateAllDevices.
  ///
  /// In fr, this message translates to:
  /// **'Localisez tous vos appareils Bluetooth'**
  String get locateAllDevices;

  /// No description provided for @unlimitedRadar.
  ///
  /// In fr, this message translates to:
  /// **'Radar illimité'**
  String get unlimitedRadar;

  /// No description provided for @unlimitedRadarDescription.
  ///
  /// In fr, this message translates to:
  /// **'Localisez vos appareils sans restriction'**
  String get unlimitedRadarDescription;

  /// No description provided for @fullScan.
  ///
  /// In fr, this message translates to:
  /// **'Scan complet'**
  String get fullScan;

  /// No description provided for @fullScanDescription.
  ///
  /// In fr, this message translates to:
  /// **'Voyez tous les appareils à proximité'**
  String get fullScanDescription;

  /// No description provided for @favorites.
  ///
  /// In fr, this message translates to:
  /// **'Favoris'**
  String get favorites;

  /// No description provided for @favoritesDescription.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegardez vos appareils importants'**
  String get favoritesDescription;

  /// No description provided for @oneTimePurchase.
  ///
  /// In fr, this message translates to:
  /// **'Achat unique'**
  String get oneTimePurchase;

  /// No description provided for @oneTimePurchaseDescription.
  ///
  /// In fr, this message translates to:
  /// **'Payez une fois, utilisez pour toujours'**
  String get oneTimePurchaseDescription;

  /// No description provided for @oneTimePurchaseBadge.
  ///
  /// In fr, this message translates to:
  /// **'ACHAT UNIQUE'**
  String get oneTimePurchaseBadge;

  /// No description provided for @unlockNow.
  ///
  /// In fr, this message translates to:
  /// **'Débloquer maintenant'**
  String get unlockNow;

  /// No description provided for @defaultPrice.
  ///
  /// In fr, this message translates to:
  /// **'4,99 €'**
  String get defaultPrice;

  /// No description provided for @weekly.
  ///
  /// In fr, this message translates to:
  /// **'Hebdomadaire'**
  String get weekly;

  /// No description provided for @monthly.
  ///
  /// In fr, this message translates to:
  /// **'Mensuel'**
  String get monthly;

  /// No description provided for @lifetimePlan.
  ///
  /// In fr, this message translates to:
  /// **'À vie'**
  String get lifetimePlan;

  /// No description provided for @bestValue.
  ///
  /// In fr, this message translates to:
  /// **'MEILLEUR CHOIX'**
  String get bestValue;

  /// No description provided for @perWeek.
  ///
  /// In fr, this message translates to:
  /// **'/semaine'**
  String get perWeek;

  /// No description provided for @perMonth.
  ///
  /// In fr, this message translates to:
  /// **'/mois'**
  String get perMonth;

  /// No description provided for @weeklyPrice.
  ///
  /// In fr, this message translates to:
  /// **'2,99 €'**
  String get weeklyPrice;

  /// No description provided for @monthlyPrice.
  ///
  /// In fr, this message translates to:
  /// **'5,99 €'**
  String get monthlyPrice;

  /// No description provided for @lifetimePrice.
  ///
  /// In fr, this message translates to:
  /// **'14,99 €'**
  String get lifetimePrice;

  /// No description provided for @language.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get language;

  /// No description provided for @languageDescription.
  ///
  /// In fr, this message translates to:
  /// **'Choisir la langue de l\'application'**
  String get languageDescription;

  /// No description provided for @systemLanguage.
  ///
  /// In fr, this message translates to:
  /// **'Langue du système'**
  String get systemLanguage;

  /// No description provided for @french.
  ///
  /// In fr, this message translates to:
  /// **'Français'**
  String get french;

  /// No description provided for @english.
  ///
  /// In fr, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @spanish.
  ///
  /// In fr, this message translates to:
  /// **'Español'**
  String get spanish;

  /// No description provided for @german.
  ///
  /// In fr, this message translates to:
  /// **'Deutsch'**
  String get german;

  /// No description provided for @italian.
  ///
  /// In fr, this message translates to:
  /// **'Italiano'**
  String get italian;

  /// No description provided for @portuguese.
  ///
  /// In fr, this message translates to:
  /// **'Português'**
  String get portuguese;

  /// No description provided for @japanese.
  ///
  /// In fr, this message translates to:
  /// **'日本語'**
  String get japanese;

  /// No description provided for @korean.
  ///
  /// In fr, this message translates to:
  /// **'한국어'**
  String get korean;

  /// No description provided for @dutch.
  ///
  /// In fr, this message translates to:
  /// **'Nederlands'**
  String get dutch;

  /// No description provided for @polish.
  ///
  /// In fr, this message translates to:
  /// **'Polski'**
  String get polish;

  /// No description provided for @turkish.
  ///
  /// In fr, this message translates to:
  /// **'Türkçe'**
  String get turkish;

  /// No description provided for @bluetoothDisabled.
  ///
  /// In fr, this message translates to:
  /// **'Bluetooth désactivé'**
  String get bluetoothDisabled;

  /// No description provided for @enableBluetoothDescription.
  ///
  /// In fr, this message translates to:
  /// **'Activez le Bluetooth pour scanner les appareils à proximité'**
  String get enableBluetoothDescription;

  /// No description provided for @openSettings.
  ///
  /// In fr, this message translates to:
  /// **'OUVRIR RÉGLAGES'**
  String get openSettings;

  /// No description provided for @myDevices.
  ///
  /// In fr, this message translates to:
  /// **'Mes appareils'**
  String get myDevices;

  /// No description provided for @nearbyDevices.
  ///
  /// In fr, this message translates to:
  /// **'À proximité'**
  String get nearbyDevices;

  /// No description provided for @noDevicesFound.
  ///
  /// In fr, this message translates to:
  /// **'Aucun appareil trouvé'**
  String get noDevicesFound;

  /// No description provided for @purchaseError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur d\'achat'**
  String get purchaseError;

  /// No description provided for @purchaseErrorDescription.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur s\'est produite lors de l\'achat. Veuillez réessayer.'**
  String get purchaseErrorDescription;

  /// No description provided for @purchaseCancelled.
  ///
  /// In fr, this message translates to:
  /// **'Achat annulé'**
  String get purchaseCancelled;

  /// No description provided for @networkError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur réseau'**
  String get networkError;

  /// No description provided for @networkErrorDescription.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez vérifier votre connexion internet et réessayer.'**
  String get networkErrorDescription;

  /// No description provided for @loadingError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger les offres'**
  String get loadingError;

  /// No description provided for @loadingErrorDescription.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez vérifier votre connexion et réessayer.'**
  String get loadingErrorDescription;

  /// No description provided for @ok.
  ///
  /// In fr, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @showUnnamedDevices.
  ///
  /// In fr, this message translates to:
  /// **'Afficher les appareils sans nom'**
  String get showUnnamedDevices;

  /// No description provided for @whyDeviceNotVisible.
  ///
  /// In fr, this message translates to:
  /// **'Pourquoi je ne vois pas mon appareil ?'**
  String get whyDeviceNotVisible;

  /// No description provided for @deviceVisibleConditions.
  ///
  /// In fr, this message translates to:
  /// **'Pour qu\'un appareil soit visible :'**
  String get deviceVisibleConditions;

  /// No description provided for @deviceMustBeOn.
  ///
  /// In fr, this message translates to:
  /// **'L\'appareil doit être allumé'**
  String get deviceMustBeOn;

  /// No description provided for @bluetoothMustBeEnabledOnDevice.
  ///
  /// In fr, this message translates to:
  /// **'Le Bluetooth doit être activé sur l\'appareil'**
  String get bluetoothMustBeEnabledOnDevice;

  /// No description provided for @deviceMustBeInRange.
  ///
  /// In fr, this message translates to:
  /// **'L\'appareil doit être à portée (< 10 mètres)'**
  String get deviceMustBeInRange;

  /// No description provided for @someDevicesDontBroadcastName.
  ///
  /// In fr, this message translates to:
  /// **'Certains appareils n\'émettent pas leur nom'**
  String get someDevicesDontBroadcastName;

  /// No description provided for @tipShowUnnamedDevices.
  ///
  /// In fr, this message translates to:
  /// **'Astuce : Activez \"Afficher les appareils sans nom\" pour voir tous les appareils Bluetooth à proximité.'**
  String get tipShowUnnamedDevices;

  /// No description provided for @understood.
  ///
  /// In fr, this message translates to:
  /// **'Compris'**
  String get understood;

  /// No description provided for @pleaseEnableBluetoothSettings.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez activer le Bluetooth dans les réglages de votre appareil.'**
  String get pleaseEnableBluetoothSettings;

  /// No description provided for @onboardingSkip.
  ///
  /// In fr, this message translates to:
  /// **'Passer'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In fr, this message translates to:
  /// **'Suivant'**
  String get onboardingNext;

  /// No description provided for @onboardingStart.
  ///
  /// In fr, this message translates to:
  /// **'Commencer'**
  String get onboardingStart;

  /// No description provided for @onboardingTitle1.
  ///
  /// In fr, this message translates to:
  /// **'Retrouvez vos appareils perdus'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDesc1.
  ///
  /// In fr, this message translates to:
  /// **'Notre radar de précision vous guide vers vos écouteurs, AirPods et appareils Bluetooth égarés.'**
  String get onboardingDesc1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegardez vos favoris'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDesc2.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez vos appareils importants en favoris pour les retrouver instantanément à chaque utilisation.'**
  String get onboardingDesc2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In fr, this message translates to:
  /// **'Quelques autorisations nécessaires'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDesc3.
  ///
  /// In fr, this message translates to:
  /// **'Pour scanner les appareils Bluetooth et vous aider à les localiser, nous avons besoin de votre permission.'**
  String get onboardingDesc3;

  /// No description provided for @lastSeenLocation.
  ///
  /// In fr, this message translates to:
  /// **'Dernière position connue'**
  String get lastSeenLocation;

  /// No description provided for @noLocationHistory.
  ///
  /// In fr, this message translates to:
  /// **'Aucune position enregistrée'**
  String get noLocationHistory;

  /// No description provided for @noLocationHistoryDescription.
  ///
  /// In fr, this message translates to:
  /// **'La position sera enregistrée quand vous retrouverez cet appareil.'**
  String get noLocationHistoryDescription;

  /// No description provided for @showOnMap.
  ///
  /// In fr, this message translates to:
  /// **'Voir sur la carte'**
  String get showOnMap;

  /// No description provided for @gpsAccuracyNotice.
  ///
  /// In fr, this message translates to:
  /// **'Zone générale (~100m). Utilisez le radar pour localiser précisément.'**
  String get gpsAccuracyNotice;

  /// No description provided for @openRadar.
  ///
  /// In fr, this message translates to:
  /// **'Ouvrir le Radar'**
  String get openRadar;

  /// No description provided for @unknownDevice.
  ///
  /// In fr, this message translates to:
  /// **'Appareil inconnu'**
  String get unknownDevice;

  /// No description provided for @featureUnlimitedRadar.
  ///
  /// In fr, this message translates to:
  /// **'Localisation radar illimitée'**
  String get featureUnlimitedRadar;

  /// No description provided for @featureFindAllDevices.
  ///
  /// In fr, this message translates to:
  /// **'Retrouvez tous vos appareils'**
  String get featureFindAllDevices;

  /// No description provided for @featureAudioAlerts.
  ///
  /// In fr, this message translates to:
  /// **'Alertes audio de proximité'**
  String get featureAudioAlerts;

  /// No description provided for @featureNoAds.
  ///
  /// In fr, this message translates to:
  /// **'Sans publicité'**
  String get featureNoAds;

  /// No description provided for @featureLifetimeUpdates.
  ///
  /// In fr, this message translates to:
  /// **'Mises à jour à vie'**
  String get featureLifetimeUpdates;

  /// No description provided for @free.
  ///
  /// In fr, this message translates to:
  /// **'GRATUIT'**
  String get free;

  /// No description provided for @tapDeviceToLocate.
  ///
  /// In fr, this message translates to:
  /// **'Appuyez sur un appareil pour le localiser'**
  String get tapDeviceToLocate;

  /// No description provided for @signal.
  ///
  /// In fr, this message translates to:
  /// **'SIGNAL'**
  String get signal;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'it',
    'ja',
    'ko',
    'nl',
    'pl',
    'pt',
    'tr',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'nl':
      return AppLocalizationsNl();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
