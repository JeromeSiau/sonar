Configuration RevenueCat requise
1. App Store Connect
My Apps → Ton app → In-App Purchases
Créer un Non-Consumable :
Reference Name: Premium Lifetime
Product ID: premium_lifetime
Prix: 4,99 € (Tier 5)
2. Google Play Console
Monetize → Products → In-app products
Créer un produit :
Product ID: premium_lifetime
Prix: 4,99 €
3. RevenueCat Dashboard
Products → Ajouter les 2 product IDs
Entitlements → Créer premium
Offerings → Créer un package Lifetime lié à l'entitlement
Project Settings → Copier ta vraie API key
4. Dans ton code
Remplacer dans main.dart :

'test_bNVWFNdQpzUgWdVFtcDArCyKEGF'  // ← remplacer par ta vraie clé