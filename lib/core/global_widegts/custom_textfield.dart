import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final bool isPassword;
  final bool obscureText;
  final TextEditingController controller;
  final TextInputType keyboardType;

  final VoidCallback? togglePassword;

  final bool readOnly;
  final VoidCallback? onTap;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final int maxLines;
  final bool enabled;

  final Widget? prefixIcon;
  final Widget? suffix;
  final bool isFilled;
  final Color? fillColor;
  final double borderRadius;
  final EdgeInsetsGeometry contentPadding;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isPassword = false,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.togglePassword,

    this.readOnly = false,
    this.onTap,
    this.textInputAction = TextInputAction.next,
    this.focusNode,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.onChanged,
    this.onSubmitted,
    this.maxLines = 1,
    this.enabled = true,

    this.prefixIcon,
    this.suffix,
    this.isFilled = false,
    this.fillColor,
    this.borderRadius = 50.0,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 18,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      readOnly: readOnly,
      onTap: onTap,
      enabled: enabled,
      obscureText: isPassword ? obscureText : false,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      textCapitalization: textCapitalization,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        hintText: hintText,
        filled: isFilled,
        fillColor: fillColor ?? Colors.grey.shade200,
        contentPadding: contentPadding,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        prefixIcon: prefixIcon,
        suffixIcon: isPassword
            ? (togglePassword != null
            ? IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: togglePassword,
        )
            : null)
            : suffix,
      ),
    );
  }
}

