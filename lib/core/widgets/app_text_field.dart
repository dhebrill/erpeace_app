import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Text field with a leading icon, optional helper text and inline errors.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.enabled = true,
    this.obscureText = false,
    this.autofocus = false,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.inputFormatters,
    this.autofillHints,
    this.validator,
  });

  final TextEditingController controller;
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final bool enabled;
  final bool obscureText;
  final bool autofocus;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      enabled: enabled,
      obscureText: obscureText,
      autofocus: autofocus,
      maxLines: obscureText ? 1 : maxLines,
      minLines: minLines,
      maxLength: maxLength,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      inputFormatters: inputFormatters,
      autofillHints: autofillHints,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        helperText: helperText,
        errorText: errorText,
        prefixIcon: prefixIcon == null
            ? null
            : Icon(
                prefixIcon,
                size: 20,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        suffixIcon: suffixIcon,
        counterText: '',
      ),
    );
  }
}
