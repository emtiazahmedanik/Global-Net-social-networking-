import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/const/app_colors.dart';
import 'package:jdadzok/core/const/image_path.dart';
import 'package:jdadzok/feature/edit_profile/controller/edit_profile_screen_controller.dart';
import 'package:jdadzok/feature/personal_view/widgets/add_profile_picture_button.dart';

class EditProfilePhoto extends StatelessWidget {
  EditProfilePhoto({super.key});

  final EditProfileScreenController controller =
      Get.find<EditProfileScreenController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            // Profile Image with borders
            Container(
              margin: EdgeInsets.only(top: 100), // white border
              padding: EdgeInsets.all(3), // white border
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Container(
                padding: EdgeInsets.all(5), // green border
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: Container(
                  padding: EdgeInsets.all(3), // inner white padding
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Obx(() {
                    // highest priority - picked image
                    if (controller.profileImage.value != null) {
                      return CircleAvatar(
                        radius: 50,
                        backgroundImage: FileImage(
                          controller.profileImage.value!,
                        ),
                      );
                    }

                    // second - server avatar
                    if (controller.profile.value?.data?.avatarUrl != null) {
                      return CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                          controller.profile.value!.data!.avatarUrl!,
                          
                        ),
                      );
                    }

                    // default fallback
                    return const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage(ImagePath.activeUserImage),
                    );
                  }),
                ),
              ),
            ),

            // Positioned blue add button
            AddProfilePictureButton(
              isAddStory: false,
              boxDecoration: BoxDecoration(
                color: AppColors.iconBackgroundColor,
                borderRadius: BorderRadius.circular(18),
                shape: BoxShape.rectangle,
              ),
              icons: Icons.camera_alt_outlined,
              text: "Edit",
              //color: AppColors.iconBackgroundColor,
              iconColor: Colors.black,
              onImagePicked: (File file) {
                controller.profileImage.value = file;
              },
            ),
          ],
        ),
      ],
    );
  }
}
