// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'SONAR';

  @override
  String get appSubtitle => 'Encontre AirPods e Fones';

  @override
  String get scanner => 'SCANNER';

  @override
  String get settings => 'AJUSTES';

  @override
  String get noSavedDevices => 'Nenhum dispositivo salvo';

  @override
  String get noSavedDevicesDescription =>
      'Escaneie dispositivos Bluetooth próximos\ne adicione seus favoritos para encontrá-los facilmente';

  @override
  String get justNow => 'agora mesmo';

  @override
  String minutesAgo(int minutes) {
    return 'há $minutes min';
  }

  @override
  String hoursAgo(int hours) {
    return 'há ${hours}h';
  }

  @override
  String daysAgo(int days) {
    return 'há ${days}d';
  }

  @override
  String get permissionsRequired => 'Permissões necessárias';

  @override
  String get permissionsDescription =>
      'Para localizar seus dispositivos Bluetooth, precisamos de acesso ao Bluetooth e à sua localização.';

  @override
  String get bluetooth => 'Bluetooth';

  @override
  String get bluetoothPermissionDescription => 'Escanear dispositivos próximos';

  @override
  String get location => 'Localização';

  @override
  String get locationPermissionDescription =>
      'Necessário para escaneamento Bluetooth';

  @override
  String get authorize => 'Autorizar';

  @override
  String get scanError => 'Erro de escaneamento';

  @override
  String get checkBluetoothEnabled => 'Verifique se o Bluetooth está ativado';

  @override
  String get retry => 'TENTAR NOVAMENTE';

  @override
  String get trialUsed => 'Teste gratuito usado';

  @override
  String get trialAvailable => '1 teste de radar grátis disponível';

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
  String get searchingDevices => 'Procurando dispositivos Bluetooth...';

  @override
  String get scanInProgress => 'Escaneamento em andamento...';

  @override
  String get deviceNotFound => 'Dispositivo não encontrado';

  @override
  String get searchingForDevice => 'Procurando o dispositivo...';

  @override
  String get deviceNotInRange => 'Dispositivo fora de alcance';

  @override
  String get deviceNotInRangeDescription =>
      'O dispositivo não foi detectado. Certifique-se de que está ligado e próximo.';

  @override
  String get backToHome => 'Voltar';

  @override
  String get radarInstruction =>
      'Mova-se e siga a força do sinal para encontrar seu dispositivo';

  @override
  String get signalLost => 'Sinal perdido';

  @override
  String get found => 'Encontrado!';

  @override
  String get cancel => 'Cancelar';

  @override
  String get playSound => 'Tocar som';

  @override
  String get stopSound => 'Parar som';

  @override
  String get playSoundDescription =>
      'Toca um som no dispositivo se estiver conectado';

  @override
  String get soundPlaying => 'Tocando som...';

  @override
  String get deviceMustBeConnected =>
      'O dispositivo deve estar conectado (não apenas visível)';

  @override
  String get subscription => 'ASSINATURA';

  @override
  String get goPremium => 'Seja Premium';

  @override
  String get unlockAllFeatures => 'Desbloqueie todos os recursos';

  @override
  String get restorePurchases => 'Restaurar compras';

  @override
  String get restorePurchasesDescription =>
      'Recuperar uma assinatura existente';

  @override
  String get restoringPurchases => 'Restaurando...';

  @override
  String get about => 'SOBRE';

  @override
  String get termsOfService => 'Termos de Serviço';

  @override
  String get privacyPolicy => 'Política de Privacidade';

  @override
  String get contactUs => 'Fale conosco';

  @override
  String version(String version) {
    return 'Versão $version';
  }

  @override
  String get premiumStatus => 'Premium';

  @override
  String get freeStatus => 'Gratuito';

  @override
  String get premiumDescription => 'Acesso ilimitado a todos os recursos';

  @override
  String get freeDescription => 'Recursos limitados';

  @override
  String get unlockRadar => 'Desbloqueie o Radar';

  @override
  String get locateAllDevices =>
      'Localize todos os seus dispositivos Bluetooth';

  @override
  String get unlimitedRadar => 'Radar ilimitado';

  @override
  String get unlimitedRadarDescription =>
      'Localize seus dispositivos sem restrições';

  @override
  String get fullScan => 'Escaneamento completo';

  @override
  String get fullScanDescription => 'Veja todos os dispositivos próximos';

  @override
  String get favorites => 'Favoritos';

  @override
  String get favoritesDescription => 'Salve seus dispositivos importantes';

  @override
  String get oneTimePurchase => 'Compra única';

  @override
  String get oneTimePurchaseDescription => 'Pague uma vez, use para sempre';

  @override
  String get oneTimePurchaseBadge => 'COMPRA ÚNICA';

  @override
  String get unlockNow => 'Desbloquear agora';

  @override
  String get defaultPrice => 'R\$ 24,90';

  @override
  String get weekly => 'Semanal';

  @override
  String get monthly => 'Mensal';

  @override
  String get lifetimePlan => 'Vitalício';

  @override
  String get bestValue => 'MELHOR VALOR';

  @override
  String get perWeek => '/semana';

  @override
  String get perMonth => '/mês';

  @override
  String get weeklyPrice => 'R\$ 14,90';

  @override
  String get monthlyPrice => 'R\$ 29,90';

  @override
  String get lifetimePrice => 'R\$ 79,90';

  @override
  String get language => 'Idioma';

  @override
  String get languageDescription => 'Escolha o idioma do aplicativo';

  @override
  String get systemLanguage => 'Idioma do sistema';

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
  String get bluetoothDisabled => 'Bluetooth desativado';

  @override
  String get enableBluetoothDescription =>
      'Ative o Bluetooth para escanear dispositivos próximos';

  @override
  String get openSettings => 'ABRIR AJUSTES';

  @override
  String get myDevices => 'Meus dispositivos';

  @override
  String get nearbyDevices => 'Próximos';

  @override
  String get noDevicesFound => 'Nenhum dispositivo encontrado';

  @override
  String get purchaseError => 'Erro na compra';

  @override
  String get purchaseErrorDescription =>
      'Ocorreu um erro durante a compra. Por favor, tente novamente.';

  @override
  String get purchaseCancelled => 'Compra cancelada';

  @override
  String get networkError => 'Erro de rede';

  @override
  String get networkErrorDescription =>
      'Verifique sua conexão com a internet e tente novamente.';

  @override
  String get loadingError => 'Não foi possível carregar as ofertas';

  @override
  String get loadingErrorDescription =>
      'Verifique sua conexão e tente novamente.';

  @override
  String get ok => 'OK';

  @override
  String get showUnnamedDevices => 'Mostrar dispositivos sem nome';

  @override
  String get whyDeviceNotVisible => 'Por que não vejo meu dispositivo?';

  @override
  String get deviceVisibleConditions => 'Para que um dispositivo seja visível:';

  @override
  String get deviceMustBeOn => 'O dispositivo deve estar ligado';

  @override
  String get bluetoothMustBeEnabledOnDevice =>
      'O Bluetooth deve estar ativado no dispositivo';

  @override
  String get deviceMustBeInRange =>
      'O dispositivo deve estar ao alcance (< 10 metros)';

  @override
  String get someDevicesDontBroadcastName =>
      'Alguns dispositivos não transmitem seu nome';

  @override
  String get tipShowUnnamedDevices =>
      'Dica: Ative \"Mostrar dispositivos sem nome\" para ver todos os dispositivos Bluetooth próximos.';

  @override
  String get understood => 'Entendi';

  @override
  String get pleaseEnableBluetoothSettings =>
      'Por favor, ative o Bluetooth nas configurações do seu dispositivo.';

  @override
  String get onboardingSkip => 'Pular';

  @override
  String get onboardingNext => 'Próximo';

  @override
  String get onboardingStart => 'Começar';

  @override
  String get onboardingTitle1 => 'Encontre seus dispositivos perdidos';

  @override
  String get onboardingDesc1 =>
      'Nosso radar de precisão guia você até seus fones, AirPods e dispositivos Bluetooth perdidos.';

  @override
  String get onboardingTitle2 => 'Salve seus favoritos';

  @override
  String get onboardingDesc2 =>
      'Adicione seus dispositivos importantes aos favoritos para encontrá-los instantaneamente.';

  @override
  String get onboardingTitle3 => 'Algumas permissões necessárias';

  @override
  String get onboardingDesc3 =>
      'Para escanear dispositivos Bluetooth e ajudá-lo a localizá-los, precisamos da sua permissão.';

  @override
  String get lastSeenLocation => 'Última localização conhecida';

  @override
  String get noLocationHistory => 'Nenhuma localização registrada';

  @override
  String get noLocationHistoryDescription =>
      'A localização será registrada quando você encontrar este dispositivo.';

  @override
  String get showOnMap => 'Ver no mapa';

  @override
  String get gpsAccuracyNotice =>
      'Área aproximada (~100m). Use o radar para localização precisa.';

  @override
  String get openRadar => 'Abrir Radar';

  @override
  String get unknownDevice => 'Dispositivo desconhecido';

  @override
  String get featureUnlimitedRadar => 'Localização por radar ilimitada';

  @override
  String get featureFindAllDevices => 'Encontre todos os seus dispositivos';

  @override
  String get featureAudioAlerts => 'Alertas sonoros de proximidade';

  @override
  String get featureNoAds => 'Sem anúncios';

  @override
  String get featureLifetimeUpdates => 'Atualizações vitalícias';

  @override
  String get free => 'GRÁTIS';

  @override
  String get tapDeviceToLocate => 'Toque em um dispositivo para localizá-lo';

  @override
  String get signal => 'SINAL';
}
