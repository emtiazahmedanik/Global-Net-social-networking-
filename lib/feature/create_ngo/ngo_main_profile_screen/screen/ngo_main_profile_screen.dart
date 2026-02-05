import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/global_widegts/screen_header_row.dart';
import 'package:jdadzok/feature/create_ngo/ngo_main_profile_screen/controller/ngo_main_profile_screen_controller.dart';
import 'package:jdadzok/feature/create_ngo/ngo_main_profile_screen/widget/ngo_cover_photo.dart';

import 'package:jdadzok/feature/create_ngo/ngo_main_profile_screen/widget/ngo_details2_widget.dart';
import 'package:jdadzok/feature/create_ngo/ngo_main_profile_screen/widget/ngo_profile_about_widget.dart';
import 'package:jdadzok/feature/create_ngo/ngo_main_profile_screen/widget/ngo_profile_button_row.dart';
import 'package:jdadzok/feature/create_ngo/ngo_main_profile_screen/widget/ngo_profile_photo.dart';

import 'package:jdadzok/feature/create_ngo/ngo_main_profile_screen/widget/ngo_user_details.dart';
import 'package:jdadzok/core/style/global_text_style.dart';
import 'package:jdadzok/feature/create_ngo/create_ngo_verify_screen/screen/create_ngo_verify_profile_screen.dart';
import 'package:jdadzok/feature/create_ngo/create_ngo_verify_screen/model/create_ngo_verify_model.dart';

class NgoMainProfileScreen extends StatelessWidget {
  final bool isNgo;
  final OrganizationModel? org;

  final NgoMainProfileScreenController ngoMainProfileScreenController = Get.put(
    NgoMainProfileScreenController(),
  );

  NgoMainProfileScreen({super.key, required this.isNgo, this.org});

  @override
  Widget build(BuildContext context) {
    // If org is passed, set it directly; otherwise fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (org != null) {
        ngoMainProfileScreenController.org.value = org;
      } else if (ngoMainProfileScreenController.org.value == null &&
          !ngoMainProfileScreenController.isLoading.value) {
        ngoMainProfileScreenController.fetchMyOrganization(isNgo: isNgo);
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Obx(() {
            if (ngoMainProfileScreenController.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }

            if (ngoMainProfileScreenController.error.value.isNotEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    ngoMainProfileScreenController.error.value,
                    style: globalTextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => ngoMainProfileScreenController.fetchMyOrganization(isNgo: isNgo),
                    child: Text('Retry'),
                  ),
                ],
              );
            }

            final OrganizationModel? org = ngoMainProfileScreenController.org.value;

            if (org == null) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isNgo ? 'No NGO found' : 'No Community found',
                    style: globalTextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      // go to create/edit screen (existingOrg null => create)
                      Get.to(() => CreateNgoVerifyProfileScreen(isNgo: isNgo));
                    },
                    child: Text(isNgo ? 'Create NGO' : 'Create Community'),
                  ),
                ],
              );
            }

            // UI with dynamic data passed to widgets
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ScreenHeaderRow(title: isNgo ? "NGO Profile" : "Community Profile"),
                  Stack(
                    children: [
                      NGOCoverPhoto(), // uses controller internally
                      NgoProfilePhoto(showButton: false),
                    ],
                  ),
                  SizedBox(height: 8),
                  NGOUserDetails(
                    name: ngoMainProfileScreenController.displayName,
                    profileType: isNgo ? 'NGO' : 'Community',
                    followingCount: ngoMainProfileScreenController.followingCount,
                    followersCount: ngoMainProfileScreenController.followersCount,
                    likesCount: ngoMainProfileScreenController.likesCount,
                  ),
                  SizedBox(height: 16),
                  NgoProfileButtonRow(isNgo: isNgo),
                  SizedBox(height: 16),
                  NgoDetails2Widget(),
                  SizedBox(height: 12),
                  NgoProfileAboutWidget(),
                  SizedBox(height: 12),
                  // NgoProfileRecentWidget(),
                  
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
