// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appName => 'SONAR';

  @override
  String get appSubtitle => 'AirPods ve Kulaklıkları Bul';

  @override
  String get scanner => 'TARAMA';

  @override
  String get settings => 'AYARLAR';

  @override
  String get noSavedDevices => 'Kayıtlı cihaz yok';

  @override
  String get noSavedDevicesDescription =>
      'Yakındaki Bluetooth cihazlarını tarayın\nve favorilerinize ekleyin';

  @override
  String get justNow => 'şimdi';

  @override
  String minutesAgo(int minutes) {
    return '$minutes dk önce';
  }

  @override
  String hoursAgo(int hours) {
    return '$hours sa önce';
  }

  @override
  String daysAgo(int days) {
    return '$days gün önce';
  }

  @override
  String get permissionsRequired => 'İzinler gerekli';

  @override
  String get permissionsDescription =>
      'Bluetooth cihazlarınızı bulmak için Bluetooth ve konum erişimine ihtiyacımız var.';

  @override
  String get bluetooth => 'Bluetooth';

  @override
  String get bluetoothPermissionDescription => 'Yakındaki cihazları tara';

  @override
  String get location => 'Konum';

  @override
  String get locationPermissionDescription => 'Bluetooth taraması için gerekli';

  @override
  String get authorize => 'İzin Ver';

  @override
  String get scanError => 'Tarama hatası';

  @override
  String get checkBluetoothEnabled => 'Bluetooth\'un açık olduğundan emin olun';

  @override
  String get retry => 'TEKRAR DENE';

  @override
  String get trialUsed => 'Ücretsiz deneme kullanıldı';

  @override
  String get trialAvailable => '1 ücretsiz radar denemesi mevcut';

  @override
  String get unlock => 'KİLİDİ AÇ';

  @override
  String devicesFound(int count) {
    return '$count cihaz bulundu';
  }

  @override
  String get premium => 'PREMİUM';

  @override
  String get scanning => 'TARANIYOR';

  @override
  String get searchingDevices => 'Bluetooth cihazları aranıyor...';

  @override
  String get scanInProgress => 'Tarama devam ediyor...';

  @override
  String get deviceNotFound => 'Cihaz bulunamadı';

  @override
  String get searchingForDevice => 'Cihaz aranıyor...';

  @override
  String get deviceNotInRange => 'Cihaz menzil dışında';

  @override
  String get deviceNotInRangeDescription =>
      'Cihaz algılanamıyor. Açık ve yakında olduğundan emin olun.';

  @override
  String get backToHome => 'Geri';

  @override
  String get radarInstruction =>
      'Hareket edin ve cihazınızı bulmak için sinyal gücünü takip edin';

  @override
  String get signalLost => 'Sinyal kayboldu';

  @override
  String get found => 'Bulundu!';

  @override
  String get cancel => 'İptal';

  @override
  String get playSound => 'Ses çal';

  @override
  String get stopSound => 'Sesi durdur';

  @override
  String get playSoundDescription => 'Bağlıysa cihazda ses çalar';

  @override
  String get soundPlaying => 'Ses çalıyor...';

  @override
  String get deviceMustBeConnected =>
      'Cihaz bağlı olmalıdır (sadece görünür değil)';

  @override
  String get subscription => 'ABONELİK';

  @override
  String get goPremium => 'Premium\'a Geç';

  @override
  String get unlockAllFeatures => 'Tüm özelliklerin kilidini aç';

  @override
  String get restorePurchases => 'Satın alımları geri yükle';

  @override
  String get restorePurchasesDescription => 'Mevcut aboneliği kurtar';

  @override
  String get restoringPurchases => 'Geri yükleniyor...';

  @override
  String get about => 'HAKKINDA';

  @override
  String get termsOfService => 'Kullanım Şartları';

  @override
  String get privacyPolicy => 'Gizlilik Politikası';

  @override
  String get contactUs => 'Bize Ulaşın';

  @override
  String version(String version) {
    return 'Sürüm $version';
  }

  @override
  String get premiumStatus => 'Premium';

  @override
  String get freeStatus => 'Ücretsiz';

  @override
  String get premiumDescription => 'Tüm özelliklere sınırsız erişim';

  @override
  String get freeDescription => 'Sınırlı özellikler';

  @override
  String get unlockRadar => 'Radar\'ın Kilidini Aç';

  @override
  String get locateAllDevices => 'Tüm Bluetooth cihazlarınızı bulun';

  @override
  String get unlimitedRadar => 'Sınırsız radar';

  @override
  String get unlimitedRadarDescription => 'Cihazlarınızı sınırsız bulun';

  @override
  String get fullScan => 'Tam tarama';

  @override
  String get fullScanDescription => 'Yakındaki tüm cihazları görün';

  @override
  String get favorites => 'Favoriler';

  @override
  String get favoritesDescription => 'Önemli cihazlarınızı kaydedin';

  @override
  String get oneTimePurchase => 'Tek seferlik satın alma';

  @override
  String get oneTimePurchaseDescription => 'Bir kez öde, sonsuza kadar kullan';

  @override
  String get oneTimePurchaseBadge => 'TEK SEFERLİK';

  @override
  String get unlockNow => 'Şimdi kilidi aç';

  @override
  String get defaultPrice => '149,99 ₺';

  @override
  String get weekly => 'Haftalık';

  @override
  String get monthly => 'Aylık';

  @override
  String get lifetimePlan => 'Ömür boyu';

  @override
  String get bestValue => 'EN İYİ DEĞER';

  @override
  String get perWeek => '/hafta';

  @override
  String get perMonth => '/ay';

  @override
  String get weeklyPrice => '79,99 ₺';

  @override
  String get monthlyPrice => '179,99 ₺';

  @override
  String get lifetimePrice => '449,99 ₺';

  @override
  String get language => 'Dil';

  @override
  String get languageDescription => 'Uygulama dilini seçin';

  @override
  String get systemLanguage => 'Sistem dili';

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
  String get bluetoothDisabled => 'Bluetooth kapalı';

  @override
  String get enableBluetoothDescription =>
      'Cihazları taramak için Bluetooth\'u açın';

  @override
  String get openSettings => 'AYARLARI AÇ';

  @override
  String get myDevices => 'Cihazlarım';

  @override
  String get nearbyDevices => 'Yakında';

  @override
  String get noDevicesFound => 'Cihaz bulunamadı';

  @override
  String get purchaseError => 'Satın alma hatası';

  @override
  String get purchaseErrorDescription =>
      'Satın alma sırasında bir hata oluştu. Lütfen tekrar deneyin.';

  @override
  String get purchaseCancelled => 'Satın alma iptal edildi';

  @override
  String get networkError => 'Ağ hatası';

  @override
  String get networkErrorDescription =>
      'İnternet bağlantınızı kontrol edin ve tekrar deneyin.';

  @override
  String get loadingError => 'Teklifler yüklenemedi';

  @override
  String get loadingErrorDescription =>
      'Bağlantınızı kontrol edin ve tekrar deneyin.';

  @override
  String get ok => 'Tamam';

  @override
  String get showUnnamedDevices => 'İsimsiz cihazları göster';

  @override
  String get whyDeviceNotVisible => 'Cihazımı neden göremiyorum?';

  @override
  String get deviceVisibleConditions => 'Bir cihazın görünür olması için:';

  @override
  String get deviceMustBeOn => 'Cihaz açık olmalı';

  @override
  String get bluetoothMustBeEnabledOnDevice => 'Cihazda Bluetooth açık olmalı';

  @override
  String get deviceMustBeInRange => 'Cihaz menzilde olmalı (< 10 metre)';

  @override
  String get someDevicesDontBroadcastName =>
      'Bazı cihazlar adlarını yayınlamaz';

  @override
  String get tipShowUnnamedDevices =>
      'İpucu: Tüm Bluetooth cihazlarını görmek için \"İsimsiz cihazları göster\"i açın.';

  @override
  String get understood => 'Anladım';

  @override
  String get pleaseEnableBluetoothSettings =>
      'Lütfen cihaz ayarlarından Bluetooth\'u açın.';

  @override
  String get onboardingSkip => 'Atla';

  @override
  String get onboardingNext => 'İleri';

  @override
  String get onboardingStart => 'Başla';

  @override
  String get onboardingTitle1 => 'Kayıp cihazlarınızı bulun';

  @override
  String get onboardingDesc1 =>
      'Hassas radarımız sizi kulaklıklarınıza, AirPods\'larınıza ve kayıp Bluetooth cihazlarınıza yönlendirir.';

  @override
  String get onboardingTitle2 => 'Favorilerinizi kaydedin';

  @override
  String get onboardingDesc2 =>
      'Önemli cihazlarınızı favorilere ekleyerek anında bulun.';

  @override
  String get onboardingTitle3 => 'Birkaç izin gerekli';

  @override
  String get onboardingDesc3 =>
      'Bluetooth cihazlarını taramak ve bulmak için izninize ihtiyacımız var.';

  @override
  String get lastSeenLocation => 'Son bilinen konum';

  @override
  String get noLocationHistory => 'Konum geçmişi yok';

  @override
  String get noLocationHistoryDescription =>
      'Bu cihazı bulduğunuzda konum kaydedilecektir.';

  @override
  String get showOnMap => 'Haritada göster';

  @override
  String get gpsAccuracyNotice =>
      'Genel alan (~100m). Kesin konum için radarı kullanın.';

  @override
  String get openRadar => 'Radarı Aç';

  @override
  String get unknownDevice => 'Bilinmeyen cihaz';

  @override
  String get featureUnlimitedRadar => 'Sınırsız radar konumlandırma';

  @override
  String get featureFindAllDevices => 'Tüm cihazlarınızı bulun';

  @override
  String get featureAudioAlerts => 'Yaklaşma sesli uyarıları';

  @override
  String get featureNoAds => 'Reklamsız';

  @override
  String get featureLifetimeUpdates => 'Ömür boyu güncellemeler';

  @override
  String get free => 'ÜCRETSİZ';

  @override
  String get tapDeviceToLocate => 'Bulmak için bir cihaza dokunun';

  @override
  String get signal => 'SİNYAL';
}
