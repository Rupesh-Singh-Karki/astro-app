import 'dart:io';
import 'package:flutter/foundation.dart';

/// Application configuration for managing API URLs across environments
class AppConfig {
  AppConfig._();

  /// Production API URL - Update this with your deployed backend URL
  static const String productionApiUrl = 'https://astro-server-29.onrender.com';

  /// Development API URL for localhost
  static const String developmentApiUrl = 'http://localhost:8000';

  /// Android emulator API URL
  static const String androidEmulatorApiUrl =
      'https://astro-server-29.onrender.com';

  /// Environment mode - can be overridden with --dart-define=ENV=production
  /// Auto-detects: release builds = production, debug builds = development
  static String get environment {
    // If explicitly set via --dart-define, use that
    const envOverride = String.fromEnvironment('ENV');
    if (envOverride.isNotEmpty) {
      return envOverride;
    }

    // Otherwise, auto-detect: release build = production, debug = development
    return kReleaseMode ? 'production' : 'development';
  }

  /// Get the appropriate API URL based on environment and platform
  static String get apiUrl {
    if (environment == 'production') {
      return productionApiUrl;
    }

    // In development mode, use platform-specific URL
    if (Platform.isAndroid) {
      return androidEmulatorApiUrl;
    }
    return developmentApiUrl;
  }

  /// Check if running in production mode
  static bool get isProduction => environment == 'production';

  /// Check if running in development mode
  static bool get isDevelopment => environment == 'development';
}
