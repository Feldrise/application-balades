import 'package:flutter/material.dart';

/// A custom styled text form field for the admin login interface
class AdminLoginTextField extends StatelessWidget {
  const AdminLoginTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.onFieldSubmitted,
  });

  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final void Function(String)? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
      style: theme.textTheme.bodyLarge,
      decoration: InputDecoration(labelText: labelText, hintText: hintText, prefixIcon: prefixIcon, suffixIcon: suffixIcon),
    );
  }
}
