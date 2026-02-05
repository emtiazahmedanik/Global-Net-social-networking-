import 'package:flutter/material.dart';

class PublicInterestTab extends StatelessWidget {
  PublicInterestTab({super.key});

  final List<String> interests = ["🐱 Animals", "🎶 Comedy", "🎨 Art"];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 25,
      runSpacing: 12,
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.start,

      children: interests.map((item) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Text(
            item,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }
}
