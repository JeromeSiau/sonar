// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'SONAR';

  @override
  String get appSubtitle => 'Find AirPods & Headphones';

  @override
  String get scanner => 'SCANNER';

  @override
  String get settings => 'RÉGLAGES';

  @override
  String get noSavedDevices => 'Aucun appareil sauvegardé';

  @override
  String get noSavedDevicesDescription =>
      'Scannez les appareils Bluetooth à proximité\net ajoutez vos favoris pour les retrouver facilement';

  @override
  String get justNow => 'à l\'instant';

  @override
  String minutesAgo(int minutes) {
    return 'il y a $minutes min';
  }

  @override
  String hoursAgo(int hours) {
    return 'il y a ${hours}h';
  }

  @override
  String daysAgo(int days) {
    return 'il y a ${days}j';
  }

  @override
  String get permissionsRequired => 'Autorisations requises';

  @override
  String get permissionsDescription =>
      'Pour localiser vos appareils Bluetooth, nous avons besoin d\'accéder au Bluetooth et à votre position.';

  @override
  String get bluetooth => 'Bluetooth';

  @override
  String get bluetoothPermissionDescription =>
      'Scanner les appareils à proximité';

  @override
  String get location => 'Localisation';

  @override
  String get locationPermissionDescription => 'Requis pour le scan Bluetooth';

  @override
  String get authorize => 'Autoriser';

  @override
  String get scanError => 'Erreur de scan';

  @override
  String get checkBluetoothEnabled => 'Vérifiez que le Bluetooth est activé';

  @override
  String get retry => 'RÉESSAYER';

  @override
  String get trialUsed => 'Essai gratuit utilisé';

  @override
  String get trialAvailable => '1 essai radar gratuit disponible';

  @override
  String get unlock => 'DÉBLOQUER';

  @override
  String devicesFound(int count) {
    return '$count appareils trouvés';
  }

  @override
  String get premium => 'PREMIUM';

  @override
  String get scanning => 'SCANNING';

  @override
  String get searchingDevices => 'Recherche d\'appareils Bluetooth...';

  @override
  String get scanInProgress => 'Scan en cours...';

  @override
  String get deviceNotFound => 'Appareil non trouvé';

  @override
  String get searchingForDevice => 'Recherche de l\'appareil...';

  @override
  String get deviceNotInRange => 'Appareil hors de portée';

  @override
  String get deviceNotInRangeDescription =>
      'L\'appareil n\'est pas détecté. Assurez-vous qu\'il est allumé et à proximité.';

  @override
  String get backToHome => 'Retour';

  @override
  String get radarInstruction =>
      'Déplacez-vous et suivez la force du signal pour trouver votre appareil';

  @override
  String get signalLost => 'Signal perdu';

  @override
  String get found => 'Trouvé !';

  @override
  String get cancel => 'Annuler';

  @override
  String get subscription => 'ABONNEMENT';

  @override
  String get goPremium => 'Passer Premium';

  @override
  String get unlockAllFeatures => 'Débloquez toutes les fonctionnalités';

  @override
  String get restorePurchases => 'Restaurer les achats';

  @override
  String get restorePurchasesDescription => 'Récupérer un abonnement existant';

  @override
  String get restoringPurchases => 'Restauration en cours...';

  @override
  String get about => 'À PROPOS';

  @override
  String get termsOfService => 'Conditions d\'utilisation';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get contactUs => 'Nous contacter';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get premiumStatus => 'Premium';

  @override
  String get freeStatus => 'Gratuit';

  @override
  String get premiumDescription =>
      'Accès illimité à toutes les fonctionnalités';

  @override
  String get freeDescription => 'Fonctionnalités limitées';

  @override
  String get unlockRadar => 'Débloquez le Radar';

  @override
  String get locateAllDevices => 'Localisez tous vos appareils Bluetooth';

  @override
  String get unlimitedRadar => 'Radar illimité';

  @override
  String get unlimitedRadarDescription =>
      'Localisez vos appareils sans restriction';

  @override
  String get fullScan => 'Scan complet';

  @override
  String get fullScanDescription => 'Voyez tous les appareils à proximité';

  @override
  String get favorites => 'Favoris';

  @override
  String get favoritesDescription => 'Sauvegardez vos appareils importants';

  @override
  String get oneTimePurchase => 'Achat unique';

  @override
  String get oneTimePurchaseDescription =>
      'Payez une fois, utilisez pour toujours';

  @override
  String get oneTimePurchaseBadge => 'ACHAT UNIQUE';

  @override
  String get unlockNow => 'Débloquer maintenant';

  @override
  String get defaultPrice => '4,99 €';

  @override
  String get language => 'Langue';

  @override
  String get languageDescription => 'Choisir la langue de l\'application';

  @override
  String get systemLanguage => 'Langue du système';

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
  String get bluetoothDisabled => 'Bluetooth désactivé';

  @override
  String get enableBluetoothDescription =>
      'Activez le Bluetooth pour scanner les appareils à proximité';

  @override
  String get openSettings => 'OUVRIR RÉGLAGES';

  @override
  String get myDevices => 'Mes appareils';

  @override
  String get nearbyDevices => 'À proximité';

  @override
  String get noDevicesFound => 'Aucun appareil trouvé';

  @override
  String get purchaseError => 'Erreur d\'achat';

  @override
  String get purchaseErrorDescription =>
      'Une erreur s\'est produite lors de l\'achat. Veuillez réessayer.';

  @override
  String get purchaseCancelled => 'Achat annulé';

  @override
  String get networkError => 'Erreur réseau';

  @override
  String get networkErrorDescription =>
      'Veuillez vérifier votre connexion internet et réessayer.';

  @override
  String get loadingError => 'Impossible de charger les offres';

  @override
  String get loadingErrorDescription =>
      'Veuillez vérifier votre connexion et réessayer.';

  @override
  String get ok => 'OK';

  @override
  String get showUnnamedDevices => 'Afficher les appareils sans nom';

  @override
  String get whyDeviceNotVisible => 'Pourquoi je ne vois pas mon appareil ?';

  @override
  String get deviceVisibleConditions => 'Pour qu\'un appareil soit visible :';

  @override
  String get deviceMustBeOn => 'L\'appareil doit être allumé';

  @override
  String get bluetoothMustBeEnabledOnDevice =>
      'Le Bluetooth doit être activé sur l\'appareil';

  @override
  String get deviceMustBeInRange =>
      'L\'appareil doit être à portée (< 10 mètres)';

  @override
  String get someDevicesDontBroadcastName =>
      'Certains appareils n\'émettent pas leur nom';

  @override
  String get tipShowUnnamedDevices =>
      'Astuce : Activez \"Afficher les appareils sans nom\" pour voir tous les appareils Bluetooth à proximité.';

  @override
  String get understood => 'Compris';

  @override
  String get pleaseEnableBluetoothSettings =>
      'Veuillez activer le Bluetooth dans les réglages de votre appareil.';
}
