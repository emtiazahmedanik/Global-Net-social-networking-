import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/feature/account_preferences/widgets/public_profile_follower.dart';
import 'package:jdadzok/feature/account_preferences/common_widget/cover_photo.dart';
import 'package:jdadzok/feature/public_view/widgets/public_about_card.dart';
import 'package:jdadzok/feature/public_view/widgets/public_interest_tab.dart';
import 'package:jdadzok/feature/public_view/widgets/public_interest_widget.dart';
import 'package:jdadzok/feature/public_view/widgets/public_profile_action_button.dart';
import 'package:jdadzok/feature/public_view/widgets/public_profile_detail.dart';
import 'package:jdadzok/feature/public_view/widgets/public_profile_photo.dart';
import 'package:jdadzok/feature/public_view/widgets/public_profile_user_detail.dart';
import 'package:jdadzok/feature/public_view/widgets/public_recent_post.dart';
import 'package:jdadzok/feature/public_view/controller/public_profile_controller.dart';

class PublicProfileView extends StatefulWidget {
  final String userId;
  const PublicProfileView({super.key, required this.userId});

  @override
  State<PublicProfileView> createState() => _PublicProfileViewState();
}

class _PublicProfileViewState extends State<PublicProfileView> {
  late final PublicProfileController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(PublicProfileController());
    controller.fetchUserProfile(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(controller.errorMessage.value),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.fetchUserProfile(widget.userId),
                  child: Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (controller.profileData.value == null) {
          return Center(child: Text('No profile data available'));
        }

        final profile = controller.profileData.value!.data.profile;

        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 16),
                      InkWell(
                        child: const Icon(Icons.arrow_back),
                        onTap: () {
                          Get.back();
                        },
                      ),
                      const SizedBox(width: 150),
                      const Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff111827),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CoverPhoto(
                      fromPublicView: true,
                      imageUrl: profile.coverUrl,
                    ),
                    PublicProfilePhoto(avatarUrl: profile.avatarUrl),
                  ],
                ),
                const SizedBox(height: 12),
                PublicProfileUserDetail(),
                SizedBox(height: 14),
                PublicProfileFollower(),
                SizedBox(height: 12),
                PublicProfileActionButton(userId: widget.userId),
                const SizedBox(height: 20),
                PublicProfileDetail(),
                const SizedBox(height: 12),
                PublicAboutCard(),
                SizedBox(height: 12),
                PublicInterestWidget(),
                SizedBox(height: 12),
                PublicInterestTab(),
                SizedBox(height: 12),
                PublicRecentPost(),
                SizedBox(height: 16),
              ],
            ),
          ),
        );
      }),
    );
  }
}
