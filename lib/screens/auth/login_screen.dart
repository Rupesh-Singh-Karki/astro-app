import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/app_button.dart';
import '../../components/app_text_field.dart';
import '../../theme/app_spacing.dart';
import '../../utils/validators.dart';
import '../../utils/logger.dart';
import '../../providers/api_provider.dart';
import 'otp_verification_screen.dart';

/// Login screen for user authentication.
///
/// Provides email-based authentication with OTP verification.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSendOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authApiService = ref.read(authApiServiceProvider);
      final result = await authApiService.sendOtp(_emailController.text.trim());

      if (!mounted) return;

      result.when(
        success: (data) {
          AppLogger.info('OTP sent to ${_emailController.text.trim()}');

          // Navigate to OTP verification screen
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  OtpVerificationScreen(email: _emailController.text.trim()),
            ),
          );
        },
        failure: (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(failure.displayMessage),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        },
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPaddingHorizontal,
              vertical: AppSpacing.screenPaddingVertical,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: AppSpacing.maxFormWidth),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // App Logo/Title
                    Icon(
                      Icons.auto_awesome,
                      size: AppSpacing.iconSizeXLarge * 1.5,
                      color: colorScheme.primary,
                    ),
                    SizedBox(height: AppSpacing.md),
                    Text(
                      'TrustAstrology',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      'Your Cosmic Companion',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: AppSpacing.xxxl),

                    // Login Card
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(AppSpacing.xl),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Sign In or Create Account',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            SizedBox(height: AppSpacing.sm),
                            Text(
                              'Enter your email to receive a verification code',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                            ),
                            SizedBox(height: AppSpacing.lg),

                            // Email Field
                            AppTextField(
                              label: 'Email',
                              controller: _emailController,
                              hintText: 'Enter your email',
                              prefixIcon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              validator: Validators.email,
                              enabled: !_isLoading,
                            ),
                            SizedBox(height: AppSpacing.xxl),

                            // Send OTP Button
                            AppButton(
                              onPressed: _isLoading ? null : _handleSendOtp,
                              label: 'Send Verification Code',
                              isLoading: _isLoading,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
