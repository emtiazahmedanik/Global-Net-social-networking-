import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/feature/personal_view/controller/personal_profile_view_controller.dart';
import 'package:jdadzok/feature/personal_view/widgets/add_profile_picture_button.dart';

class PersonalProfilePhoto extends StatelessWidget {
  final bool showButton;

  PersonalProfilePhoto({super.key, this.showButton = true});

  final PersonalProfileViewController controller =
      Get.find<PersonalProfileViewController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              margin: EdgeInsets.only(top: 100),
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Obx(
                    () => controller.profileImage.value != null
                        ? CircleAvatar(
                            radius: 50,
                            backgroundImage: FileImage(
                              controller.profileImage.value!,
                            ),
                          )
                        : controller.profile.value?.data?.avatarUrl != null
                        ? CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                              controller.profile.value?.data?.avatarUrl ?? '',
                            ),
                          )
                        : CircleAvatar(child: Icon(Icons.person_2)),
                  ),
                ),
              ),
            ),

            if (showButton)
              AddProfilePictureButton(
                isAddStory: true,
                boxDecoration: BoxDecoration(
                  color: Color(0xff2D55FF),
                  shape: BoxShape.circle,
                ),
                icons: Icons.add,
                onImagePicked: (file) {
                  controller.profileImage.value = file;
                },
              ),
          ],
        ),
      ],
    );
  }
}
