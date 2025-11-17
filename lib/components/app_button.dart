import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';

/// A custom primary button widget with consistent styling.
///
/// This button follows the app's design system and provides
/// a consistent look and feel across the application.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.isLoading = false,
    this.isFullWidth = true,
    this.variant = AppButtonVariant.filled,
    this.icon,
  });

  final VoidCallback? onPressed;
  final String label;
  final bool isLoading;
  final bool isFullWidth;
  final AppButtonVariant variant;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final buttonChild = isLoading
        ? SizedBox(
            height: AppSpacing.iconSizeMedium,
            width: AppSpacing.iconSizeMedium,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          )
        : Row(
            mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: AppSpacing.iconSizeSmall),
                SizedBox(width: AppSpacing.xs),
              ],
              Text(label),
            ],
          );

    final effectiveOnPressed = isLoading ? null : onPressed;

    switch (variant) {
      case AppButtonVariant.filled:
        return SizedBox(
          width: isFullWidth ? double.infinity : null,
          child: FilledButton(
            onPressed: effectiveOnPressed,
            child: buttonChild,
          ),
        );
      
      case AppButtonVariant.outlined:
        return SizedBox(
          width: isFullWidth ? double.infinity : null,
          child: OutlinedButton(
            onPressed: effectiveOnPressed,
            child: buttonChild,
          ),
        );
      
      case AppButtonVariant.text:
        return SizedBox(
          width: isFullWidth ? double.infinity : null,
          child: TextButton(
            onPressed: effectiveOnPressed,
            child: buttonChild,
          ),
        );
      
      case AppButtonVariant.elevated:
        return SizedBox(
          width: isFullWidth ? double.infinity : null,
          child: ElevatedButton(
            onPressed: effectiveOnPressed,
            child: buttonChild,
          ),
        );
    }
  }
}

/// Button variant types
enum AppButtonVariant {
  filled,
  outlined,
  text,
  elevated,
}
