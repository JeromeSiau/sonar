// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appName => 'SONAR';

  @override
  String get appSubtitle => 'AirPods・イヤホンを探す';

  @override
  String get scanner => 'スキャン';

  @override
  String get settings => '設定';

  @override
  String get noSavedDevices => '保存済みデバイスがありません';

  @override
  String get noSavedDevicesDescription =>
      '近くのBluetoothデバイスをスキャンして\nお気に入りに追加しましょう';

  @override
  String get justNow => 'たった今';

  @override
  String minutesAgo(int minutes) {
    return '$minutes分前';
  }

  @override
  String hoursAgo(int hours) {
    return '$hours時間前';
  }

  @override
  String daysAgo(int days) {
    return '$days日前';
  }

  @override
  String get permissionsRequired => '許可が必要です';

  @override
  String get permissionsDescription =>
      'Bluetoothデバイスを探すには、Bluetoothと位置情報へのアクセスが必要です。';

  @override
  String get bluetooth => 'Bluetooth';

  @override
  String get bluetoothPermissionDescription => '近くのデバイスをスキャン';

  @override
  String get location => '位置情報';

  @override
  String get locationPermissionDescription => 'Bluetoothスキャンに必要';

  @override
  String get authorize => '許可する';

  @override
  String get scanError => 'スキャンエラー';

  @override
  String get checkBluetoothEnabled => 'Bluetoothが有効か確認してください';

  @override
  String get retry => '再試行';

  @override
  String get trialUsed => '無料トライアル使用済み';

  @override
  String get trialAvailable => 'レーダー無料トライアル1回利用可能';

  @override
  String get unlock => '解除';

  @override
  String devicesFound(int count) {
    return '$count台のデバイスが見つかりました';
  }

  @override
  String get premium => 'プレミアム';

  @override
  String get scanning => 'スキャン中';

  @override
  String get searchingDevices => 'Bluetoothデバイスを検索中...';

  @override
  String get scanInProgress => 'スキャン中...';

  @override
  String get deviceNotFound => 'デバイスが見つかりません';

  @override
  String get searchingForDevice => 'デバイスを検索中...';

  @override
  String get deviceNotInRange => 'デバイスが範囲外です';

  @override
  String get deviceNotInRangeDescription =>
      'デバイスが検出されません。電源が入っていて近くにあることを確認してください。';

  @override
  String get backToHome => '戻る';

  @override
  String get radarInstruction => '移動しながら信号強度を追って、デバイスを見つけましょう';

  @override
  String get signalLost => '信号が途切れました';

  @override
  String get found => '見つかりました！';

  @override
  String get cancel => 'キャンセル';

  @override
  String get playSound => '音を鳴らす';

  @override
  String get stopSound => '音を停止';

  @override
  String get playSoundDescription => '接続中のデバイスで音を鳴らします';

  @override
  String get soundPlaying => '再生中...';

  @override
  String get deviceMustBeConnected => 'デバイスが接続されている必要があります（表示されているだけでは不可）';

  @override
  String get subscription => 'サブスクリプション';

  @override
  String get goPremium => 'プレミアムにアップグレード';

  @override
  String get unlockAllFeatures => 'すべての機能を解除';

  @override
  String get restorePurchases => '購入を復元';

  @override
  String get restorePurchasesDescription => '既存のサブスクリプションを復元';

  @override
  String get restoringPurchases => '復元中...';

  @override
  String get about => 'アプリについて';

  @override
  String get termsOfService => '利用規約';

  @override
  String get privacyPolicy => 'プライバシーポリシー';

  @override
  String get contactUs => 'お問い合わせ';

  @override
  String version(String version) {
    return 'バージョン $version';
  }

  @override
  String get premiumStatus => 'プレミアム';

  @override
  String get freeStatus => '無料';

  @override
  String get premiumDescription => 'すべての機能に無制限アクセス';

  @override
  String get freeDescription => '機能制限あり';

  @override
  String get unlockRadar => 'レーダーを解除';

  @override
  String get locateAllDevices => 'すべてのBluetoothデバイスを探す';

  @override
  String get unlimitedRadar => '無制限レーダー';

  @override
  String get unlimitedRadarDescription => '制限なくデバイスを探索';

  @override
  String get fullScan => 'フルスキャン';

  @override
  String get fullScanDescription => '近くのすべてのデバイスを表示';

  @override
  String get favorites => 'お気に入り';

  @override
  String get favoritesDescription => '大切なデバイスを保存';

  @override
  String get oneTimePurchase => '買い切り';

  @override
  String get oneTimePurchaseDescription => '一度のお支払いで永久に使用可能';

  @override
  String get oneTimePurchaseBadge => '買い切り';

  @override
  String get unlockNow => '今すぐ解除';

  @override
  String get defaultPrice => '¥980';

  @override
  String get weekly => '週額';

  @override
  String get monthly => '月額';

  @override
  String get lifetimePlan => '永久版';

  @override
  String get bestValue => 'おすすめ';

  @override
  String get perWeek => '/週';

  @override
  String get perMonth => '/月';

  @override
  String get weeklyPrice => '¥480';

  @override
  String get monthlyPrice => '¥980';

  @override
  String get lifetimePrice => '¥2,980';

  @override
  String get language => '言語';

  @override
  String get languageDescription => 'アプリの言語を選択';

  @override
  String get systemLanguage => 'システム言語';

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
  String get bluetoothDisabled => 'Bluetoothが無効です';

  @override
  String get enableBluetoothDescription => 'Bluetoothを有効にしてデバイスをスキャンしてください';

  @override
  String get openSettings => '設定を開く';

  @override
  String get myDevices => 'マイデバイス';

  @override
  String get nearbyDevices => '近くのデバイス';

  @override
  String get noDevicesFound => 'デバイスが見つかりません';

  @override
  String get purchaseError => '購入エラー';

  @override
  String get purchaseErrorDescription => '購入中にエラーが発生しました。もう一度お試しください。';

  @override
  String get purchaseCancelled => '購入がキャンセルされました';

  @override
  String get networkError => 'ネットワークエラー';

  @override
  String get networkErrorDescription => 'インターネット接続を確認して、もう一度お試しください。';

  @override
  String get loadingError => 'オファーを読み込めません';

  @override
  String get loadingErrorDescription => '接続を確認して、もう一度お試しください。';

  @override
  String get ok => 'OK';

  @override
  String get showUnnamedDevices => '名前のないデバイスを表示';

  @override
  String get whyDeviceNotVisible => 'デバイスが見つからない場合';

  @override
  String get deviceVisibleConditions => 'デバイスが表示されるには：';

  @override
  String get deviceMustBeOn => 'デバイスの電源が入っている';

  @override
  String get bluetoothMustBeEnabledOnDevice => 'デバイスのBluetoothが有効になっている';

  @override
  String get deviceMustBeInRange => 'デバイスが範囲内にある（10メートル以内）';

  @override
  String get someDevicesDontBroadcastName => '一部のデバイスは名前を送信しません';

  @override
  String get tipShowUnnamedDevices =>
      'ヒント：「名前のないデバイスを表示」を有効にすると、すべてのBluetoothデバイスが表示されます。';

  @override
  String get understood => '了解';

  @override
  String get pleaseEnableBluetoothSettings => 'デバイスの設定でBluetoothを有効にしてください。';

  @override
  String get onboardingSkip => 'スキップ';

  @override
  String get onboardingNext => '次へ';

  @override
  String get onboardingStart => '始める';

  @override
  String get onboardingTitle1 => 'なくしたデバイスを見つける';

  @override
  String get onboardingDesc1 => '高精度レーダーで、イヤホンやAirPods、Bluetoothデバイスの場所を特定します。';

  @override
  String get onboardingTitle2 => 'お気に入りに保存';

  @override
  String get onboardingDesc2 => '大切なデバイスをお気に入りに追加して、いつでもすぐに見つけられます。';

  @override
  String get onboardingTitle3 => 'いくつかの許可が必要です';

  @override
  String get onboardingDesc3 => 'Bluetoothデバイスをスキャンして探すために、許可が必要です。';

  @override
  String get lastSeenLocation => '最後に検出された場所';

  @override
  String get noLocationHistory => '位置情報の履歴がありません';

  @override
  String get noLocationHistoryDescription => 'デバイスを検出した時に位置情報が記録されます。';

  @override
  String get showOnMap => '地図で見る';

  @override
  String get gpsAccuracyNotice => 'おおよその範囲（約100m）。正確な場所はレーダーをご使用ください。';

  @override
  String get openRadar => 'レーダーを開く';

  @override
  String get unknownDevice => '不明なデバイス';

  @override
  String get featureUnlimitedRadar => '無制限のレーダー探索';

  @override
  String get featureFindAllDevices => 'すべてのデバイスを探す';

  @override
  String get featureAudioAlerts => '接近時のオーディオアラート';

  @override
  String get featureNoAds => '広告なし';

  @override
  String get featureLifetimeUpdates => '永久アップデート';

  @override
  String get free => '無料';

  @override
  String get tapDeviceToLocate => 'デバイスをタップして探す';

  @override
  String get signal => '信号';
}
