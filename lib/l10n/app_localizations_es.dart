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
  String get appSubtitle => 'Find AirPods & Headphones';

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
  String get searchingForDevice => 'Buscando dispositivo...';

  @override
  String get deviceNotInRange => 'Dispositivo fuera de alcance';

  @override
  String get deviceNotInRangeDescription =>
      'El dispositivo no fue detectado. Asegúrate de que esté encendido y cerca.';

  @override
  String get backToHome => 'Volver';

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
  String get playSound => 'Reproducir sonido';

  @override
  String get stopSound => 'Detener sonido';

  @override
  String get playSoundDescription =>
      'Reproduce un sonido en el dispositivo si está conectado';

  @override
  String get soundPlaying => 'Reproduciendo sonido...';

  @override
  String get deviceMustBeConnected =>
      'El dispositivo debe estar conectado (no solo visible)';

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
  String get weekly => 'Semanal';

  @override
  String get monthly => 'Mensual';

  @override
  String get lifetimePlan => 'De por vida';

  @override
  String get bestValue => 'MEJOR VALOR';

  @override
  String get perWeek => '/semana';

  @override
  String get perMonth => '/mes';

  @override
  String get weeklyPrice => '2,99 €';

  @override
  String get monthlyPrice => '5,99 €';

  @override
  String get lifetimePrice => '14,99 €';

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

  @override
  String get purchaseError => 'Error de compra';

  @override
  String get purchaseErrorDescription =>
      'Se produjo un error durante la compra. Por favor, inténtalo de nuevo.';

  @override
  String get purchaseCancelled => 'Compra cancelada';

  @override
  String get networkError => 'Error de red';

  @override
  String get networkErrorDescription =>
      'Por favor, verifica tu conexión a internet e inténtalo de nuevo.';

  @override
  String get loadingError => 'No se pueden cargar las ofertas';

  @override
  String get loadingErrorDescription =>
      'Por favor, verifica tu conexión e inténtalo de nuevo.';

  @override
  String get ok => 'OK';

  @override
  String get showUnnamedDevices => 'Mostrar dispositivos sin nombre';

  @override
  String get whyDeviceNotVisible => '¿Por qué no veo mi dispositivo?';

  @override
  String get deviceVisibleConditions => 'Para que un dispositivo sea visible:';

  @override
  String get deviceMustBeOn => 'El dispositivo debe estar encendido';

  @override
  String get bluetoothMustBeEnabledOnDevice =>
      'El Bluetooth debe estar activado en el dispositivo';

  @override
  String get deviceMustBeInRange =>
      'El dispositivo debe estar dentro del alcance (< 10 metros)';

  @override
  String get someDevicesDontBroadcastName =>
      'Algunos dispositivos no emiten su nombre';

  @override
  String get tipShowUnnamedDevices =>
      'Consejo: Activa \"Mostrar dispositivos sin nombre\" para ver todos los dispositivos Bluetooth cercanos.';

  @override
  String get understood => 'Entendido';

  @override
  String get pleaseEnableBluetoothSettings =>
      'Por favor, activa el Bluetooth en los ajustes de tu dispositivo.';

  @override
  String get onboardingSkip => 'Omitir';

  @override
  String get onboardingNext => 'Siguiente';

  @override
  String get onboardingStart => 'Empezar';

  @override
  String get onboardingTitle1 => 'Encuentra tus dispositivos perdidos';

  @override
  String get onboardingDesc1 =>
      'Nuestro radar de precisión te guía hacia tus auriculares, AirPods y dispositivos Bluetooth perdidos.';

  @override
  String get onboardingTitle2 => 'Guarda tus favoritos';

  @override
  String get onboardingDesc2 =>
      'Añade tus dispositivos importantes a favoritos para encontrarlos al instante cada vez que uses la app.';

  @override
  String get onboardingTitle3 => 'Se necesitan algunos permisos';

  @override
  String get onboardingDesc3 =>
      'Para escanear dispositivos Bluetooth y ayudarte a localizarlos, necesitamos tu permiso.';

  @override
  String get lastSeenLocation => 'Última ubicación conocida';

  @override
  String get noLocationHistory => 'Sin ubicación registrada';

  @override
  String get noLocationHistoryDescription =>
      'La ubicación se guardará cuando encuentres este dispositivo.';

  @override
  String get showOnMap => 'Ver en el mapa';

  @override
  String get gpsAccuracyNotice =>
      'Área general (~100m). Usa el radar para localizar con precisión.';

  @override
  String get openRadar => 'Abrir Radar';

  @override
  String get unknownDevice => 'Dispositivo desconocido';

  @override
  String get featureUnlimitedRadar => 'Rastreo radar ilimitado';

  @override
  String get featureFindAllDevices => 'Encuentra todos tus dispositivos';

  @override
  String get featureAudioAlerts => 'Alertas de proximidad por audio';

  @override
  String get featureNoAds => 'Sin anuncios';

  @override
  String get featureLifetimeUpdates => 'Actualizaciones de por vida';

  @override
  String get free => 'GRATIS';

  @override
  String get tapDeviceToLocate => 'Toca un dispositivo para localizarlo';

  @override
  String get signal => 'SEÑAL';
}
