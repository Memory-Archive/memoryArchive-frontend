import 'package:flutter/material.dart';

import '../themes/app_colors.dart';
import '../themes/app_spacing.dart';
import '../themes/app_text_styles.dart';
import '../validation/validators.dart';

/// Text field with its label above it, as in the designs.
///
/// * [validator] runs as the user types ([AutovalidateMode.onUserInteraction])
///   and again when the form is submitted.
/// * [serverError] shows a message from the backend under the field (for
///   example "This email is already registered"). Clear it when the user
///   types again.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.hint,
    this.helper,
    this.validator,
    this.serverError,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.obscureText = false,
    this.suffix,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.maxLength,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final String? helper;
  final Validator? validator;
  final String? serverError;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final bool obscureText;
  final Widget? suffix;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: AppTextStyles.label()),
        AppGap.h6,
        TextFormField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          autofillHints: autofillHints,
          obscureText: obscureText,
          enableSuggestions: !obscureText,
          autocorrect: !obscureText,
          maxLength: maxLength,
          validator: validator,
          forceErrorText: serverError,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          style: AppTextStyles.body(size: 16),
          cursorColor: AppColors.green,
          decoration: InputDecoration(
            hintText: hint,
            helperText: helper,
            suffixIcon: suffix,
            counterText: '',
          ),
        ),
      ],
    );
  }
}

/// The eye button inside password fields.
class PasswordVisibilityButton extends StatelessWidget {
  const PasswordVisibilityButton({
    super.key,
    required this.obscured,
    required this.onPressed,
    this.plural = false,
  });

  final bool obscured;
  final VoidCallback onPressed;

  /// "Show passwords" when one button controls two fields.
  final bool plural;

  @override
  Widget build(BuildContext context) {
    final noun = plural ? 'passwords' : 'password';
    return IconButton(
      tooltip: obscured ? 'Show $noun' : 'Hide $noun',
      onPressed: onPressed,
      color: AppColors.muted,
      icon: Icon(obscured ? Icons.visibility_outlined : Icons.visibility_off_outlined),
    );
  }
}
