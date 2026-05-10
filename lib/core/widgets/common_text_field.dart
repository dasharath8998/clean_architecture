import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CommonTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final String? errorText;
  final bool obscureText;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLength;
  final bool enabled;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;

  const CommonTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.errorText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.onChanged,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLength,
    this.enabled = true,
    this.focusNode,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      validator: validator,
      enabled: enabled,
      focusNode: focusNode,
      textInputAction: textInputAction,
      maxLength: maxLength,
      buildCounter: maxLength != null
          ? (
              context, {
              required currentLength,
              required isFocused,
              maxLength,
            }) =>
                null // hide counter
          : null,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        errorText: errorText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
