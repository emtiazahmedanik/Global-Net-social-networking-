import 'package:flutter/material.dart';

class SocialAuthButton extends StatelessWidget {
  final String assetPath;
  final Color color;
  final VoidCallback onTap;

  const SocialAuthButton({
    super.key,
    required this.assetPath,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Image.asset(
          assetPath,
          height: 24,
          width: 24,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
