/// Application spacing and sizing constants following 8dp grid system.
///
/// Provides consistent spacing, sizing, and layout measurements
/// throughout the application for better visual harmony.
class AppSpacing {
  AppSpacing._();

  // ============================================================================
  // Base Spacing Unit
  // ============================================================================

  /// Base spacing unit (8dp) - all spacing derives from this
  static const double base = 8.0;

  // ============================================================================
  // Spacing Scale (8dp grid)
  // ============================================================================

  /// Extra extra small spacing - 2dp
  static const double xxs = base * 0.25; // 2

  /// Extra small spacing - 4dp
  static const double xs = base * 0.5; // 4

  /// Small spacing - 8dp
  static const double sm = base; // 8

  /// Medium spacing - 12dp
  static const double md = base * 1.5; // 12

  /// Large spacing - 16dp
  static const double lg = base * 2; // 16

  /// Extra large spacing - 20dp
  static const double xl = base * 2.5; // 20

  /// Extra extra large spacing - 24dp
  static const double xxl = base * 3; // 24

  /// Triple extra large spacing - 32dp
  static const double xxxl = base * 4; // 32

  /// Huge spacing - 40dp
  static const double huge = base * 5; // 40

  /// Massive spacing - 48dp
  static const double massive = base * 6; // 48

  // ============================================================================
  // Padding Presets
  // ============================================================================

  /// Screen edge padding (horizontal) - 16dp
  static const double screenPaddingHorizontal = lg;

  /// Screen edge padding (vertical) - 20dp
  static const double screenPaddingVertical = xl;

  /// Card padding - 16dp
  static const double cardPadding = lg;

  /// Dialog padding - 24dp
  static const double dialogPadding = xxl;

  /// Bottom sheet padding - 20dp
  static const double bottomSheetPadding = xl;

  // ============================================================================
  // Component Sizes
  // ============================================================================

  /// Button height - 48dp
  static const double buttonHeight = massive;

  /// Button height small - 40dp
  static const double buttonHeightSmall = huge;

  /// Button height large - 56dp
  static const double buttonHeightLarge = base * 7;

  /// Input field height - 56dp
  static const double inputHeight = base * 7;

  /// Icon size small - 16dp
  static const double iconSizeSmall = lg;

  /// Icon size medium - 24dp
  static const double iconSizeMedium = xxl;

  /// Icon size large - 32dp
  static const double iconSizeLarge = xxxl;

  /// Icon size extra large - 48dp
  static const double iconSizeXLarge = massive;

  /// Avatar size small - 32dp
  static const double avatarSizeSmall = xxxl;

  /// Avatar size medium - 40dp
  static const double avatarSizeMedium = huge;

  /// Avatar size large - 56dp
  static const double avatarSizeLarge = base * 7;

  /// Avatar size extra large - 80dp
  static const double avatarSizeXLarge = base * 10;

  // ============================================================================
  // Border Radius
  // ============================================================================

  /// Extra small radius - 4dp
  static const double radiusXS = xs;

  /// Small radius - 8dp
  static const double radiusSM = sm;

  /// Medium radius - 12dp
  static const double radiusMD = md;

  /// Large radius - 16dp
  static const double radiusLG = lg;

  /// Extra large radius - 20dp
  static const double radiusXL = xl;

  /// Extra extra large radius - 24dp
  static const double radiusXXL = xxl;

  /// Circular radius
  static const double radiusCircular = 999.0;

  // ============================================================================
  // List Item Heights
  // ============================================================================

  /// List item height small - 48dp
  static const double listItemHeightSmall = massive;

  /// List item height medium - 56dp
  static const double listItemHeightMedium = base * 7;

  /// List item height large - 72dp
  static const double listItemHeightLarge = base * 9;

  // ============================================================================
  // Elevation / Shadows
  // ============================================================================

  /// No elevation
  static const double elevation0 = 0;

  /// Low elevation - 2dp
  static const double elevation1 = 2;

  /// Medium elevation - 4dp
  static const double elevation2 = 4;

  /// High elevation - 8dp
  static const double elevation3 = 8;

  /// Extra high elevation - 16dp
  static const double elevation4 = 16;

  /// Maximum elevation - 24dp
  static const double elevation5 = 24;

  // ============================================================================
  // Divider / Border Widths
  // ============================================================================

  /// Thin border - 1dp
  static const double borderWidthThin = 1.0;

  /// Medium border - 2dp
  static const double borderWidthMedium = 2.0;

  /// Thick border - 4dp
  static const double borderWidthThick = 4.0;

  // ============================================================================
  // Layout Breakpoints (for responsive design)
  // ============================================================================

  /// Mobile breakpoint - 600dp
  static const double breakpointMobile = 600;

  /// Tablet breakpoint - 900dp
  static const double breakpointTablet = 900;

  /// Desktop breakpoint - 1200dp
  static const double breakpointDesktop = 1200;

  /// Large desktop breakpoint - 1536dp
  static const double breakpointLargeDesktop = 1536;

  // ============================================================================
  // Maximum Widths
  // ============================================================================

  /// Maximum content width for readability - 720dp
  static const double maxContentWidth = 720;

  /// Maximum form width - 480dp
  static const double maxFormWidth = 480;

  /// Maximum card width - 360dp
  static const double maxCardWidth = 360;

  // ============================================================================
  // Animation Durations (in milliseconds)
  // ============================================================================

  /// Extra fast animation - 100ms
  static const int durationFast = 100;

  /// Normal animation - 200ms
  static const int durationNormal = 200;

  /// Medium animation - 300ms
  static const int durationMedium = 300;

  /// Slow animation - 500ms
  static const int durationSlow = 500;
}
