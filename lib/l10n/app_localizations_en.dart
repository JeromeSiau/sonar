// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'SONAR';

  @override
  String get appSubtitle => 'Find AirPods & Headphones';

  @override
  String get scanner => 'SCANNER';

  @override
  String get settings => 'SETTINGS';

  @override
  String get noSavedDevices => 'No saved devices';

  @override
  String get noSavedDevicesDescription =>
      'Scan nearby Bluetooth devices\nand add your favorites to find them easily';

  @override
  String get justNow => 'just now';

  @override
  String minutesAgo(int minutes) {
    return '$minutes min ago';
  }

  @override
  String hoursAgo(int hours) {
    return '${hours}h ago';
  }

  @override
  String daysAgo(int days) {
    return '${days}d ago';
  }

  @override
  String get permissionsRequired => 'Permissions required';

  @override
  String get permissionsDescription =>
      'To locate your Bluetooth devices, we need access to Bluetooth and your location.';

  @override
  String get bluetooth => 'Bluetooth';

  @override
  String get bluetoothPermissionDescription => 'Scan nearby devices';

  @override
  String get location => 'Location';

  @override
  String get locationPermissionDescription => 'Required for Bluetooth scanning';

  @override
  String get authorize => 'Authorize';

  @override
  String get scanError => 'Scan error';

  @override
  String get checkBluetoothEnabled => 'Check that Bluetooth is enabled';

  @override
  String get retry => 'RETRY';

  @override
  String get trialUsed => 'Free trial used';

  @override
  String get trialAvailable => '1 free radar trial available';

  @override
  String get unlock => 'UNLOCK';

  @override
  String devicesFound(int count) {
    return '$count devices found';
  }

  @override
  String get premium => 'PREMIUM';

  @override
  String get scanning => 'SCANNING';

  @override
  String get searchingDevices => 'Searching for Bluetooth devices...';

  @override
  String get scanInProgress => 'Scan in progress...';

  @override
  String get deviceNotFound => 'Device not found';

  @override
  String get searchingForDevice => 'Searching for device...';

  @override
  String get deviceNotInRange => 'Device out of range';

  @override
  String get deviceNotInRangeDescription =>
      'The device was not detected. Make sure it\'s turned on and nearby.';

  @override
  String get backToHome => 'Back';

  @override
  String get radarInstruction =>
      'Move around and follow the signal strength to find your device';

  @override
  String get signalLost => 'Signal lost';

  @override
  String get found => 'Found!';

  @override
  String get cancel => 'Cancel';

  @override
  String get playSound => 'Play sound';

  @override
  String get stopSound => 'Stop sound';

  @override
  String get playSoundDescription => 'Play a sound on the device if connected';

  @override
  String get soundPlaying => 'Playing sound...';

  @override
  String get deviceMustBeConnected =>
      'Device must be connected (not just visible)';

  @override
  String get subscription => 'SUBSCRIPTION';

  @override
  String get goPremium => 'Go Premium';

  @override
  String get unlockAllFeatures => 'Unlock all features';

  @override
  String get restorePurchases => 'Restore purchases';

  @override
  String get restorePurchasesDescription => 'Recover an existing subscription';

  @override
  String get restoringPurchases => 'Restoring purchases...';

  @override
  String get about => 'ABOUT';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get contactUs => 'Contact us';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get premiumStatus => 'Premium';

  @override
  String get freeStatus => 'Free';

  @override
  String get premiumDescription => 'Unlimited access to all features';

  @override
  String get freeDescription => 'Limited features';

  @override
  String get unlockRadar => 'Unlock the Radar';

  @override
  String get locateAllDevices => 'Locate all your Bluetooth devices';

  @override
  String get unlimitedRadar => 'Unlimited Radar';

  @override
  String get unlimitedRadarDescription =>
      'Locate your devices without restrictions';

  @override
  String get fullScan => 'Full Scan';

  @override
  String get fullScanDescription => 'See all nearby devices';

  @override
  String get favorites => 'Favorites';

  @override
  String get favoritesDescription => 'Save your important devices';

  @override
  String get oneTimePurchase => 'One-time purchase';

  @override
  String get oneTimePurchaseDescription => 'Pay once, use forever';

  @override
  String get oneTimePurchaseBadge => 'ONE-TIME PURCHASE';

  @override
  String get unlockNow => 'Unlock now';

  @override
  String get defaultPrice => '\$4.99';

  @override
  String get weekly => 'Weekly';

  @override
  String get monthly => 'Monthly';

  @override
  String get lifetimePlan => 'Lifetime';

  @override
  String get bestValue => 'BEST VALUE';

  @override
  String get perWeek => '/week';

  @override
  String get perMonth => '/month';

  @override
  String get weeklyPrice => '\$2.99';

  @override
  String get monthlyPrice => '\$5.99';

  @override
  String get lifetimePrice => '\$14.99';

  @override
  String get language => 'Language';

  @override
  String get languageDescription => 'Choose app language';

  @override
  String get systemLanguage => 'System language';

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
  String get bluetoothDisabled => 'Bluetooth is off';

  @override
  String get enableBluetoothDescription =>
      'Enable Bluetooth to scan for nearby devices';

  @override
  String get openSettings => 'OPEN SETTINGS';

  @override
  String get myDevices => 'My devices';

  @override
  String get nearbyDevices => 'Nearby';

  @override
  String get noDevicesFound => 'No devices found';

  @override
  String get purchaseError => 'Purchase failed';

  @override
  String get purchaseErrorDescription =>
      'An error occurred during the purchase. Please try again.';

  @override
  String get purchaseCancelled => 'Purchase cancelled';

  @override
  String get networkError => 'Network error';

  @override
  String get networkErrorDescription =>
      'Please check your internet connection and try again.';

  @override
  String get loadingError => 'Unable to load offers';

  @override
  String get loadingErrorDescription =>
      'Please check your connection and try again.';

  @override
  String get ok => 'OK';

  @override
  String get showUnnamedDevices => 'Show unnamed devices';

  @override
  String get whyDeviceNotVisible => 'Why don\'t I see my device?';

  @override
  String get deviceVisibleConditions => 'For a device to be visible:';

  @override
  String get deviceMustBeOn => 'The device must be turned on';

  @override
  String get bluetoothMustBeEnabledOnDevice =>
      'Bluetooth must be enabled on the device';

  @override
  String get deviceMustBeInRange =>
      'The device must be within range (< 10 meters)';

  @override
  String get someDevicesDontBroadcastName =>
      'Some devices don\'t broadcast their name';

  @override
  String get tipShowUnnamedDevices =>
      'Tip: Enable \"Show unnamed devices\" to see all nearby Bluetooth devices.';

  @override
  String get understood => 'Got it';

  @override
  String get pleaseEnableBluetoothSettings =>
      'Please enable Bluetooth in your device settings.';
}
