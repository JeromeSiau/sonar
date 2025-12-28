# Scanner Bluetooth Improvements

## Décisions

1. **Scan Bluetooth Classic** - Ajouter `flutter_bluetooth_serial` pour Android
2. **Limite freemium** - Tous appareils visibles, 1 essai radar gratuit
3. **Tri** - Sections "Mes appareils" / "À proximité"
4. **"Mes appareils"** - Appairés + Favoris

## Architecture

### Bluetooth Repository
- BLE via `flutter_blue_plus` (iOS + Android)
- Classic via `flutter_bluetooth_serial` (Android only)
- Fusion des résultats avec dédoublonnage par device ID
- Priorité nom : Classic > BLE avec nom > BLE sans nom

### Modèle de données
```dart
class BluetoothDeviceModel {
  final String id;
  final String name;
  final int rssi;
  final DateTime lastSeen;
  final DeviceType type;
  final bool isBonded;
  final BluetoothSource source; // ble, classic, both
}
```

### UI Scanner
- CustomScrollView avec slivers
- Section "Mes appareils" (bonded + favoris) - masquée si vide
- Section "À proximité" (autres appareils)
- Tri par signal dans chaque section

### Freemium
- Appareils illimités visibles
- 1 essai radar gratuit (persisté SharedPreferences)
- Après essai → paywall

## Fichiers à modifier

| Fichier | Changement |
|---------|------------|
| pubspec.yaml | +flutter_bluetooth_serial |
| bluetooth_device_model.dart | +isBonded, +source |
| bluetooth_repository.dart | +scan Classic, fusion, tri |
| scanner_provider.dart | +myDevices/nearbyDevices |
| scanner_screen.dart | CustomScrollView sections |
| section_header.dart | Nouveau widget |
| subscription_provider.dart | Supprimer limite appareils |
| l10n files | +myDevices, +nearby |
