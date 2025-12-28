# Sonar - Bluetooth Finder - Design Document

## Overview

**Nom:** Sonar - Bluetooth Finder
**Sous-titre:** Find Lost Earbuds & Devices

Application Flutter (iOS + Android) pour localiser des appareils Bluetooth perdus via la force du signal RSSI.

## Fonctionnalités

### Core
- Scan des appareils BLE à proximité
- Liste temps réel avec force du signal
- Radar visuel animé pour localisation précise
- Sauvegarde des appareils favoris
- Historique de dernière position connue

### UX
- Icône cœur pour ajouter/retirer des favoris
- Code couleur RSSI : vert (proche) → orange → rouge (loin)
- Écran permissions explicatif au premier lancement

## Architecture

```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── theme/
│   └── utils/
├── features/
│   ├── scanner/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── radar/
│   │   └── presentation/
│   └── favorites/
│       ├── data/
│       └── presentation/
└── shared/
    └── widgets/
```

## Modèles de données

### BluetoothDevice
```dart
class BluetoothDevice {
  String id;           // Adresse MAC ou UUID
  String name;         // Nom affiché (ou "Inconnu")
  int rssi;            // Force signal (-30 à -100 dBm)
  DateTime lastSeen;
  DeviceType type;     // airpods, headphones, watch, other
}
```

### FavoriteDevice (persisté)
```dart
class FavoriteDevice {
  String id;
  String customName;
  DeviceType type;
  DateTime addedAt;
  DateTime lastSeenAt;
  int lastRssi;
  String? lastLocation;
}
```

## Logique RSSI

| RSSI | Distance | Couleur |
|------|----------|---------|
| > -50 | < 1m | Vert |
| -50 à -70 | 1-5m | Orange |
| < -70 | > 5m | Rouge |

## Stack technique

- **Flutter:** 3.38+
- **State management:** Riverpod
- **Navigation:** go_router
- **Stockage:** Hive
- **Bluetooth:** flutter_blue_plus
- **Permissions:** permission_handler

## Écrans

1. **Accueil** - Liste favoris + bouton Scanner
2. **Scanner** - Liste temps réel appareils BLE
3. **Radar** - Vue détaillée avec animation cercles concentriques

## Plateformes

- iOS minimum: 13.0
- Android minimum: SDK 21

## Monétisation

**Modèle :** Abonnement (freemium)

**Pricing :**
- Essai gratuit : 3 jours
- Mensuel : 2.99€/mois
- Annuel : 19.99€/an

**Version gratuite (limitations) :**
- Scan limité à 3 appareils
- Radar limité à 30 secondes
- Pas de favoris

**Version premium :**
- Scan illimité
- Radar illimité
- Favoris + historique

**Stack :**
- RevenueCat (purchases_flutter)
- Paywall custom avec le design de l'app

**Écran paywall :**
- Affiché quand l'utilisateur atteint une limite
- Options mensuel/annuel
- Bouton "Restaurer les achats"
