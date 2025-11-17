import 'package:logger/logger.dart';

/// Application-wide logger for structured logging.
///
/// Provides different log levels (verbose, debug, info, warning, error, fatal)
/// and formats output based on environment.
class AppLogger {
  AppLogger._();

  static final _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
    level: Level.debug, // Change to Level.warning in production
  );

  static final _loggerNoStack = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
    level: Level.debug,
  );

  /// Log a verbose message (lowest level)
  static void verbose(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.t(message, error: error, stackTrace: stackTrace);
  }

  /// Log a debug message
  static void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  /// Log an info message
  static void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _loggerNoStack.i(message, error: error, stackTrace: stackTrace);
  }

  /// Log a warning message
  static void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Log an error message
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Log a fatal error message (highest level)
  static void fatal(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }

  /// Log an API request
  static void logRequest(String method, String url, {Map<String, dynamic>? data}) {
    _loggerNoStack.d('🌐 API Request: $method $url${data != null ? '\nData: $data' : ''}');
  }

  /// Log an API response
  static void logResponse(int statusCode, String url, {dynamic data}) {
    _loggerNoStack.d('✅ API Response: $statusCode $url${data != null ? '\nData: $data' : ''}');
  }

  /// Log an API error
  static void logApiError(String url, dynamic error) {
    _logger.e('❌ API Error: $url', error: error);
  }

  /// Log a navigation event
  static void logNavigation(String from, String to) {
    _loggerNoStack.i('🧭 Navigation: $from → $to');
  }

  /// Log a user action
  static void logUserAction(String action, {Map<String, dynamic>? data}) {
    _loggerNoStack.i('👤 User Action: $action${data != null ? '\nData: $data' : ''}');
  }

  /// Log a state change
  static void logStateChange(String state, {dynamic data}) {
    _loggerNoStack.d('🔄 State Change: $state${data != null ? '\nData: $data' : ''}');
  }
}
