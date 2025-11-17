import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Application typography system following Material 3 guidelines.
///
/// Provides consistent text styles throughout the application with
/// proper hierarchy, readability, and accessibility.
class AppTypography {
  AppTypography._();

  // ============================================================================
  // Font Families
  // ============================================================================

  /// Primary font family used throughout the app
  static String get primaryFontFamily => GoogleFonts.poppins().fontFamily!;

  /// Secondary font family for special elements
  static String get secondaryFontFamily => GoogleFonts.inter().fontFamily!;

  // ============================================================================
  // Display Styles (Large, prominent text)
  // ============================================================================

  /// Display Large - 57sp
  static TextStyle get displayLarge => GoogleFonts.poppins(
    fontSize: 57,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.25,
    height: 1.12,
  );

  /// Display Medium - 45sp
  static TextStyle get displayMedium => GoogleFonts.poppins(
    fontSize: 45,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    height: 1.16,
  );

  /// Display Small - 36sp
  static TextStyle get displaySmall => GoogleFonts.poppins(
    fontSize: 36,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.22,
  );

  // ============================================================================
  // Headline Styles
  // ============================================================================

  /// Headline Large - 32sp
  static TextStyle get headlineLarge => GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.25,
  );

  /// Headline Medium - 28sp
  static TextStyle get headlineMedium => GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.29,
  );

  /// Headline Small - 24sp
  static TextStyle get headlineSmall => GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.33,
  );

  // ============================================================================
  // Title Styles
  // ============================================================================

  /// Title Large - 22sp
  static TextStyle get titleLarge => GoogleFonts.poppins(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.27,
  );

  /// Title Medium - 16sp
  static TextStyle get titleMedium => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.5,
  );

  /// Title Small - 14sp
  static TextStyle get titleSmall => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.43,
  );

  // ============================================================================
  // Body Styles
  // ============================================================================

  /// Body Large - 16sp
  static TextStyle get bodyLarge => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.5,
  );

  /// Body Medium - 14sp
  static TextStyle get bodyMedium => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.43,
  );

  /// Body Small - 12sp
  static TextStyle get bodySmall => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
  );

  // ============================================================================
  // Label Styles
  // ============================================================================

  /// Label Large - 14sp
  static TextStyle get labelLarge => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
  );

  /// Label Medium - 12sp
  static TextStyle get labelMedium => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.33,
  );

  /// Label Small - 11sp
  static TextStyle get labelSmall => GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.45,
  );

  // ============================================================================
  // Special Purpose Styles
  // ============================================================================

  /// Button text style
  static TextStyle get button => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
    height: 1.43,
  );

  /// Caption text style
  static TextStyle get caption => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
  );

  /// Overline text style (uppercase, small)
  static TextStyle get overline => GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.5,
    height: 1.6,
  );

  // ============================================================================
  // Text Theme Factory
  // ============================================================================

  /// Creates a complete TextTheme with all styles
  static TextTheme createTextTheme({Color? color}) {
    return TextTheme(
      displayLarge: displayLarge.apply(color: color),
      displayMedium: displayMedium.apply(color: color),
      displaySmall: displaySmall.apply(color: color),
      headlineLarge: headlineLarge.apply(color: color),
      headlineMedium: headlineMedium.apply(color: color),
      headlineSmall: headlineSmall.apply(color: color),
      titleLarge: titleLarge.apply(color: color),
      titleMedium: titleMedium.apply(color: color),
      titleSmall: titleSmall.apply(color: color),
      bodyLarge: bodyLarge.apply(color: color),
      bodyMedium: bodyMedium.apply(color: color),
      bodySmall: bodySmall.apply(color: color),
      labelLarge: labelLarge.apply(color: color),
      labelMedium: labelMedium.apply(color: color),
      labelSmall: labelSmall.apply(color: color),
    );
  }
}
