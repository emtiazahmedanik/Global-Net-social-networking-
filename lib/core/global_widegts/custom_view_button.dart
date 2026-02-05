import 'package:flutter/material.dart';

class CustomViewButton extends StatelessWidget {
  final String text;
  final Color color;
  final double width;
  final VoidCallback onPressed;
  final Color textColor;

  const CustomViewButton({
    super.key,
    required this.text,
    required this.color,
    required this.width,
    required this.onPressed,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Text(text, style: TextStyle(color: textColor, fontSize: 16)),
      ),
    );
  }
}
