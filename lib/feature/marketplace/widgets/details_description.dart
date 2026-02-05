import 'package:flutter/material.dart';

Widget buildDescription(String description) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Description',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),

      const SizedBox(height: 12),

      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFEFEFEF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          description,
          style: TextStyle(fontSize: 14, color: Color(0xFF6A6A6A), height: 1.5),
        ),
      ),
    ],
  );
}
