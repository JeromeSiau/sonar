# Stratégie pour Dépasser le #1 de l'App Store

**Date:** 2026-01-01
**Objectif:** Surpasser "Find My Headphones & Earbuds" sur tous les fronts

---

## Analyse Concurrentielle

### Ce qu'ils ont vs ce qu'on a

| Feature | Concurrent | Sonar | Priorité |
|---------|-----------|-------|----------|
| Play Sound | ✅ | ❌ | CRITIQUE |
| Last Seen + GPS | ✅ | Partiel | CRITIQUE |
| Radar/Localisation | "Cold/Warm/Hot" | ✅ Radar visuel (supérieur) | Avantage |
| Design | Générique violet | Submarine/CRT (unique) | Avantage |
| Dual Bluetooth | BLE only? | ✅ BLE + Classic | Avantage |
| Onboarding guidé | ✅ "Step by step" | ❌ Minimal | Important |
| Multi-langue | ❓ | ✅ 5 langues | Avantage |

### Nos avantages existants
- Radar visuel animé supérieur au "Cold/Warm/Hot"
- Esthétique submarine/CRT mémorable et unique
- Support dual Bluetooth (BLE + Classic)
- 5 langues supportées
- Nom optimisé: "Sonar - Find AirPods & Headphones"

---

## Fonctionnalités à Implémenter

### Phase 1 - Parité Critique

#### 1. Play Sound
- Bouton proéminent sur l'écran Radar
- Joue un son fort (bip répétitif) routé vers les écouteurs connectés
- Utilise AVAudioSession (iOS) / AudioManager (Android)
- **Limitation:** Fonctionne uniquement si l'appareil est connecté
- Message clair à l'utilisateur sur cette limitation

#### 2. Last Seen Amélioré avec GPS
- Capturer la position GPS à chaque détection d'un favori
- Afficher: "Vu il y a 2h près de [lieu]" avec mini-carte
- Stocker historique des 10 dernières positions
- Pas de background scanning agressif (battery drain, mauvaises reviews)

#### 3. Nouveaux Tiers Tarifaires
| Tier | Prix | vs Concurrent |
|------|------|---------------|
| Hebdo | 2.99€ | -50% |
| Mensuel | 5.99€ | -40% |
| Lifetime | 14.99€ | -50% |

Positionnement: "Toutes les fonctionnalités du #1, moitié prix"

### Phase 2 - Onboarding & Conversion

#### 4. Onboarding Guidé
- 3 écrans explicatifs:
  1. "Comment ça marche" - Radar + Play Sound
  2. "Autorisations nécessaires" - Bluetooth + Location
  3. "Essai gratuit" - Présentation du trial

#### 5. Écran "Appareil Trouvé!"
- Animation de célébration
- Demande d'avis App Store (SKStoreReviewController)
- Incitation au partage

#### 6. Garantie Remboursement
- Afficher dans le paywall
- Mentionner dans la description App Store
- "Si vous ne trouvez pas votre appareil, remboursement complet"

### Phase 3 - Différenciation

#### 7. Historique Carte
- Vue carte avec les dernières positions connues
- Filtrable par appareil
- Timeline des détections

#### 8. Widget iOS/Android
- Affiche l'état des favoris sans ouvrir l'app
- Statut de connexion + dernière position

#### 9. Apple Watch (Killer Feature)
- Radar au poignet
- Vibrations haptiques selon la proximité
- Le concurrent n'a PAS ça

### Phase 4 - Marketing

#### 10. Screenshots Optimisés
| # | Message |
|---|---------|
| 1 | "Find Your Lost AirPods in Seconds" + Radar |
| 2 | "Play Sound to Locate Instantly" + bouton |
| 3 | "See Last Known Location" + carte |
| 4 | "Works with AirPods, Beats, Bose, JBL..." |
| 5 | "Half the Price of #1 App" |

#### 11. Social Proof
- Compteur "X appareils retrouvés"
- Collecter témoignages utilisateurs
- Reviews response strategy

#### 12. Vidéo App Store
- Preview 15-30s montrant le radar en action
- Scénario: perte → scan → trouvé!

---

## Décisions Techniques

### Play Sound
- **iOS:** AVAudioSession pour router audio vers périphérique connecté
- **Android:** AudioManager pour sélectionner la sortie audio
- Ne fonctionne QUE pour les appareils connectés (pas les perdus/déconnectés)

### Background Scanning (NON retenu pour l'instant)
- iOS très restrictif (~1x/15min max)
- Cause battery drain et mauvaises reviews
- Permissions effrayantes pour l'utilisateur
- **Décision:** Pas de background scanning agressif, focus sur scan manuel

### Anti-Perte (NON retenu pour l'instant)
- Reporté pour focus sur features critiques
- Complexité: éviter faux positifs (alerte chaque départ de maison)
- À reconsidérer en Phase 3+

---

## Résumé Exécutif

**Priorité immédiate:**
1. Play Sound sur appareils connectés
2. Last Seen avec position GPS
3. Nouveaux tiers tarifaires (2.99€/5.99€/14.99€)

**Avantages compétitifs à exploiter:**
- Prix 50% moins cher
- Radar visuel supérieur
- Design unique mémorable
- Support Bluetooth dual

**Message marketing:**
> "Toutes les fonctionnalités du #1, moitié prix, avec un radar visuel supérieur"
