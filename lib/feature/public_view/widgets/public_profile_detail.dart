import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/feature/account_preferences/controller/expandable_text_controller.dart';
import 'package:jdadzok/feature/account_preferences/common_widget/details_text_widget.dart';
import 'package:jdadzok/feature/public_view/controller/public_profile_controller.dart';

class PublicProfileDetail extends StatelessWidget {
  PublicProfileDetail({super.key});

  final PublicProfileController controller =
      Get.find<PublicProfileController>();

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
            ],
          ),
          SizedBox(height: 12),
          Obx(
            () => ExpandableText(
              text: controller.profileData.value?.data.profile.bio ?? '',
              controller: ExpandableTextController(),
            ),
          ),
        ],
      ),
    );
  }
}
