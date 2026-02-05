import 'package:flutter/material.dart';
import 'package:jdadzok/core/const/app_colors.dart';

ElevatedButton exploreScreenButton(
  String imageUrl,
  String textName,
  VoidCallback actions,
  bool isSelected,
) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: isSelected ? Color(0XFF2D55FF) : Colors.white,
      foregroundColor: isSelected ? Colors.white : Colors.black,
      side: BorderSide(width: 1, color: AppColors.primaryColor),
    ),
    onPressed: actions,
    child: Row(
      children: [
        Image.asset(imageUrl, width: 20, height: 20),
        SizedBox(width: 6),
        Text(textName),
      ],
    ),
  );
}
