import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/app_button.dart';
import '../../theme/app_spacing.dart';
import '../../providers/api_provider.dart';
import '../../providers/auth_state_provider.dart';
import '../../utils/logger.dart';
import '../settings/profile_screen.dart';
import '../home/main_scaffold_screen.dart';

/// OTP verification screen for email-based authentication.
class OtpVerificationScreen extends ConsumerStatefulWidget {
  const OtpVerificationScreen({super.key, required this.email});

  final String email;

  @override
  ConsumerState<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isLoading = false;
  bool _isResending = false;

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String get _otpCode =>
      _otpControllers.map((controller) => controller.text).join();

  Future<void> _verifyOtp() async {
    if (_otpCode.length != 6) {
      _showErrorSnackBar('Please enter complete OTP');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authApiService = ref.read(authApiServiceProvider);
      final result = await authApiService.verifyOtp(
        email: widget.email,
        otp: _otpCode,
      );

      if (!mounted) return;

      result.when(
        success: (data) async {
          final hasProfile = data['has_profile'] as bool? ?? false;
          final accessToken = data['access_token'] as String;

          // Store the token
          await ref.read(authStateProvider.notifier).setToken(accessToken);

          AppLogger.info('OTP verified. Has profile: $hasProfile');

          if (!mounted) return;

          if (!hasProfile) {
            // New user - redirect to profile creation
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) =>
                    ProfileScreen(isFirstTime: true, email: widget.email),
              ),
            );
          } else {
            // Existing user - redirect to home
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const MainScaffoldScreen(),
              ),
            );
          }
        },
        failure: (failure) {
          _showErrorSnackBar(failure.displayMessage);
        },
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _resendOtp() async {
    setState(() => _isResending = true);

    try {
      // Simulate resending OTP
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('OTP sent to ${widget.email}'),
          backgroundColor: Colors.green,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isResending = false);
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPaddingHorizontal,
              vertical: AppSpacing.screenPaddingVertical,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: AppSpacing.maxFormWidth),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Icon
                  Icon(
                    Icons.mark_email_read_outlined,
                    size: AppSpacing.iconSizeXLarge * 1.5,
                    color: colorScheme.primary,
                  ),
                  SizedBox(height: AppSpacing.lg),

                  // Title
                  Text(
                    'Enter Verification Code',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm),

                  // Subtitle
                  Text(
                    'We sent a 6-digit code to',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    widget.email,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xxl),

                  // OTP Input Fields
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(6, (index) {
                      return SizedBox(
                        width: 45,
                        height: 55,
                        child: TextField(
                          controller: _otpControllers[index],
                          focusNode: _focusNodes[index],
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          enabled: !_isLoading,
                          style: Theme.of(context).textTheme.headlineSmall,
                          decoration: InputDecoration(
                            counterText: '',
                            filled: true,
                            fillColor: colorScheme.surfaceContainerHighest,
                            contentPadding: EdgeInsets.zero,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (value) {
                            if (value.isNotEmpty && index < 5) {
                              _focusNodes[index + 1].requestFocus();
                            } else if (value.isEmpty && index > 0) {
                              _focusNodes[index - 1].requestFocus();
                            } else if (value.isNotEmpty && index == 5) {
                              _focusNodes[index].unfocus();
                              // Auto-verify when all digits entered
                              _verifyOtp();
                            }
                          },
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: AppSpacing.xxl),

                  // Verify Button
                  AppButton(
                    onPressed: _isLoading ? null : _verifyOtp,
                    label: 'Verify & Continue',
                    isLoading: _isLoading,
                  ),
                  SizedBox(height: AppSpacing.lg),

                  // Resend OTP
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Didn\'t receive the code? ',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: _isResending ? null : _resendOtp,
                        child: Text(_isResending ? 'Sending...' : 'Resend'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
