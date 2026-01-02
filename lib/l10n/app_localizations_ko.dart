// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appName => 'SONAR';

  @override
  String get appSubtitle => 'AirPods & 이어폰 찾기';

  @override
  String get scanner => '스캔';

  @override
  String get settings => '설정';

  @override
  String get noSavedDevices => '저장된 기기가 없습니다';

  @override
  String get noSavedDevicesDescription => '주변의 Bluetooth 기기를 스캔하고\n즐겨찾기에 추가하세요';

  @override
  String get justNow => '방금';

  @override
  String minutesAgo(int minutes) {
    return '$minutes분 전';
  }

  @override
  String hoursAgo(int hours) {
    return '$hours시간 전';
  }

  @override
  String daysAgo(int days) {
    return '$days일 전';
  }

  @override
  String get permissionsRequired => '권한이 필요합니다';

  @override
  String get permissionsDescription =>
      'Bluetooth 기기를 찾으려면 Bluetooth와 위치 정보에 대한 접근이 필요합니다.';

  @override
  String get bluetooth => 'Bluetooth';

  @override
  String get bluetoothPermissionDescription => '주변 기기 스캔';

  @override
  String get location => '위치';

  @override
  String get locationPermissionDescription => 'Bluetooth 스캔에 필요';

  @override
  String get authorize => '허용';

  @override
  String get scanError => '스캔 오류';

  @override
  String get checkBluetoothEnabled => 'Bluetooth가 켜져 있는지 확인하세요';

  @override
  String get retry => '다시 시도';

  @override
  String get trialUsed => '무료 체험 사용 완료';

  @override
  String get trialAvailable => '레이더 무료 체험 1회 가능';

  @override
  String get unlock => '잠금 해제';

  @override
  String devicesFound(int count) {
    return '$count개의 기기를 찾았습니다';
  }

  @override
  String get premium => '프리미엄';

  @override
  String get scanning => '스캔 중';

  @override
  String get searchingDevices => 'Bluetooth 기기 검색 중...';

  @override
  String get scanInProgress => '스캔 중...';

  @override
  String get deviceNotFound => '기기를 찾을 수 없습니다';

  @override
  String get searchingForDevice => '기기 검색 중...';

  @override
  String get deviceNotInRange => '기기가 범위 밖에 있습니다';

  @override
  String get deviceNotInRangeDescription =>
      '기기가 감지되지 않습니다. 전원이 켜져 있고 가까이 있는지 확인하세요.';

  @override
  String get backToHome => '돌아가기';

  @override
  String get radarInstruction => '이동하면서 신호 강도를 따라 기기를 찾으세요';

  @override
  String get signalLost => '신호 끊김';

  @override
  String get found => '찾았습니다!';

  @override
  String get cancel => '취소';

  @override
  String get playSound => '소리 재생';

  @override
  String get stopSound => '소리 중지';

  @override
  String get playSoundDescription => '연결된 기기에서 소리를 재생합니다';

  @override
  String get soundPlaying => '재생 중...';

  @override
  String get deviceMustBeConnected => '기기가 연결되어 있어야 합니다 (보이기만 하는 것이 아님)';

  @override
  String get subscription => '구독';

  @override
  String get goPremium => '프리미엄으로 업그레이드';

  @override
  String get unlockAllFeatures => '모든 기능 잠금 해제';

  @override
  String get restorePurchases => '구매 복원';

  @override
  String get restorePurchasesDescription => '기존 구독 복원';

  @override
  String get restoringPurchases => '복원 중...';

  @override
  String get about => '앱 정보';

  @override
  String get termsOfService => '이용약관';

  @override
  String get privacyPolicy => '개인정보처리방침';

  @override
  String get contactUs => '문의하기';

  @override
  String version(String version) {
    return '버전 $version';
  }

  @override
  String get premiumStatus => '프리미엄';

  @override
  String get freeStatus => '무료';

  @override
  String get premiumDescription => '모든 기능 무제한 이용';

  @override
  String get freeDescription => '기능 제한';

  @override
  String get unlockRadar => '레이더 잠금 해제';

  @override
  String get locateAllDevices => '모든 Bluetooth 기기 찾기';

  @override
  String get unlimitedRadar => '무제한 레이더';

  @override
  String get unlimitedRadarDescription => '제한 없이 기기 탐색';

  @override
  String get fullScan => '전체 스캔';

  @override
  String get fullScanDescription => '주변의 모든 기기 보기';

  @override
  String get favorites => '즐겨찾기';

  @override
  String get favoritesDescription => '중요한 기기 저장';

  @override
  String get oneTimePurchase => '일회성 구매';

  @override
  String get oneTimePurchaseDescription => '한 번 결제로 영구 사용';

  @override
  String get oneTimePurchaseBadge => '일회성 구매';

  @override
  String get unlockNow => '지금 잠금 해제';

  @override
  String get defaultPrice => '₩6,500';

  @override
  String get weekly => '주간';

  @override
  String get monthly => '월간';

  @override
  String get lifetimePlan => '평생';

  @override
  String get bestValue => '최고의 가치';

  @override
  String get perWeek => '/주';

  @override
  String get perMonth => '/월';

  @override
  String get weeklyPrice => '₩3,900';

  @override
  String get monthlyPrice => '₩7,900';

  @override
  String get lifetimePrice => '₩19,900';

  @override
  String get language => '언어';

  @override
  String get languageDescription => '앱 언어 선택';

  @override
  String get systemLanguage => '시스템 언어';

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
  String get bluetoothDisabled => 'Bluetooth가 비활성화됨';

  @override
  String get enableBluetoothDescription => '기기를 스캔하려면 Bluetooth를 켜세요';

  @override
  String get openSettings => '설정 열기';

  @override
  String get myDevices => '내 기기';

  @override
  String get nearbyDevices => '주변 기기';

  @override
  String get noDevicesFound => '기기를 찾을 수 없습니다';

  @override
  String get purchaseError => '구매 오류';

  @override
  String get purchaseErrorDescription => '구매 중 오류가 발생했습니다. 다시 시도해 주세요.';

  @override
  String get purchaseCancelled => '구매 취소됨';

  @override
  String get networkError => '네트워크 오류';

  @override
  String get networkErrorDescription => '인터넷 연결을 확인하고 다시 시도해 주세요.';

  @override
  String get loadingError => '상품을 불러올 수 없습니다';

  @override
  String get loadingErrorDescription => '연결을 확인하고 다시 시도해 주세요.';

  @override
  String get ok => '확인';

  @override
  String get showUnnamedDevices => '이름 없는 기기 표시';

  @override
  String get whyDeviceNotVisible => '기기가 보이지 않나요?';

  @override
  String get deviceVisibleConditions => '기기가 보이려면:';

  @override
  String get deviceMustBeOn => '기기 전원이 켜져 있어야 함';

  @override
  String get bluetoothMustBeEnabledOnDevice => '기기의 Bluetooth가 켜져 있어야 함';

  @override
  String get deviceMustBeInRange => '기기가 범위 내에 있어야 함 (10미터 이내)';

  @override
  String get someDevicesDontBroadcastName => '일부 기기는 이름을 전송하지 않습니다';

  @override
  String get tipShowUnnamedDevices =>
      '팁: \"이름 없는 기기 표시\"를 켜면 모든 Bluetooth 기기를 볼 수 있습니다.';

  @override
  String get understood => '확인';

  @override
  String get pleaseEnableBluetoothSettings => '기기 설정에서 Bluetooth를 켜세요.';

  @override
  String get onboardingSkip => '건너뛰기';

  @override
  String get onboardingNext => '다음';

  @override
  String get onboardingStart => '시작';

  @override
  String get onboardingTitle1 => '잃어버린 기기 찾기';

  @override
  String get onboardingDesc1 =>
      '정밀 레이더로 이어폰, AirPods, Bluetooth 기기의 위치를 찾아드립니다.';

  @override
  String get onboardingTitle2 => '즐겨찾기에 저장';

  @override
  String get onboardingDesc2 => '중요한 기기를 즐겨찾기에 추가하여 언제든 빠르게 찾으세요.';

  @override
  String get onboardingTitle3 => '몇 가지 권한이 필요합니다';

  @override
  String get onboardingDesc3 => 'Bluetooth 기기를 스캔하고 찾으려면 권한이 필요합니다.';

  @override
  String get lastSeenLocation => '마지막으로 감지된 위치';

  @override
  String get noLocationHistory => '위치 기록 없음';

  @override
  String get noLocationHistoryDescription => '기기를 찾으면 위치가 기록됩니다.';

  @override
  String get showOnMap => '지도에서 보기';

  @override
  String get gpsAccuracyNotice => '대략적인 범위 (~100m). 정확한 위치는 레이더를 사용하세요.';

  @override
  String get openRadar => '레이더 열기';

  @override
  String get unknownDevice => '알 수 없는 기기';

  @override
  String get featureUnlimitedRadar => '무제한 레이더 탐색';

  @override
  String get featureFindAllDevices => '모든 기기 찾기';

  @override
  String get featureAudioAlerts => '근접 시 오디오 알림';

  @override
  String get featureNoAds => '광고 없음';

  @override
  String get featureLifetimeUpdates => '평생 업데이트';

  @override
  String get free => '무료';

  @override
  String get tapDeviceToLocate => '기기를 탭하여 찾기';

  @override
  String get signal => '신호';
}
