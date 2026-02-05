// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:jdadzok/core/const/app_colors.dart';
import 'package:jdadzok/feature/account_preferences/common_widget/change_button.dart';
import 'package:jdadzok/feature/account_preferences/common_widget/cover_photo.dart';

Stack editProfileCoverHeader() {
  return Stack(
    clipBehavior: Clip.none,
    children: [
      CoverPhoto(),

      // Change button at bottom right
      ChangeButton(),
      //Edit button
      Positioned(
        bottom: 12,
        left: 0,
        right: 0,
        child: Align(
          alignment: Alignment.center,
          child: SizedBox(
            height: 32,
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.9),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                onPressed: () {},
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.camera_alt_rounded,
                      size: 16,
                      color: AppColors.primaryColor,
                    ),
                    SizedBox(width: 5),
                    Text(
                      "Edit",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
