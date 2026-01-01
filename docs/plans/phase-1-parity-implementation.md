# Phase 1: Parité Critique - Plan d'Implémentation

**Objectif:** Combler les gaps critiques avec le concurrent #1

---

## Feature 1.1: Play Sound

### Description
Bouton permettant de jouer un son fort sur les écouteurs/casques connectés pour les localiser.

### Fichiers à créer/modifier

#### Nouveau: `lib/core/services/audio_routing_service.dart`
- Service pour router l'audio vers les périphériques Bluetooth connectés
- iOS: Utiliser `AVAudioSession` pour forcer la sortie vers le périphérique Bluetooth
- Android: Utiliser `AudioManager` pour sélectionner la sortie audio
- Méthode `playLocatorSound()` qui joue un bip répétitif fort

#### Nouveau: `lib/core/services/sound_assets/locator_beep.mp3`
- Son de localisation: bip aigu répétitif (3-5 secondes)
- Volume maximum, fréquence distinctive

#### Modifier: `lib/features/radar/presentation/screens/radar_screen.dart`
- Ajouter bouton "Play Sound" proéminent sous le radar
- État: désactivé si appareil non connecté
- Feedback visuel pendant la lecture

#### Modifier: `lib/features/radar/presentation/providers/`
- Nouveau provider `playSoundProvider` pour gérer l'état de lecture
- Vérifier si l'appareil est connecté avant de permettre le son

#### Modifier: Localisation (`lib/l10n/`)
- Ajouter strings: "Play Sound", "Sound playing...", "Device must be connected"

### Dépendances à ajouter
```yaml
# pubspec.yaml
audioplayers: ^5.2.1  # ou just_audio selon préférence
```

### Étapes d'implémentation
1. [ ] Ajouter dépendance `audioplayers`
2. [ ] Créer `audio_routing_service.dart` avec logique iOS/Android
3. [ ] Ajouter fichier audio `locator_beep.mp3`
4. [ ] Créer provider `playSoundProvider`
5. [ ] Modifier UI du radar pour ajouter le bouton
6. [ ] Ajouter strings de localisation (5 langues)
7. [ ] Tester sur iOS avec AirPods connectés
8. [ ] Tester sur Android avec casque Bluetooth connecté

---

## Feature 1.2: Last Seen avec GPS

### Description
Enregistrer la position GPS à chaque détection d'un appareil favori et l'afficher.

### Fichiers à créer/modifier

#### Modifier: `lib/features/favorites/data/models/favorite_device_model.dart`
- Ajouter champs:
  - `double? lastLatitude`
  - `double? lastLongitude`
  - `String? lastLocationName` (géocodage inverse)
  - `DateTime? lastSeenAt`
- Mettre à jour `@HiveType` et régénérer avec `build_runner`

#### Nouveau: `lib/core/services/location_service.dart`
- Service pour obtenir la position GPS actuelle
- Méthode `getCurrentPosition()` → `(lat, lng)`
- Méthode `getPlaceName(lat, lng)` → géocodage inverse (nom de lieu)
- Gérer les permissions Location

#### Modifier: `lib/features/favorites/data/repositories/favorites_repository.dart`
- Lors de la mise à jour d'un favori détecté, capturer la position GPS
- Appeler `locationService.getCurrentPosition()`
- Mettre à jour `lastLatitude`, `lastLongitude`, `lastLocationName`

#### Modifier: `lib/features/favorites/presentation/widgets/`
- Afficher "Vu il y a X" avec le nom du lieu
- Petite icône carte cliquable pour voir sur la carte

#### Modifier: `lib/features/scanner/presentation/providers/`
- Lors d'un scan, si un favori est détecté, mettre à jour sa position

#### Modifier: Localisation
- Strings: "Last seen", "near", "ago", "Unknown location"

### Dépendances à ajouter
```yaml
# pubspec.yaml
geolocator: ^10.1.0
geocoding: ^2.1.1
```

### Permissions à ajouter

#### iOS (`ios/Runner/Info.plist`)
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>To remember where your devices were last seen</string>
```

#### Android (`android/app/src/main/AndroidManifest.xml`)
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

### Étapes d'implémentation
1. [ ] Ajouter dépendances `geolocator` et `geocoding`
2. [ ] Mettre à jour `FavoriteDeviceModel` avec champs GPS
3. [ ] Exécuter `dart run build_runner build --delete-conflicting-outputs`
4. [ ] Créer `location_service.dart`
5. [ ] Mettre à jour permissions iOS/Android
6. [ ] Modifier `favorites_repository.dart` pour capturer la position
7. [ ] Modifier le scanner pour déclencher la mise à jour de position
8. [ ] Modifier les widgets favoris pour afficher le lieu
9. [ ] Ajouter strings de localisation (5 langues)
10. [ ] Tester le flux complet

---

## Feature 1.3: Nouveaux Tiers Tarifaires

### Description
Ajouter abonnements hebdo (2.99€) et mensuel (5.99€), augmenter lifetime à 14.99€.

### Fichiers à modifier

#### RevenueCat Dashboard (hors code)
- Créer nouveaux produits:
  - `sonar_weekly` - 2.99€/semaine auto-renouvelable
  - `sonar_monthly` - 5.99€/mois auto-renouvelable
  - Mettre à jour `sonar_lifetime` - 14.99€

#### Modifier: `lib/features/paywall/presentation/screens/paywall_screen.dart`
- Afficher 3 options au lieu d'une
- Mettre en avant "BEST VALUE" sur lifetime
- Afficher économies: "Économisez X% vs mensuel"

#### Modifier: `lib/features/paywall/presentation/providers/`
- Charger les 3 offerings depuis RevenueCat
- Gérer la sélection de tier

#### Modifier: `lib/features/paywall/presentation/widgets/`
- Créer widget `PricingTierCard` pour chaque option
- Design: carte sélectionnable avec prix, période, badge

#### Modifier: Localisation
- Strings: "Weekly", "Monthly", "Lifetime", "Best Value", "Save X%"

### Étapes d'implémentation
1. [ ] Configurer nouveaux produits dans RevenueCat Dashboard
2. [ ] Configurer produits dans App Store Connect
3. [ ] Configurer produits dans Google Play Console
4. [ ] Créer widget `PricingTierCard`
5. [ ] Modifier `paywall_screen.dart` pour afficher 3 tiers
6. [ ] Mettre à jour providers pour charger tous les offerings
7. [ ] Ajouter strings de localisation (5 langues)
8. [ ] Tester achat sandbox iOS
9. [ ] Tester achat sandbox Android

---

## Checklist Phase 1 Complète

### Play Sound
- [ ] Dépendance audioplayers
- [ ] AudioRoutingService
- [ ] Asset audio locator_beep.mp3
- [ ] Provider playSoundProvider
- [ ] UI bouton sur radar
- [ ] Localisation 5 langues
- [ ] Tests iOS
- [ ] Tests Android

### Last Seen GPS
- [ ] Dépendances geolocator + geocoding
- [ ] Mise à jour FavoriteDeviceModel
- [ ] Build runner Hive
- [ ] LocationService
- [ ] Permissions iOS/Android
- [ ] Intégration favorites_repository
- [ ] Intégration scanner
- [ ] UI affichage lieu
- [ ] Localisation 5 langues
- [ ] Tests

### Nouveaux Prix
- [ ] Config RevenueCat
- [ ] Config App Store Connect
- [ ] Config Google Play
- [ ] Widget PricingTierCard
- [ ] UI Paywall 3 tiers
- [ ] Providers offerings
- [ ] Localisation 5 langues
- [ ] Tests sandbox iOS
- [ ] Tests sandbox Android
