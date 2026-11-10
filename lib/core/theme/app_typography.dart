import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography tokens combining DM Sans (UI & long writing) and Lora (brand & editorial accents).
/// Both fonts are licensed under SIL Open Font License 1.1 (OFL-1.1).
abstract final class AppTypography {
  static TextStyle brandTitle({Color? color, double fontSize = 30}) {
    return GoogleFonts.lora(
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      letterSpacing: 4.5,
      color: color,
    );
  }

  static TextStyle editorialQuote({Color? color, double fontSize = 15}) {
    return GoogleFonts.lora(
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.italic,
      height: 1.5,
      color: color,
    );
  }

  static TextTheme buildTextTheme(Color primaryText, Color mutedText) {
    final base = GoogleFonts.dmSansTextTheme().apply(
      bodyColor: primaryText,
      displayColor: primaryText,
    );
    return base.copyWith(
      displaySmall: GoogleFonts.dmSans(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: primaryText,
        letterSpacing: -0.4,
      ),
      headlineMedium: GoogleFonts.dmSans(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: primaryText,
      ),
      titleLarge: GoogleFonts.dmSans(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: primaryText,
      ),
      titleMedium: GoogleFonts.dmSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: primaryText,
      ),
      titleSmall: GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primaryText,
      ),
      bodyLarge: GoogleFonts.dmSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.6,
        color: primaryText,
      ),
      bodyMedium: GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: primaryText,
      ),
      bodySmall: GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: mutedText,
      ),
      labelLarge: GoogleFonts.dmSans(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: primaryText,
      ),
      labelMedium: GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: primaryText,
      ),
      labelSmall: GoogleFonts.dmSans(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: mutedText,
      ),
    );
  }
}
