import 'package:flutter/material.dart';

/// Centralized color tokens for the YASSELIM "Peaceful Twilight" design system.
abstract final class AppColors {
  // Primary Brand Palette (Peaceful Twilight)
  static const Color deepNightNavy = Color(0xFF17172E);
  static const Color midnightPurple = Color(0xFF292647);
  static const Color twilightIndigo = Color(0xFF332D5C);
  static const Color lavender = Color(0xFFA99AEF);
  static const Color brightLavender = Color(0xFFB9A9FF);
  static const Color softLavender = Color(0xFFD8CEFF);
  static const Color vibrantViolet = Color(0xFF7B61FF);
  static const Color warmWhite = Color(0xFFFCFAFF);
  static const Color mutedText = Color(0xFFB5B0CC);
  static const Color premiumGold = Color(0xFFE9C77A);
  static const Color premiumGoldDeep = Color(0xFFD4A446);

  // Dark Theme Tokens
  static const Color darkBackground = Color(0xFF17172E);
  static const Color darkSurface = Color(0xFF22213D);
  static const Color darkSurfaceElevated = Color(0xFF2D2B50);
  static const Color darkPrimary = Color(0xFFB9A9FF);
  static const Color darkSecondary = Color(0xFF8977C9);
  static const Color darkText = Color(0xFFFFFFFF);
  static const Color darkMuted = Color(0xFFC4BEDC);
  static const Color darkBorder = Color(0x33D8CEFF);

  // Light Theme Tokens
  static const Color lightBackground = Color(0xFFF8F7FC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceElevated = Color(0xFFF1EEFA);
  static const Color lightPrimary = Color(0xFF6652B5);
  static const Color lightSecondary = Color(0xFFA99AEF);
  static const Color lightText = Color(0xFF27243A);
  static const Color lightMuted = Color(0xFF817D94);
  static const Color lightBorder = Color(0x266652B5);

  // Semantic Colors
  static const Color success = Color(0xFF63D499);
  static const Color warning = Color(0xFFF2B866);
  static const Color danger = Color(0xFFEF6E7B);

  // Mood Accent Colors
  static const Color moodHappy = Color(0xFFF7C96F);
  static const Color moodCalm = Color(0xFF88D4E3);
  static const Color moodSad = Color(0xFF7B9ACC);
  static const Color moodAnxious = Color(0xFFD89CE6);
  static const Color moodAngry = Color(0xFFEF7A7A);
  static const Color moodHopeful = Color(0xFFA99AEF);
  static const Color moodGrateful = Color(0xFFF59EB3);
  static const Color moodNeutral = Color(0xFFA5A1BA);

  // Gradients
  static const LinearGradient twilightSkyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF131328),
      Color(0xFF1E1B3E),
      Color(0xFF2B2556),
      Color(0xFF17172E),
    ],
    stops: [0.0, 0.38, 0.72, 1.0],
  );

  static const LinearGradient lightSkyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF8F7FC), Color(0xFFEDE9FA), Color(0xFFF6F4FD)],
  );

  static const LinearGradient lavenderButtonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF8D75F5), Color(0xFFB39DFF), Color(0xFF8468F0)],
  );

  static const LinearGradient premiumGoldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF5D88E), Color(0xFFE9C77A), Color(0xFFD1A146)],
  );
}
