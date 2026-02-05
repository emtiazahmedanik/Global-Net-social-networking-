import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/feature/personal_view/controller/personal_profile_view_controller.dart';
import 'package:jdadzok/feature/personal_view/widgets/about_card_widget.dart';
import 'package:jdadzok/feature/personal_view/widgets/analytics_widget.dart';

import 'package:jdadzok/feature/personal_view/widgets/cover_photo_profile_view.dart';
import 'package:jdadzok/feature/personal_view/widgets/details_widget.dart';
import 'package:jdadzok/feature/account_preferences/common_widget/followers_widget_2.dart';


import 'package:jdadzok/feature/account_preferences/common_widget/profile_action_button.dart';
import 'package:jdadzok/feature/personal_view/widgets/personal_profile_photo.dart';

import 'package:jdadzok/feature/account_preferences/common_widget/reward_balance_card.dart';
import 'package:jdadzok/feature/personal_view/widgets/user_details_2.dart';

class ProfilePersonalView extends StatelessWidget {
  ProfilePersonalView({super.key});
  final PersonalProfileViewController controller = Get.put(
    PersonalProfileViewController(),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                  CoverPhotoProfileView(),
                  PersonalProfilePhoto(showButton: false),
                ],
              ),
              const SizedBox(height: 12),

              UserDetails2(),
              SizedBox(height: 14),

              FollowersWidget2(),
              SizedBox(height: 12),
              ProfileActionButton(),
              const SizedBox(height: 20),
              DetailsWidget(),
              const SizedBox(height: 12),
              AboutCardWidget(),
              SizedBox(height: 12),
              AnalyticsWidget(),
              SizedBox(height: 12),
              RewardsBalanceCards(),
              // SizedBox(height: 12),
              // IntersetsWidget(),
              // SizedBox(height: 12),
              // InterestTabWidget(),
              // SizedBox(height: 12),
              // RecentPostsWidget(),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
