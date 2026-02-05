import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/feature/account_preferences/controller/expandable_text_controller.dart';
import 'package:jdadzok/feature/account_preferences/common_widget/details_text_widget.dart';
import 'package:jdadzok/feature/edit_profile/screen/edit_profile_screen.dart';
import 'package:jdadzok/feature/personal_view/controller/personal_profile_view_controller.dart';

class DetailsWidget extends StatelessWidget {
  DetailsWidget({super.key});

  final PersonalProfileViewController controller =
      Get.find<PersonalProfileViewController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                ' Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  height: 1.8,
                  color: Color(0xff000000),
                ),
              ),
              Spacer(),
              GestureDetector(
                child: Text(
                  'Edit',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff000000),
                  ),
                ),
                onTap: () {
                  Get.to(()=> EditProfileScreen());
                  debugPrint('Edit tapped');
                },
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xff000000)),
            ],
          ),
          SizedBox(height: 12),
          Obx(
            () => ExpandableText(
              text: controller.profile.value?.data?.bio ?? '',
              controller: ExpandableTextController(),
            ),
          ),
        ],
      ),
    );
  }
}
