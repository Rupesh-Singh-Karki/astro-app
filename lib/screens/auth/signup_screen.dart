import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/app_button.dart';
import '../../components/app_text_field.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_spacing.dart';
import '../../utils/validators.dart';
import '../../utils/logger.dart';

/// Signup screen for user registration.
class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final result = await ref
          .read(authProvider.notifier)
          .signUp(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            name: _nameController.text.trim(),
          );

      if (!mounted) return;

      result.when(
        success: (_) {
          AppLogger.info('Signup successful');
          Navigator.of(context).pop(); // Return to login or home
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
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
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
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(AppSpacing.xl),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Sign Up',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            SizedBox(height: AppSpacing.lg),

                            // Name Field
                            AppTextField(
                              label: 'Name',
                              controller: _nameController,
                              hintText: 'Enter your name',
                              prefixIcon: Icons.person_outlined,
                              validator: (value) =>
                                  Validators.required(value, 'Name'),
                              enabled: !_isLoading,
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
                            SizedBox(height: AppSpacing.lg),

                            // Password Field
                            AppTextField(
                              label: 'Password',
                              controller: _passwordController,
                              hintText: 'Enter your password',
                              prefixIcon: Icons.lock_outlined,
                              obscureText: _obscurePassword,
                              validator: Validators.password,
                              enabled: !_isLoading,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            SizedBox(height: AppSpacing.lg),

                            // Confirm Password Field
                            AppTextField(
                              label: 'Confirm Password',
                              controller: _confirmPasswordController,
                              hintText: 'Confirm your password',
                              prefixIcon: Icons.lock_outlined,
                              obscureText: _obscureConfirmPassword,
                              validator: (value) => Validators.matchesValue(
                                value,
                                _passwordController.text,
                                'Passwords',
                              ),
                              enabled: !_isLoading,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword =
                                        !_obscureConfirmPassword;
                                  });
                                },
                              ),
                            ),
                            SizedBox(height: AppSpacing.xxl),

                            // Signup Button
                            AppButton(
                              onPressed: _isLoading ? null : _handleSignup,
                              label: 'Create Account',
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
