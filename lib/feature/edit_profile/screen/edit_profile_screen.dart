import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/const/app_colors.dart';
import 'package:jdadzok/core/global_widegts/custom_button.dart';
import 'package:jdadzok/core/style/global_text_style.dart';
import 'package:jdadzok/feature/edit_profile/controller/edit_profile_screen_controller.dart';

import 'package:jdadzok/feature/edit_profile/widget/edit_profile_cover_photo.dart';
import 'package:jdadzok/feature/edit_profile/widget/edit_profile_text_form.dart';

import 'package:jdadzok/feature/account_preferences/common_widget/change_button.dart';
import 'package:jdadzok/feature/account_preferences/common_widget/cover_photo.dart';

// ignore: must_be_immutable
class EditProfileScreen extends StatelessWidget {
  EditProfileScreenController editProfileScreenController = Get.put(
    EditProfileScreenController(),
  );
  EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: CircleAvatar(
                      backgroundColor: Color(0XFFEFEFEF),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                  Spacer(),
                  Text(
                    "Edit Profile",
                    style: globalTextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
            SizedBox(height: 19),
            //Obx(()=>editProfileCoverHeader(context),),
            Stack(
              clipBehavior: Clip.none,
              children: [
                CoverPhoto(),

                // Change button at bottom right
                ChangeButton(
                  onImagePicked: (File file) {
                    editProfileScreenController.coverImage.value = file;
                  },
                ),
                // profile picture
                EditProfilePhoto(),
                //ProfilePhoto(),
              ],
            ),
            //editProfileCoverHeader(context),
            SizedBox(height: 20),
            Expanded(child: EditProfileTextForm()),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: "Save",
                  onPressed: () {
                    editProfileScreenController.onClickSave();
                  },
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // TextStyle editProfileTextStyle() {
  //   return TextStyle(
  //     fontFamily: "Inter",
  //     fontSize: 16,
  //     fontWeight: FontWeight.w400,
  //   );
  // }
}
