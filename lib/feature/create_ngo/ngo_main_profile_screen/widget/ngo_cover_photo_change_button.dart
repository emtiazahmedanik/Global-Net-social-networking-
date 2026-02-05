import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/feature/account_preferences/common_widget/change_button.dart';
import 'package:jdadzok/feature/personal_view/controller/personal_profile_view_controller.dart';

/// This widget simply places the ChangeButton (your common widget)
/// and forwards the selected File to PersonalProfileViewController.coverImage
/// so that existing CoverPhotoProfileView (which depends on that controller)
/// reacts and shows the picked file.
///
/// We intentionally DO NOT touch CoverPhotoProfileView or PersonalProfilePhoto.
class NgoCoverPhotoChangeButton extends StatelessWidget {
  const NgoCoverPhotoChangeButton({super.key});

  @override
  Widget build(BuildContext context) {
    // Try to find an existing PersonalProfileViewController. If it's not
    // registered yet, create it so CoverPhotoProfileView can read from it.
    final PersonalProfileViewController personalController =
        Get.put(PersonalProfileViewController());

    return ChangeButton(
      onImagePicked: (File file) {
        // update the controller the CoverPhotoProfileView listens to
        personalController.coverImage.value = file;
      },
    );
  }
}
