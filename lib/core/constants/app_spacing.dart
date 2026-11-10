import 'package:flutter/material.dart';

/// Shared spacing, radius, and shadow tokens for consistent layout rhythm.
abstract final class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;

  static const double radiusSm = 12.0;
  static const double radiusMd = 16.0;
  static const double radiusLg = 20.0;
  static const double radiusXl = 24.0;
  static const double radiusPill = 999.0;

  static BorderRadius get cardRadius => BorderRadius.circular(radiusXl);
  static BorderRadius get mediumRadius => BorderRadius.circular(radiusMd);
  static BorderRadius get pillRadius => BorderRadius.circular(radiusPill);

  static List<BoxShadow> softShadow({bool isDark = true}) {
    if (isDark) {
      return const [
        BoxShadow(
          color: Color(0x40070614),
          blurRadius: 24,
          offset: Offset(0, 10),
        ),
      ];
    }
    return const [
      BoxShadow(color: Color(0x1441327A), blurRadius: 20, offset: Offset(0, 8)),
    ];
  }

  static List<BoxShadow> lavenderGlow() => const [
    BoxShadow(
      color: Color(0x55977DFF),
      blurRadius: 24,
      spreadRadius: 1,
      offset: Offset(0, 6),
    ),
  ];
}
