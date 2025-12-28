// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'SONAR';

  @override
  String get appSubtitle => 'Bluetooth Finder';

  @override
  String get scanner => 'ESCÁNER';

  @override
  String get settings => 'AJUSTES';

  @override
  String get noSavedDevices => 'Sin dispositivos guardados';

  @override
  String get noSavedDevicesDescription =>
      'Escanea dispositivos Bluetooth cercanos\ny añade tus favoritos para encontrarlos fácilmente';

  @override
  String get justNow => 'ahora mismo';

  @override
  String minutesAgo(int minutes) {
    return 'hace $minutes min';
  }

  @override
  String hoursAgo(int hours) {
    return 'hace ${hours}h';
  }

  @override
  String daysAgo(int days) {
    return 'hace ${days}d';
  }

  @override
  String get permissionsRequired => 'Permisos requeridos';

  @override
  String get permissionsDescription =>
      'Para localizar tus dispositivos Bluetooth, necesitamos acceso al Bluetooth y tu ubicación.';

  @override
  String get bluetooth => 'Bluetooth';

  @override
  String get bluetoothPermissionDescription => 'Escanear dispositivos cercanos';

  @override
  String get location => 'Ubicación';

  @override
  String get locationPermissionDescription =>
      'Requerido para el escaneo Bluetooth';

  @override
  String get authorize => 'Autorizar';

  @override
  String get scanError => 'Error de escaneo';

  @override
  String get checkBluetoothEnabled => 'Verifica que el Bluetooth esté activado';

  @override
  String get retry => 'REINTENTAR';

  @override
  String get trialUsed => 'Prueba gratuita usada';

  @override
  String get trialAvailable => '1 prueba de radar gratis disponible';

  @override
  String get unlock => 'DESBLOQUEAR';

  @override
  String devicesFound(int count) {
    return '$count dispositivos encontrados';
  }

  @override
  String get premium => 'PREMIUM';

  @override
  String get scanning => 'ESCANEANDO';

  @override
  String get searchingDevices => 'Buscando dispositivos Bluetooth...';

  @override
  String get scanInProgress => 'Escaneo en progreso...';

  @override
  String get deviceNotFound => 'Dispositivo no encontrado';

  @override
  String get radarInstruction =>
      'Muévete y sigue la intensidad de la señal para encontrar tu dispositivo';

  @override
  String get signalLost => 'Señal perdida';

  @override
  String get found => '¡Encontrado!';

  @override
  String get cancel => 'Cancelar';

  @override
  String get subscription => 'SUSCRIPCIÓN';

  @override
  String get goPremium => 'Pasar a Premium';

  @override
  String get unlockAllFeatures => 'Desbloquea todas las funciones';

  @override
  String get restorePurchases => 'Restaurar compras';

  @override
  String get restorePurchasesDescription =>
      'Recuperar una suscripción existente';

  @override
  String get restoringPurchases => 'Restaurando compras...';

  @override
  String get about => 'ACERCA DE';

  @override
  String get termsOfService => 'Términos de servicio';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get contactUs => 'Contáctanos';

  @override
  String version(String version) {
    return 'Versión $version';
  }

  @override
  String get premiumStatus => 'Premium';

  @override
  String get freeStatus => 'Gratis';

  @override
  String get premiumDescription => 'Acceso ilimitado a todas las funciones';

  @override
  String get freeDescription => 'Funciones limitadas';

  @override
  String get unlockRadar => 'Desbloquea el Radar';

  @override
  String get locateAllDevices => 'Localiza todos tus dispositivos Bluetooth';

  @override
  String get unlimitedRadar => 'Radar ilimitado';

  @override
  String get unlimitedRadarDescription =>
      'Localiza tus dispositivos sin restricciones';

  @override
  String get fullScan => 'Escaneo completo';

  @override
  String get fullScanDescription => 'Ve todos los dispositivos cercanos';

  @override
  String get favorites => 'Favoritos';

  @override
  String get favoritesDescription => 'Guarda tus dispositivos importantes';

  @override
  String get oneTimePurchase => 'Compra única';

  @override
  String get oneTimePurchaseDescription => 'Paga una vez, usa para siempre';

  @override
  String get oneTimePurchaseBadge => 'COMPRA ÚNICA';

  @override
  String get unlockNow => 'Desbloquear ahora';

  @override
  String get defaultPrice => '4,99 €';

  @override
  String get language => 'Idioma';

  @override
  String get languageDescription => 'Elegir idioma de la aplicación';

  @override
  String get systemLanguage => 'Idioma del sistema';

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
  String get bluetoothDisabled => 'Bluetooth desactivado';

  @override
  String get enableBluetoothDescription =>
      'Activa el Bluetooth para escanear dispositivos cercanos';

  @override
  String get openSettings => 'ABRIR AJUSTES';

  @override
  String get myDevices => 'Mis dispositivos';

  @override
  String get nearbyDevices => 'Cercanos';

  @override
  String get noDevicesFound => 'No se encontraron dispositivos';
}
