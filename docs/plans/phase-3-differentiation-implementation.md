# Phase 3: Différenciation - Plan d'Implémentation

**Objectif:** Créer des fonctionnalités uniques que le concurrent n'a pas

---

## Feature 3.1: Historique Carte

### Description
Vue carte montrant les dernières positions connues de chaque appareil favori.

### Fichiers à créer

#### Nouveau: `lib/features/map_history/`
Structure:
```
lib/features/map_history/
├── presentation/
│   ├── providers/
│   │   └── map_history_provider.dart
│   ├── screens/
│   │   └── map_history_screen.dart
│   └── widgets/
│       ├── device_marker.dart
│       └── location_timeline.dart
```

#### `map_history_screen.dart`
- Carte interactive (Google Maps ou Apple Maps selon plateforme)
- Markers pour chaque favori avec dernière position connue
- Marker custom avec icône de l'appareil
- Tap sur marker: affiche détails (nom, dernière vue, distance)
- Filtre par appareil (dropdown)

#### `device_marker.dart`
- Widget custom pour les markers
- Icône selon type d'appareil (écouteurs, montre, etc.)
- Couleur selon ancienneté (récent = vert, ancien = gris)

#### `location_timeline.dart`
- Bottom sheet avec historique des positions
- Liste chronologique: "Aujourd'hui 14h - Bureau", "Hier 18h - Maison"
- Tap pour centrer la carte sur cette position

#### Modifier: `lib/features/favorites/data/models/favorite_device_model.dart`
- Ajouter: `List<LocationHistory> locationHistory` (max 10 entrées)
- Nouveau model `LocationHistory`: lat, lng, placeName, timestamp

#### Modifier: `lib/core/router/app_router.dart`
- Ajouter route `/map` ou `/history`

#### Modifier: Navigation
- Ajouter accès depuis home (icône carte)
- Ajouter accès depuis détail favori

### Dépendances à ajouter
```yaml
# pubspec.yaml
google_maps_flutter: ^2.5.0
# OU pour éviter les coûts Google Maps:
flutter_map: ^6.1.0
latlong2: ^0.9.0
```

### Configuration requise
- Google Maps: API key dans iOS/Android config
- Ou flutter_map: gratuit, utilise OpenStreetMap

### Étapes d'implémentation
1. [ ] Choisir: Google Maps vs flutter_map (OSM)
2. [ ] Ajouter dépendance carte
3. [ ] Configurer API key si Google Maps
4. [ ] Mettre à jour `FavoriteDeviceModel` avec historique
5. [ ] Exécuter build_runner
6. [ ] Créer structure `lib/features/map_history/`
7. [ ] Créer `map_history_provider.dart`
8. [ ] Créer widget `device_marker.dart`
9. [ ] Créer widget `location_timeline.dart`
10. [ ] Créer `map_history_screen.dart`
11. [ ] Ajouter route dans router
12. [ ] Ajouter navigation depuis home/favoris
13. [ ] Ajouter strings localisation (5 langues)
14. [ ] Tester sur iOS
15. [ ] Tester sur Android

---

## Feature 3.2: Widget iOS/Android

### Description
Widget home screen montrant l'état des appareils favoris sans ouvrir l'app.

### iOS Widget (WidgetKit)

#### Fichiers à créer: `ios/SonarWidget/`
```
ios/SonarWidget/
├── SonarWidget.swift
├── SonarWidgetBundle.swift
├── Assets.xcassets/
└── Info.plist
```

#### `SonarWidget.swift`
- Small widget: 1 favori principal avec statut
- Medium widget: 2-3 favoris avec statut
- Affiche: nom, dernière position, temps écoulé
- Tap: ouvre l'app sur le radar de cet appareil
- Timeline: refresh toutes les 15-30 min

#### Configuration Xcode
- Ajouter Widget Extension target
- Configurer App Groups pour partager données avec l'app principale
- Signer avec le même provisioning profile

### Android Widget (Glance / AppWidget)

#### Fichiers à créer: `android/app/src/main/kotlin/.../widget/`
```
widget/
├── SonarWidgetProvider.kt
├── SonarWidgetReceiver.kt
└── res/
    └── layout/
        └── sonar_widget.xml
```

#### `SonarWidgetProvider.kt`
- Small widget: 1 favori
- Medium widget: 2-3 favoris
- Utiliser Glance (Jetpack) pour UI déclarative
- WorkManager pour updates périodiques

