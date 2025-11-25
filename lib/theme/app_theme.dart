import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_spacing.dart';

/// Complete Material 3 theme configuration for the application.
///
/// Provides both light and dark themes with consistent styling across
/// all components following Material Design 3 guidelines.
class AppTheme {
  AppTheme._();

  // ============================================================================
  // Color Schemes
  // ============================================================================

  /// Light color scheme
  static ColorScheme get _lightColorScheme => ColorScheme.light(
    primary: AppColors.primaryPurple,
    onPrimary: AppColors.white,
    primaryContainer: AppColors.purpleContainer,
    onPrimaryContainer: AppColors.primaryPurpleDark,
    secondary: AppColors.secondary,
    onSecondary: AppColors.white,
    secondaryContainer: AppColors.secondaryContainer,
    onSecondaryContainer: AppColors.primaryPurpleDark,
    tertiary: AppColors.tertiary,
    onTertiary: AppColors.white,
    tertiaryContainer: AppColors.tertiaryContainer,
    onTertiaryContainer: AppColors.primaryPurpleDark,
    error: AppColors.error,
    onError: AppColors.white,
    errorContainer: AppColors.errorContainer,
    onErrorContainer: AppColors.primaryPurpleDark,
    surface: AppColors.white,
    onSurface: AppColors.grey900,
    surfaceContainerHighest: AppColors.grey100,
    onSurfaceVariant: AppColors.grey700,
    outline: AppColors.grey400,
    outlineVariant: AppColors.grey300,
    shadow: AppColors.shadowMedium,
    scrim: AppColors.black.withValues(alpha: 0.5),
    inverseSurface: AppColors.grey900,
    onInverseSurface: AppColors.grey50,
    inversePrimary: AppColors.primaryPurpleLight,
  );

  /// Dark color scheme
  static ColorScheme get _darkColorScheme => ColorScheme.dark(
    primary: AppColors.primaryPurpleLight,
    onPrimary: AppColors.primaryPurpleDark,
    primaryContainer: AppColors.primaryPurpleDark,
    onPrimaryContainer: AppColors.purpleContainer,
    secondary: AppColors.secondary,
    onSecondary: AppColors.white,
    secondaryContainer: const Color(0xFF7C2D5F),
    onSecondaryContainer: AppColors.secondaryContainer,
    tertiary: AppColors.tertiary,
    onTertiary: AppColors.white,
    tertiaryContainer: const Color(0xFF164E63),
    onTertiaryContainer: AppColors.tertiaryContainer,
    error: const Color(0xFFFF5449),
    onError: const Color(0xFF690005),
    errorContainer: const Color(0xFF93000A),
    onErrorContainer: AppColors.errorContainer,
    surface: AppColors.grey900,
    onSurface: AppColors.grey50,
    surfaceContainerHighest: AppColors.grey800,
    onSurfaceVariant: AppColors.grey300,
    outline: AppColors.grey600,
    outlineVariant: AppColors.grey700,
    shadow: AppColors.black.withValues(alpha: 0.5),
    scrim: AppColors.black.withValues(alpha: 0.7),
    inverseSurface: AppColors.grey100,
    onInverseSurface: AppColors.grey900,
    inversePrimary: AppColors.primaryPurple,
  );

  // ============================================================================
  // Light Theme
  // ============================================================================

