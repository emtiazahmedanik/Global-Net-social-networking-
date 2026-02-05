// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

enum FieldType { name, email, password }

Widget editProfileCustomTextField({
  required TextEditingController controller,
  required String hintText,
  required FieldType fieldType,
  TextInputType keyboardType = TextInputType.text,
  bool obscureText = false,
  IconData? prefixIcon,
  int? maxline,
}) {
  return TextFormField(
    maxLines: maxline ?? 1,
    controller: controller,
    textInputAction: TextInputAction.next,
    keyboardType: keyboardType,
    obscureText: obscureText,
    decoration: InputDecoration(
      contentPadding: const EdgeInsets.symmetric(
        vertical: 14.0,
        horizontal: 16.0,
      ),
      fillColor: Colors.grey.shade300,
      filled: true,
      hintText: hintText,
      hintStyle: TextStyle(
        color: Colors.grey[600],
        fontWeight: FontWeight.normal,
        fontSize: 16,
      ),
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, color: Colors.grey[700])
          : null,
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    validator: (value) {
      final trimmed = value?.trim() ?? '';
      switch (fieldType) {
        case FieldType.name:
          return trimmed.isEmpty || trimmed.length < 3
              ? 'Name must be at least 3 characters'
              : null;
        case FieldType.email:
          final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
          return !emailRegex.hasMatch(trimmed)
              ? 'Enter a valid email address'
              : null;
        case FieldType.password:
          return trimmed.length < 6
              ? 'Password must be at least 6 characters'
              : null;
      }
    },
  );
}