### Données partagées
- iOS: App Groups + UserDefaults partagés
- Android: SharedPreferences
- Flutter: `home_widget` package pour simplifier

### Dépendances à ajouter
```yaml
# pubspec.yaml
home_widget: ^0.4.1
```

### Étapes d'implémentation
1. [ ] Ajouter dépendance `home_widget`
2. [ ] iOS: Créer Widget Extension dans Xcode
3. [ ] iOS: Configurer App Groups
4. [ ] iOS: Implémenter `SonarWidget.swift`
5. [ ] iOS: Créer assets widget
6. [ ] Android: Créer `SonarWidgetProvider.kt`
7. [ ] Android: Créer layout XML
8. [ ] Android: Configurer AndroidManifest
9. [ ] Flutter: Configurer `home_widget` pour sync données
10. [ ] Implémenter refresh périodique
11. [ ] Tester widget iOS
12. [ ] Tester widget Android

---

## Feature 3.3: Apple Watch App (Killer Feature!)

### Description
App compagnon Apple Watch avec radar au poignet et retour haptique.

### Fichiers à créer: `watch_app/` (nouveau target)

#### Structure WatchOS
```
ios/WatchApp/
├── WatchApp.swift
├── ContentView.swift
├── RadarView.swift
├── DeviceListView.swift
├── Assets.xcassets/
└── Info.plist
```

#### `RadarView.swift` (SwiftUI)
- Version simplifiée du radar Flutter
- Cercles concentriques
- Indicateur de signal au centre
- Couleur selon proximité (vert/jaune/rouge)

#### `ContentView.swift`
- Liste des favoris
- Tap pour lancer le radar sur cet appareil
- Indication de connexion Bluetooth

#### Fonctionnalités Watch
- **Retour haptique**: vibrations selon proximité
  - Signal fort: vibration success
  - Signal faible: vibration légère
  - Signal perdu: vibration warning
- **Complications**: mini indicateur sur watch face
- **Communication**: WatchConnectivity avec l'app iPhone

### Communication iPhone ↔ Watch
```swift
// WatchConnectivity
- Envoyer liste des favoris depuis iPhone
- Recevoir demande de scan depuis Watch
- Sync état en temps réel pendant recherche
```

### Dépendances Flutter
```yaml
# pubspec.yaml
flutter_watch_os_connectivity: ^1.0.0  # ou équivalent
```

### Configuration Xcode
- Ajouter WatchOS App target
- Configurer Watch Connectivity
- Même App Group que widget
- Provisioning profile Watch

### Étapes d'implémentation
1. [ ] Créer WatchOS target dans Xcode
2. [ ] Configurer WatchConnectivity
3. [ ] Implémenter `DeviceListView.swift`
4. [ ] Implémenter `RadarView.swift`
5. [ ] Implémenter retour haptique
6. [ ] Créer complications
7. [ ] Flutter: intégrer communication Watch
8. [ ] Sync favoris iPhone → Watch
9. [ ] Tester sur simulateur Watch
10. [ ] Tester sur vraie Apple Watch
11. [ ] Soumettre pour review (Watch apps = review séparée)

---

## Checklist Phase 3 Complète

### Historique Carte
- [ ] Choix lib carte (Google vs OSM)
- [ ] Dépendance carte
- [ ] Config API si Google
- [ ] Update FavoriteDeviceModel
- [ ] Build runner
- [ ] Structure feature
- [ ] Provider
- [ ] Widget marker
- [ ] Widget timeline
- [ ] Screen carte
- [ ] Route router
- [ ] Navigation
- [ ] Localisation 5 langues
- [ ] Tests iOS
- [ ] Tests Android

### Widget Home Screen
- [ ] Dépendance home_widget
- [ ] iOS Widget Extension
- [ ] iOS App Groups
- [ ] iOS Widget implementation
- [ ] iOS Assets
- [ ] Android Provider
- [ ] Android Layout
- [ ] Android Manifest
- [ ] Flutter sync config
- [ ] Refresh périodique
- [ ] Tests iOS
- [ ] Tests Android

### Apple Watch
- [ ] WatchOS target Xcode
- [ ] WatchConnectivity
- [ ] DeviceListView
- [ ] RadarView
- [ ] Retour haptique
- [ ] Complications
- [ ] Flutter communication
- [ ] Sync favoris
- [ ] Tests simulateur
- [ ] Tests device réel
- [ ] Soumission review
