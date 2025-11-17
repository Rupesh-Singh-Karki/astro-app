/// Application-wide constant values.
///
/// Contains configuration, API endpoints, feature flags, and other
/// constant values used throughout the application.
class AppConstants {
  AppConstants._();

  // ============================================================================
  // Application Info
  // ============================================================================
  
  /// Application name
  static const String appName = 'TrustAstrology';
  
  /// Application tagline
  static const String appTagline = 'Your Cosmic Companion';
  
  /// Application version
  static const String appVersion = '1.0.0';
  
  /// Build number
  static const String buildNumber = '1';

  // ============================================================================
  // Environment Configuration
  // ============================================================================
  
  /// Environment type
  static const String environment = String.fromEnvironment(
    'ENV',
    defaultValue: 'development',
  );
  
  /// Is production environment
  static bool get isProduction => environment == 'production';
  
  /// Is development environment
  static bool get isDevelopment => environment == 'development';
  
  /// Is staging environment
  static bool get isStaging => environment == 'staging';

  // ============================================================================
  // API Configuration
  // ============================================================================
  
  /// Base API URL
  static String get baseApiUrl {
    switch (environment) {
      case 'production':
        return 'https://api.trustastrology.com';
      case 'staging':
        return 'https://staging-api.trustastrology.com';
      default:
        return 'https://dev-api.trustastrology.com';
    }
  }
  
  /// API version
  static const String apiVersion = 'v1';
  
  /// API timeout duration (in seconds)
  static const int apiTimeout = 30;
  
  /// API retry attempts
  static const int apiRetryAttempts = 3;

  // ============================================================================
  // Storage Keys (SharedPreferences/Hive)
  // ============================================================================
  
  /// User authentication token key
  static const String storageKeyAuthToken = 'auth_token';
  
  /// User email key
  static const String storageKeyUserEmail = 'user_email';
  
  /// User ID key
  static const String storageKeyUserId = 'user_id';
  
  /// Theme mode key
  static const String storageKeyThemeMode = 'theme_mode';
  
  /// Language code key
  static const String storageKeyLanguage = 'language_code';
  
  /// Onboarding completed key
  static const String storageKeyOnboardingCompleted = 'onboarding_completed';
  
  /// Last sync timestamp key
  static const String storageKeyLastSync = 'last_sync';

  // ============================================================================
  // Feature Flags
  // ============================================================================
  
  /// Enable dark mode
  static const bool featureDarkMode = true;
  
  /// Enable push notifications
  static const bool featurePushNotifications = true;
  
  /// Enable analytics
  static const bool featureAnalytics = false;
  
  /// Enable crash reporting
  static const bool featureCrashReporting = false;
  
  /// Enable biometric authentication
  static const bool featureBiometricAuth = false;

  // ============================================================================
  // Pagination & Limits
  // ============================================================================
  
  /// Default page size for paginated lists
  static const int defaultPageSize = 20;
  
  /// Maximum chat message length
  static const int maxChatMessageLength = 1000;
  
  /// Maximum file upload size (in MB)
  static const int maxFileUploadSizeMB = 10;
  
  /// Chat history retention days
  static const int chatHistoryRetentionDays = 90;

  // ============================================================================
  // Debounce & Throttle Durations
  // ============================================================================
  
  /// Search debounce duration (in milliseconds)
  static const int searchDebounceDuration = 500;
  
  /// Button tap throttle duration (in milliseconds)
  static const int buttonTapThrottleDuration = 300;
  
  /// Auto-save debounce duration (in milliseconds)
  static const int autoSaveDebounceDuration = 2000;

  // ============================================================================
  // Cache Configuration
  // ============================================================================
  
  /// Cache expiry duration (in hours)
  static const int cacheExpiryHours = 24;
  
  /// Maximum cache size (in MB)
  static const int maxCacheSizeMB = 100;

  // ============================================================================
  // Validation Rules
  // ============================================================================
  
  /// Minimum password length
  static const int minPasswordLength = 8;
  
  /// Maximum password length
  static const int maxPasswordLength = 128;
  
  /// Minimum username length
  static const int minUsernameLength = 3;
  
  /// Maximum username length
  static const int maxUsernameLength = 30;
  
  /// Email regex pattern
  static const String emailPattern =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

  // ============================================================================
  // Error Messages
  // ============================================================================
  
  /// Generic error message
  static const String errorGeneric = 'Something went wrong. Please try again.';
  
  /// Network error message
  static const String errorNetwork =
      'Network connection failed. Please check your internet connection.';
  
  /// Timeout error message
  static const String errorTimeout =
      'Request timed out. Please try again later.';
  
  /// Unauthorized error message
  static const String errorUnauthorized =
      'Session expired. Please login again.';
  
  /// Not found error message
  static const String errorNotFound = 'Resource not found.';
  
  /// Server error message
  static const String errorServer =
      'Server error occurred. Please try again later.';
  
  /// Validation error message
  static const String errorValidation = 'Please check your input and try again.';

  // ============================================================================
  // Success Messages
  // ============================================================================
  
  /// Login success message
  static const String successLogin = 'Welcome back!';
  
  /// Logout success message
  static const String successLogout = 'Logged out successfully.';
  
  /// Signup success message
  static const String successSignup =
      'Account created successfully! Welcome aboard.';
  
  /// Update success message
  static const String successUpdate = 'Updated successfully.';
  
  /// Delete success message
  static const String successDelete = 'Deleted successfully.';

  // ============================================================================
  // Date & Time Formats
  // ============================================================================
  
  /// Default date format (e.g., "Jan 15, 2024")
  static const String dateFormat = 'MMM dd, yyyy';
  
  /// Default time format (e.g., "2:30 PM")
  static const String timeFormat = 'h:mm a';
  
  /// Default date-time format (e.g., "Jan 15, 2024 2:30 PM")
  static const String dateTimeFormat = 'MMM dd, yyyy h:mm a';
  
  /// ISO date-time format (e.g., "2024-01-15T14:30:00")
  static const String isoDateTimeFormat = "yyyy-MM-dd'T'HH:mm:ss";

  // ============================================================================
  // External Links
  // ============================================================================
  
  /// Terms of service URL
  static const String urlTermsOfService = 'https://trustastrology.com/terms';
  
  /// Privacy policy URL
  static const String urlPrivacyPolicy = 'https://trustastrology.com/privacy';
  
  /// Support email
  static const String supportEmail = 'support@trustastrology.com';
  
  /// Help center URL
  static const String urlHelpCenter = 'https://help.trustastrology.com';

  // ============================================================================
  // Asset Paths
  // ============================================================================
  
  /// Logo asset path
  static const String assetLogo = 'assets/images/logo.png';
  
  /// Placeholder image path
  static const String assetPlaceholder = 'assets/images/placeholder.png';
  
  /// Onboarding images directory
  static const String assetOnboardingDir = 'assets/images/onboarding';
  
  /// Icons directory
  static const String assetIconsDir = 'assets/icons';

  // ============================================================================
  // Deep Link Configuration
  // ============================================================================
  
  /// App scheme for deep links
  static const String deepLinkScheme = 'trustastrology';
  
  /// Deep link host
  static const String deepLinkHost = 'app';

  // ============================================================================
  // Supported Languages
  // ============================================================================
  
  /// Default language code
  static const String defaultLanguageCode = 'en';
  
  /// Supported language codes
  static const List<String> supportedLanguageCodes = ['en', 'es', 'fr', 'hi'];
}
