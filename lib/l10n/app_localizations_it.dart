// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appName => 'SONAR';

  @override
  String get appSubtitle => 'Bluetooth Finder';

  @override
  String get scanner => 'SCANNER';

  @override
  String get settings => 'IMPOSTAZIONI';

  @override
  String get noSavedDevices => 'Nessun dispositivo salvato';

  @override
  String get noSavedDevicesDescription =>
      'Scansiona i dispositivi Bluetooth nelle vicinanze\ne aggiungi i tuoi preferiti per trovarli facilmente';

  @override
  String get justNow => 'adesso';

  @override
  String minutesAgo(int minutes) {
    return '$minutes min fa';
  }

  @override
  String hoursAgo(int hours) {
    return '${hours}h fa';
  }

  @override
  String daysAgo(int days) {
    return '${days}g fa';
  }

  @override
  String get permissionsRequired => 'Autorizzazioni richieste';

  @override
  String get permissionsDescription =>
      'Per localizzare i tuoi dispositivi Bluetooth, abbiamo bisogno di accedere al Bluetooth e alla tua posizione.';

  @override
  String get bluetooth => 'Bluetooth';

  @override
  String get bluetoothPermissionDescription =>
      'Scansiona dispositivi nelle vicinanze';

  @override
  String get location => 'Posizione';

  @override
  String get locationPermissionDescription =>
      'Richiesto per la scansione Bluetooth';

  @override
  String get authorize => 'Autorizza';

  @override
  String get scanError => 'Errore di scansione';

  @override
  String get checkBluetoothEnabled => 'Verifica che il Bluetooth sia attivato';

  @override
  String get retry => 'RIPROVA';

  @override
  String get trialUsed => 'Prova gratuita utilizzata';

  @override
  String get trialAvailable => '1 prova radar gratuita disponibile';

  @override
  String get unlock => 'SBLOCCA';

  @override
  String devicesFound(int count) {
    return '$count dispositivi trovati';
  }

  @override
  String get premium => 'PREMIUM';

  @override
  String get scanning => 'SCANSIONE';

  @override
  String get searchingDevices => 'Ricerca dispositivi Bluetooth...';

  @override
  String get scanInProgress => 'Scansione in corso...';

  @override
  String get deviceNotFound => 'Dispositivo non trovato';

  @override
  String get radarInstruction =>
      'Muoviti e segui la potenza del segnale per trovare il tuo dispositivo';

  @override
  String get signalLost => 'Segnale perso';

  @override
  String get found => 'Trovato!';

  @override
  String get cancel => 'Annulla';

  @override
  String get subscription => 'ABBONAMENTO';

  @override
  String get goPremium => 'Passa a Premium';

  @override
  String get unlockAllFeatures => 'Sblocca tutte le funzionalità';

  @override
  String get restorePurchases => 'Ripristina acquisti';

  @override
  String get restorePurchasesDescription => 'Recupera un abbonamento esistente';

  @override
  String get restoringPurchases => 'Ripristino acquisti...';

  @override
  String get about => 'INFO';

  @override
  String get termsOfService => 'Termini di servizio';

  @override
  String get privacyPolicy => 'Informativa sulla privacy';

  @override
  String get contactUs => 'Contattaci';

  @override
  String version(String version) {
    return 'Versione $version';
  }

  @override
  String get premiumStatus => 'Premium';

  @override
  String get freeStatus => 'Gratuito';

  @override
  String get premiumDescription => 'Accesso illimitato a tutte le funzionalità';

  @override
  String get freeDescription => 'Funzionalità limitate';

  @override
  String get unlockRadar => 'Sblocca il Radar';

  @override
  String get locateAllDevices => 'Localizza tutti i tuoi dispositivi Bluetooth';

  @override
  String get unlimitedRadar => 'Radar illimitato';

  @override
  String get unlimitedRadarDescription =>
      'Localizza i tuoi dispositivi senza restrizioni';

  @override
  String get fullScan => 'Scansione completa';

  @override
  String get fullScanDescription => 'Vedi tutti i dispositivi nelle vicinanze';

  @override
  String get favorites => 'Preferiti';

  @override
  String get favoritesDescription => 'Salva i tuoi dispositivi importanti';

  @override
  String get oneTimePurchase => 'Acquisto unico';

  @override
  String get oneTimePurchaseDescription => 'Paga una volta, usa per sempre';

  @override
  String get oneTimePurchaseBadge => 'ACQUISTO UNICO';

  @override
  String get unlockNow => 'Sblocca ora';

  @override
  String get defaultPrice => '4,99 €';

  @override
  String get language => 'Lingua';

  @override
  String get languageDescription => 'Scegli la lingua dell\'app';

  @override
  String get systemLanguage => 'Lingua di sistema';

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
  String get bluetoothDisabled => 'Bluetooth disattivato';

  @override
  String get enableBluetoothDescription =>
      'Attiva il Bluetooth per scansionare i dispositivi nelle vicinanze';

  @override
  String get openSettings => 'APRI IMPOSTAZIONI';

  @override
  String get myDevices => 'I miei dispositivi';

  @override
  String get nearbyDevices => 'Nelle vicinanze';

  @override
  String get noDevicesFound => 'Nessun dispositivo trovato';

  @override
  String get purchaseError => 'Errore di acquisto';

  @override
  String get purchaseErrorDescription =>
      'Si è verificato un errore durante l\'acquisto. Per favore riprova.';

  @override
  String get purchaseCancelled => 'Acquisto annullato';

  @override
  String get networkError => 'Errore di rete';

  @override
  String get networkErrorDescription =>
      'Per favore controlla la tua connessione internet e riprova.';

  @override
  String get loadingError => 'Impossibile caricare le offerte';

  @override
  String get loadingErrorDescription =>
      'Per favore controlla la tua connessione e riprova.';

  @override
  String get ok => 'OK';
}
