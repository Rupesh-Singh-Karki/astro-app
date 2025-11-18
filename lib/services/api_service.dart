import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../utils/logger.dart';
import '../config/app_config.dart';

/// Base API service for making HTTP requests
class ApiService {
  /// Get base URL from AppConfig (supports dev/production environments)
  static String get baseUrl => AppConfig.apiUrl;

  String? _accessToken;

  /// Set the access token for authenticated requests
  void setAccessToken(String? token) {
    _accessToken = token;
    AppLogger.debug('Access token ${token != null ? 'set' : 'cleared'}');
  }

  /// Get current access token
  String? get accessToken => _accessToken;

  /// Get common headers
  Map<String, String> _getHeaders({bool includeAuth = false}) {
    final headers = {'Content-Type': 'application/json'};

    if (includeAuth && _accessToken != null) {
      headers['Authorization'] = 'Bearer $_accessToken';
    }

    return headers;
  }

  /// Make a GET request
  Future<http.Response> get(
    String endpoint, {
    bool requiresAuth = false,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    AppLogger.debug('GET $url');

    try {
      final response = await http
          .get(url, headers: _getHeaders(includeAuth: requiresAuth))
          .timeout(const Duration(seconds: 30));

      AppLogger.debug('Response status: ${response.statusCode}');
      return response;
    } on SocketException {
      AppLogger.error('Network error: Cannot connect to server');
      throw Exception(
        'Cannot connect to server. Please check if the backend is running at $baseUrl',
      );
    } on http.ClientException catch (e) {
      AppLogger.error('HTTP Client error', e);
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      AppLogger.error('GET request failed', e);
      rethrow;
    }
  }

  /// Make a POST request
  Future<http.Response> post(
    String endpoint, {
    required Map<String, dynamic> body,
    bool requiresAuth = false,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    AppLogger.debug('POST $url');
    AppLogger.debug('Body: ${jsonEncode(body)}');

    try {
      final response = await http
          .post(
            url,
            headers: _getHeaders(includeAuth: requiresAuth),
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30));

      AppLogger.debug('Response status: ${response.statusCode}');
      return response;
    } on SocketException {
      AppLogger.error('Network error: Cannot connect to server');
      throw Exception(
        'Cannot connect to server. Please check if the backend is running at $baseUrl',
      );
    } on http.ClientException catch (e) {
      AppLogger.error('HTTP Client error', e);
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      AppLogger.error('POST request failed', e);
      rethrow;
    }
  }

  /// Make a PUT request
  Future<http.Response> put(
    String endpoint, {
    required Map<String, dynamic> body,
    bool requiresAuth = false,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    AppLogger.debug('PUT $url');

    try {
      final response = await http
          .put(
            url,
            headers: _getHeaders(includeAuth: requiresAuth),
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30));

      AppLogger.debug('Response status: ${response.statusCode}');
      return response;
    } on SocketException {
      AppLogger.error('Network error: Cannot connect to server');
      throw Exception(
        'Cannot connect to server. Please check if the backend is running at $baseUrl',
      );
    } on http.ClientException catch (e) {
      AppLogger.error('HTTP Client error', e);
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      AppLogger.error('PUT request failed', e);
      rethrow;
    }
  }

  /// Make a DELETE request
  Future<http.Response> delete(
    String endpoint, {
    bool requiresAuth = false,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    AppLogger.debug('DELETE $url');

    try {
      final response = await http
          .delete(url, headers: _getHeaders(includeAuth: requiresAuth))
          .timeout(const Duration(seconds: 30));

      AppLogger.debug('Response status: ${response.statusCode}');
      return response;
    } on SocketException {
      AppLogger.error('Network error: Cannot connect to server');
      throw Exception(
        'Cannot connect to server. Please check if the backend is running at $baseUrl',
      );
    } on http.ClientException catch (e) {
      AppLogger.error('HTTP Client error', e);
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      AppLogger.error('DELETE request failed', e);
      rethrow;
    }
  }
}
