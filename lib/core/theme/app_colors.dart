import 'package:flutter/material.dart';

/// Sonar - Deep Ocean Submarine Theme
/// Inspired by vintage submarine control rooms and CRT sonar displays
abstract final class AppColors {
  // === BACKGROUND DEPTHS ===
  // Deep ocean abyss - creates immersive underwater atmosphere
  static const Color background = Color(0xFF040A12);
  static const Color surface = Color(0xFF0C1824);
  static const Color surfaceLight = Color(0xFF162636);
  static const Color surfaceGlow = Color(0xFF1E3448);

  // === SONAR PRIMARY ===
  // Softer teal - less aggressive, more elegant
  static const Color primary = Color(0xFF5ECFCF);       // Softer teal
  static const Color primaryDim = Color(0xFF3BA8A8);    // Muted
  static const Color primaryGlow = Color(0xFF7EDDDD);   // Lighter glow

  // === SIGNAL STATES ===
  // Softer, more pastel signal colors
  static const Color signalStrong = Color(0xFF6EE7A8);  // Soft mint green
  static const Color signalMedium = Color(0xFFFFCC66);  // Soft amber
  static const Color signalWeak = Color(0xFFFF8A80);    // Soft coral

  // === TEXT HIERARCHY ===
  static const Color textPrimary = Color(0xFFE8EEF4);
  static const Color textSecondary = Color(0xFF8A9DB5);
  static const Color textMuted = Color(0xFF556677);

  // === ACCENTS ===
  static const Color favorite = Color(0xFFFF5A8A);      // Softer pink
  static const Color favoriteInactive = Color(0xFF3D4A5C);

  // === SCAN EFFECTS ===
  static const Color scanLine = Color(0xFF5ECFCF);
  static const Color scanGlow = Color(0x405ECFCF);
  static const Color gridLine = Color(0xFF1E3A5F);

  // === GRADIENTS ===
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF081018),
      Color(0xFF040A12),
      Color(0xFF020608),
    ],
  );

  static const RadialGradient radarGlow = RadialGradient(
    colors: [
      Color(0x205ECFCF),
      Color(0x085ECFCF),
      Colors.transparent,
    ],
  );

  // === GLASSMORPHISM ===
  static const Color glassBackground = Color(0x1A0C1824);
  static const Color glassBorder = Color(0x335ECFCF);
}
