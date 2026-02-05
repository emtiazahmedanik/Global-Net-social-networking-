import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/global_widegts/screen_header_row.dart';
import 'package:jdadzok/core/style/global_text_style.dart';
import 'package:jdadzok/feature/create_ngo/ngo_main_profile_screen/controller/ngo_main_profile_screen_controller.dart';
import 'package:jdadzok/feature/create_ngo/ngo_main_profile_screen/widget/ngo_cover_photo.dart';

import 'package:jdadzok/feature/create_ngo/ngo_main_profile_screen/widget/ngo_details2_widget.dart';
import 'package:jdadzok/feature/create_ngo/ngo_main_profile_screen/widget/ngo_profile_about_widget.dart';
import 'package:jdadzok/feature/create_ngo/ngo_main_profile_screen/widget/ngo_profile_photo.dart';
import 'package:jdadzok/feature/create_ngo/ngo_main_profile_screen/widget/ngo_profile_recent_widget.dart';
import 'package:jdadzok/feature/create_ngo/ngo_main_profile_screen/widget/ngo_user_details.dart';
import 'package:jdadzok/feature/create_ngo/ngo_profile_donation_screen/widget/ngo_donation_button_row_widget.dart';

class NgoProfileDonationScreen extends StatelessWidget {

  final bool isNgo;
  const NgoProfileDonationScreen({super.key, required this.isNgo});

  @override
  Widget build(BuildContext context) {
    final NgoMainProfileScreenController controller = Get.find<NgoMainProfileScreenController>();
    
    // Fetch data if not already loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.org.value == null && !controller.isLoading.value) {
        controller.fetchMyOrganization(isNgo: isNgo);
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Obx(() {
            if (controller.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }

            if (controller.error.value.isNotEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    controller.error.value,
                    style: globalTextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => controller.fetchMyOrganization(isNgo: isNgo),
                    child: Text('Retry'),
                  ),
                ],
              );
            }

            final org = controller.org.value;
            if (org == null) {
              return Center(
                child: Text(
                  isNgo ? 'No NGO found' : 'No Community found',
                  style: globalTextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              );
            }

            return SingleChildScrollView(
            child: Column(
              children: [
                ScreenHeaderRow(title: isNgo? "NGO Profile" : "Community Profile"),
                Stack(
                  children: [
                    NGOCoverPhoto(),
                    NgoProfilePhoto(showButton: false),
                  ],
                ),
                NGOUserDetails(
                    name: controller.displayName,
                  profileType: isNgo? 'NGO' : 'Community',
                    followingCount: controller.followingCount,
                    followersCount: controller.followersCount,
                    likesCount: controller.likesCount,
                ),
                SizedBox(height: 12,),
                  NgoDonationButtonRowWidget(isNgo: isNgo, org: org),
                SizedBox(height: 16),
                NgoDetails2Widget(),
                NgoProfileAboutWidget(),
                NgoProfileRecentWidget()
              ],
            ),
            );
          }),
        ),
      ),
    );
  }
}
