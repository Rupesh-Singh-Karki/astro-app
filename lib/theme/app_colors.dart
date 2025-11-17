import 'package:flutter/material.dart';

/// Application color palette based on Material 3 purple theme.
///
/// This class defines the complete color system for the application,
/// including primary colors, surface colors, and semantic colors.
class AppColors {
  AppColors._();

  // ============================================================================
  // Primary Purple Colors (Pastel)
  // ============================================================================

  /// Primary purple color - soft pastel purple
  static const Color primaryPurple = Color(0xFFB794F6);

  /// Lighter shade of primary purple
  static const Color primaryPurpleLight = Color(0xFFD6BCFA);

  /// Darker shade of primary purple
  static const Color primaryPurpleDark = Color(0xFF9F7AEA);

  /// Very light purple for containers
  static const Color purpleContainer = Color(0xFFF5F3FF);

  /// Purple accent color
  static const Color purpleAccent = Color(0xFFC4B5FD);

  // ============================================================================
  // Secondary Colors
  // ============================================================================

  /// Secondary color - soft pink that complements pastel purple
  static const Color secondary = Color(0xFFF9A8D4);

  /// Secondary container color
  static const Color secondaryContainer = Color(0xFFFCE7F3);

  // ============================================================================
  // Tertiary Colors
  // ============================================================================

  /// Tertiary color for additional accents
  static const Color tertiary = Color(0xFF06B6D4);

  /// Tertiary container color
  static const Color tertiaryContainer = Color(0xFFE0F2FE);

  // ============================================================================
  // Neutral Colors
  // ============================================================================

  /// Pure white
  static const Color white = Color(0xFFFFFFFF);

  /// Pure black
  static const Color black = Color(0xFF000000);

  /// Light grey for surfaces
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // ============================================================================
  // Semantic Colors
  // ============================================================================

  /// Success color
  static const Color success = Color(0xFF10B981);

  /// Success container
  static const Color successContainer = Color(0xFFD1FAE5);

  /// Error color
  static const Color error = Color(0xFFEF4444);

  /// Error container
  static const Color errorContainer = Color(0xFFFEE2E2);

  /// Warning color
  static const Color warning = Color(0xFFF59E0B);

  /// Warning container
  static const Color warningContainer = Color(0xFFFEF3C7);

  /// Info color
  static const Color info = Color(0xFF3B82F6);

  /// Info container
  static const Color infoContainer = Color(0xFFDBEAFE);

  // ============================================================================
  // Gradient Colors
  // ============================================================================

  /// Primary gradient for hero sections and special UI elements
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryPurple, primaryPurpleLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Secondary gradient
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, purpleAccent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Cosmic gradient for astrology-themed elements (softer pastel version)
  static const LinearGradient cosmicGradient = LinearGradient(
    colors: [Color(0xFFA5B4FC), Color(0xFFC4B5FD), Color(0xFFF9A8D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ============================================================================
  // Shadow Colors
  // ============================================================================

  /// Light shadow with purple tint
  static final Color shadowLight = primaryPurple.withValues(alpha: 0.08);

  /// Medium shadow with purple tint
  static final Color shadowMedium = primaryPurple.withValues(alpha: 0.15);

  /// Strong shadow with purple tint
  static final Color shadowStrong = primaryPurple.withValues(alpha: 0.25);
}
