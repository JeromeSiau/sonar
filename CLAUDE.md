# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Bluetooth Finder (branded as "Sonar") is a Flutter app for finding lost Bluetooth devices (earbuds, headphones, etc.). It scans for nearby BLE and Classic Bluetooth devices, displays signal strength, and provides a radar view to help locate devices.

## Common Commands

```bash
# Run the app
flutter run

# Run tests
flutter test

# Run a single test file
flutter test test/core/utils/rssi_utils_test.dart

# Generate Hive adapters after modifying @HiveType models
dart run build_runner build --delete-conflicting-outputs

# Generate localization files after editing .arb files
flutter gen-l10n

# Analyze code
flutter analyze
```

## Architecture

### Feature-Based Structure
The app uses a feature-based architecture under `lib/features/`:
- **scanner** - Bluetooth scanning with `BluetoothRepository` handling both BLE (flutter_blue_plus) and Classic (flutter_bluetooth_serial, Android only)
- **favorites** - Persisted favorite devices using Hive with `FavoritesRepository` singleton
- **radar** - Visual radar widget for locating a specific device by signal strength
- **paywall** - RevenueCat integration for premium subscriptions with free tier limits
- **permissions** - Bluetooth/location permission flow
- **settings** - App settings including locale selection

### State Management
- **Riverpod** for all state management
- Key providers in `lib/features/*/presentation/providers/`
- `subscriptionStatusProvider` and `isPremiumProvider` control premium access
- `radarTrialUsedProvider` tracks one-time radar trial for free users

### Routing
- **go_router** with permission-based redirects in `lib/core/router/app_router.dart`
- Routes: `/` (home), `/scanner`, `/radar/:deviceId`, `/permissions`, `/paywall`, `/settings`

### Data Persistence
- **Hive** for local storage (favorites, settings, trial state)
- `FavoriteDeviceModel` is a HiveType - regenerate with `build_runner` after changes

### Localization
- ARB files in `lib/l10n/` with French (`app_fr.arb`) as the template
- Supported locales: en, fr, de, es, it
- Access strings via `AppLocalizations.of(context)!`

### Bluetooth Handling
`BluetoothRepository` (`lib/features/scanner/data/repositories/bluetooth_repository.dart`):
- Merges BLE and Classic scan results, preferring named devices
- Tracks bonded/paired devices separately
- Auto-removes stale devices after 10 seconds of no signal
- RSSI values used for proximity estimation (see `rssi_utils.dart`)
