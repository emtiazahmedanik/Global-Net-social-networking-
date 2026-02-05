import 'package:flutter/material.dart';

TextFormField textField(
  TextEditingController teController,
  String hintText, {
  String? Function(String?)? validator,
  bool obscure = false,
}) {
  return TextFormField(
    controller: teController,
    obscureText: obscure,
    textInputAction: TextInputAction.next,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
      fillColor: Colors.grey.shade300,
      filled: true,
      hintText: hintText,
      hintStyle: TextStyle(
        color: Colors.grey[600],
        fontWeight: FontWeight.normal,
        fontSize: 16,
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    validator: validator ?? (value) {
      if (value == null || value.isEmpty || value.length < 6) {
        return 'must be at least 6 characters';
      }
      return null;
    },
  );
}
