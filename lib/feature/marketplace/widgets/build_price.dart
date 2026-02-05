import 'package:flutter/material.dart';

Widget buildPrice(double price) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: const Color(0xFFF0F8FF),
      borderRadius: BorderRadius.circular(15),
    ),
    child: Text(
      '\$$price',
      style: const TextStyle(
        fontSize: 14,
        letterSpacing: 0.5,
        fontWeight: FontWeight.bold,
        color: Color(0xFF4285F4),
      ),
    ),
  );
}
