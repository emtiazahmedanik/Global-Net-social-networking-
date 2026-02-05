import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/const/app_colors.dart';
import 'package:jdadzok/core/const/image_path.dart';
import 'package:jdadzok/core/style/global_text_style.dart';

Row notificationScreenHeader() {
  return Row(
    children: [
      GestureDetector(
        onTap: () {
          Get.back();
        },
        child: CircleAvatar(
          backgroundColor: AppColors.iconBackgroundColor,
          radius: 18,
          child: Icon(Icons.arrow_back, color: Colors.grey.shade600),
        ),
      ),
      Spacer(),
      Text(
        "Notification",
        style: globalTextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      Spacer(),
      GestureDetector(
        onTap: () {
          // Get.back();
        },
        child: CircleAvatar(
          backgroundColor: AppColors.iconBackgroundColor,
          radius: 18,
          child: SvgPicture.asset(ImagePath.settingsIcon),
        ),
      ),
      SizedBox(height: 20),
    ],
  );
}
