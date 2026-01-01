# Phase 2: Onboarding & Conversion - Plan d'Implémentation

**Objectif:** Améliorer l'onboarding et maximiser la conversion vers premium

---

## Feature 2.1: Onboarding Guidé

### Description
3 écrans d'introduction pour les nouveaux utilisateurs expliquant l'app et demandant les permissions.

### Fichiers à créer

#### Nouveau: `lib/features/onboarding/`
Structure complète:
```
lib/features/onboarding/
├── data/
│   └── repositories/
│       └── onboarding_repository.dart  # Persiste si onboarding vu
├── presentation/
│   ├── providers/
│   │   └── onboarding_provider.dart
│   ├── screens/
│   │   └── onboarding_screen.dart
│   └── widgets/
│       ├── onboarding_page.dart
│       └── onboarding_indicator.dart
```

#### `onboarding_screen.dart`
- PageView avec 3 pages
- Page 1: "Trouvez vos appareils perdus" - Animation radar + explication
- Page 2: "Jouez un son pour localiser" - Illustration Play Sound
- Page 3: "Autorisations nécessaires" - Demande Bluetooth + Location
- Bouton "Suivant" / "Commencer"
- Skip optionnel

#### `onboarding_repository.dart`
- Stocke dans Hive: `hasSeenOnboarding: bool`
- Vérifie au lancement si l'onboarding doit être affiché

#### Modifier: `lib/core/router/app_router.dart`
- Ajouter route `/onboarding`
- Redirect initial: si `!hasSeenOnboarding` → `/onboarding`

#### Assets à créer
- `assets/images/onboarding_1.png` - Illustration radar
- `assets/images/onboarding_2.png` - Illustration play sound
- `assets/images/onboarding_3.png` - Illustration permissions
- Ou utiliser Lottie animations si disponibles

#### Modifier: Localisation
- Strings pour les 3 pages (titres, descriptions, boutons)

### Étapes d'implémentation
1. [ ] Créer structure `lib/features/onboarding/`
2. [ ] Créer `onboarding_repository.dart` avec Hive
3. [ ] Créer `onboarding_provider.dart`
4. [ ] Créer widget `onboarding_page.dart`
5. [ ] Créer widget `onboarding_indicator.dart` (dots)
6. [ ] Créer `onboarding_screen.dart` avec PageView
7. [ ] Créer/obtenir assets illustrations
8. [ ] Modifier router pour redirect onboarding
9. [ ] Ajouter strings localisation (5 langues)
10. [ ] Intégrer demande permissions sur page 3
11. [ ] Tester flux complet nouveau utilisateur

---

## Feature 2.2: Écran "Appareil Trouvé!"

### Description
Écran de célébration quand l'utilisateur trouve son appareil, avec demande d'avis App Store.

### Fichiers à créer/modifier

#### Nouveau: `lib/features/radar/presentation/screens/found_celebration_screen.dart`
- Animation de célébration (confettis, check animé)
- Message "Vous avez trouvé [nom appareil]!"
- Bouton "Super!" qui ferme
- Après 2-3 utilisations réussies: demande d'avis

#### Nouveau: `lib/core/services/review_service.dart`
- Intégration `in_app_review`
- Logique: demander avis après X appareils trouvés
- Tracker dans Hive: `devicesFoundCount`, `hasRequestedReview`
- Ne demander qu'une fois, au bon moment

#### Modifier: `lib/features/radar/presentation/screens/radar_screen.dart`
- Détecter quand le signal est "trouvé" (très fort + stable)
- Afficher bouton "J'ai trouvé!"
- Navigation vers `found_celebration_screen`

#### Modifier: `lib/features/radar/presentation/providers/`
- Provider pour tracker l'état "trouvé"
- Incrémenter compteur dans Hive

#### Modifier: Localisation
- "I found it!", "Congratulations!", "You found your [device]!", "Rate us"

### Dépendances à ajouter
```yaml
# pubspec.yaml
in_app_review: ^2.0.8
confetti: ^0.7.0  # Pour l'animation
```

### Étapes d'implémentation
1. [ ] Ajouter dépendances `in_app_review` et `confetti`
2. [ ] Créer `review_service.dart`
3. [ ] Créer `found_celebration_screen.dart`
4. [ ] Ajouter bouton "J'ai trouvé!" sur radar
5. [ ] Implémenter logique de détection "trouvé"
6. [ ] Implémenter animation confettis
7. [ ] Intégrer demande d'avis conditionnelle
8. [ ] Ajouter strings localisation (5 langues)
9. [ ] Tester flux iOS (in_app_review)
10. [ ] Tester flux Android

---

## Feature 2.3: Garantie Remboursement

### Description
Afficher une garantie "satisfait ou remboursé" pour augmenter la confiance et conversion.

### Fichiers à modifier

#### Modifier: `lib/features/paywall/presentation/screens/paywall_screen.dart`
- Ajouter badge/banner "Garantie satisfait ou remboursé"
- Icône bouclier + texte rassurant
- Position: sous les options de prix

#### Modifier: `lib/features/paywall/presentation/widgets/`
- Nouveau widget `GuaranteeBadge`
- Design: icône bouclier, texte, couleur rassurante (vert)

#### Modifier: Localisation
- "Money-back guarantee", "Not satisfied? Full refund", "Risk-free"

#### Hors code: App Store / Play Store
- Mettre à jour description avec mention de la garantie
- Process interne: comment gérer les demandes de remboursement

### Étapes d'implémentation
1. [ ] Créer widget `GuaranteeBadge`
2. [ ] Intégrer dans `paywall_screen.dart`
3. [ ] Ajouter strings localisation (5 langues)
4. [ ] Mettre à jour description App Store
5. [ ] Mettre à jour description Play Store
6. [ ] Documenter process de remboursement interne

---

## Checklist Phase 2 Complète

### Onboarding
- [ ] Structure feature onboarding
- [ ] Repository Hive
- [ ] Provider
- [ ] Widget page
- [ ] Widget indicator
- [ ] Screen principal
- [ ] Assets illustrations
- [ ] Router redirect
- [ ] Localisation 5 langues
- [ ] Intégration permissions
- [ ] Tests

### Célébration Trouvé
- [ ] Dépendance in_app_review
- [ ] Dépendance confetti
- [ ] ReviewService
- [ ] Screen célébration
- [ ] Bouton "J'ai trouvé"
- [ ] Logique détection
- [ ] Animation confettis
- [ ] Demande avis conditionnelle
- [ ] Localisation 5 langues
- [ ] Tests iOS/Android

### Garantie
- [ ] Widget GuaranteeBadge
- [ ] Intégration paywall
- [ ] Localisation 5 langues
- [ ] Update App Store description
- [ ] Update Play Store description
- [ ] Process remboursement documenté
