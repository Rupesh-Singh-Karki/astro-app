import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';
import '../services/auth_api_service.dart';
import '../services/chat_api_service.dart';

/// Provider for the base API service
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

/// Provider for the auth API service
final authApiServiceProvider = Provider<AuthApiService>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return AuthApiService(apiService);
});

/// Provider for the chat API service
final chatApiServiceProvider = Provider<ChatApiService>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return ChatApiService(apiService);
});