  /// Complete light theme configuration
  static ThemeData get light {
    final colorScheme = _lightColorScheme;
    final textTheme = AppTypography.createTextTheme(
      color: colorScheme.onSurface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: colorScheme.surface,

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: AppSpacing.elevation1,
        titleTextStyle: AppTypography.titleLarge.copyWith(
          color: colorScheme.onSurface,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
          side: BorderSide(
            color: colorScheme.outlineVariant,
            width: AppSpacing.borderWidthThin,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.all(AppSpacing.sm),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: AppSpacing.elevation1,
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
          ),
          textStyle: AppTypography.button,
          minimumSize: Size(double.infinity, AppSpacing.buttonHeight),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
          ),
          textStyle: AppTypography.button,
          minimumSize: Size(double.infinity, AppSpacing.buttonHeight),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
          ),
          side: BorderSide(
            color: colorScheme.outline,
            width: AppSpacing.borderWidthThin,
          ),
          textStyle: AppTypography.button,
          minimumSize: Size(double.infinity, AppSpacing.buttonHeight),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
          ),
          textStyle: AppTypography.button,
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
          borderSide: BorderSide(
            color: colorScheme.outline,
            width: AppSpacing.borderWidthThin,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: AppSpacing.borderWidthMedium,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: AppSpacing.borderWidthThin,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: AppSpacing.borderWidthMedium,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        labelStyle: AppTypography.bodyMedium,
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        elevation: AppSpacing.elevation3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXXL),
        ),
        backgroundColor: colorScheme.surface,
        titleTextStyle: AppTypography.headlineSmall.copyWith(
          color: colorScheme.onSurface,
        ),
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),

      // Bottom Sheet Theme
      bottomSheetTheme: BottomSheetThemeData(
        elevation: AppSpacing.elevation3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusXXL),
          ),
        ),
        backgroundColor: colorScheme.surface,
        clipBehavior: Clip.antiAlias,
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: AppSpacing.borderWidthThin,
        space: AppSpacing.lg,
      ),

      // Icon Theme
      iconTheme: IconThemeData(
        color: colorScheme.onSurface,
        size: AppSpacing.iconSizeMedium,
      ),

      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
        ),
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: colorScheme.onInverseSurface,
        ),
        elevation: 4,
        showCloseIcon: true,
        closeIconColor: colorScheme.onInverseSurface,
        width: 344,
        insetPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
      ),
    );
  }

  // ============================================================================
  // Dark Theme
  // ============================================================================

  /// Complete dark theme configuration
  static ThemeData get dark {
    final colorScheme = _darkColorScheme;
    final textTheme = AppTypography.createTextTheme(
      color: colorScheme.onSurface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: colorScheme.surface,

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: AppSpacing.elevation1,
        titleTextStyle: AppTypography.titleLarge.copyWith(
          color: colorScheme.onSurface,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
          side: BorderSide(
            color: colorScheme.outlineVariant,
            width: AppSpacing.borderWidthThin,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.all(AppSpacing.sm),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: AppSpacing.elevation1,
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
          ),
          textStyle: AppTypography.button,
          minimumSize: Size(double.infinity, AppSpacing.buttonHeight),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
          ),
          textStyle: AppTypography.button,
          minimumSize: Size(double.infinity, AppSpacing.buttonHeight),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
          ),
          side: BorderSide(
            color: colorScheme.outline,
            width: AppSpacing.borderWidthThin,
          ),
          textStyle: AppTypography.button,
          minimumSize: Size(double.infinity, AppSpacing.buttonHeight),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
          ),
          textStyle: AppTypography.button,
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
          borderSide: BorderSide(
            color: colorScheme.outline,
            width: AppSpacing.borderWidthThin,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: AppSpacing.borderWidthMedium,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: AppSpacing.borderWidthThin,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: AppSpacing.borderWidthMedium,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        labelStyle: AppTypography.bodyMedium,
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        elevation: AppSpacing.elevation3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXXL),
        ),
        backgroundColor: colorScheme.surface,
        titleTextStyle: AppTypography.headlineSmall.copyWith(
          color: colorScheme.onSurface,
        ),
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),

      // Bottom Sheet Theme
      bottomSheetTheme: BottomSheetThemeData(
        elevation: AppSpacing.elevation3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusXXL),
          ),
        ),
        backgroundColor: colorScheme.surface,
        clipBehavior: Clip.antiAlias,
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: AppSpacing.borderWidthThin,
        space: AppSpacing.lg,
      ),

      // Icon Theme
      iconTheme: IconThemeData(
        color: colorScheme.onSurface,
        size: AppSpacing.iconSizeMedium,
      ),

      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
        ),
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: colorScheme.onInverseSurface,
        ),
        elevation: 4,
        showCloseIcon: true,
        closeIconColor: colorScheme.onInverseSurface,
        width: 344,
        insetPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
      ),
    );
  }
}
