import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jdadzok/core/style/global_text_style.dart';

Widget bottomCatagoryRow({
  required String categoryName,
  required String imagePath,
  required Color bgColor,
  required VoidCallback categoryAction,
  bool? isSwitchButton,
  ValueChanged<bool>? switchButtonAction,
  bool? switchValue,
}) {
  return GestureDetector(
    onTap: categoryAction,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 10,
        children: [
          CircleAvatar(
            backgroundColor: bgColor, //,
            child: SvgPicture.asset(imagePath), //
          ),
          Text(
            categoryName,
            style: globalTextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          if (isSwitchButton == true) ...[
            Spacer(),
            Transform.scale(
                scale: 0.6,
                child: Switch(value: switchValue!, onChanged: switchButtonAction),
              ),
            
          ],
        ],
      ),
    ),
  );
}

