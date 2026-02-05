// lib/feature/create_ngo/create_ngo_verify_screen/widget/create_ngo_verify_head_body.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/const/app_colors.dart';
import 'package:jdadzok/core/style/global_text_style.dart';
import 'package:jdadzok/feature/create_ngo/ngo_main_profile_screen/screen/ngo_main_profile_screen.dart';
import 'package:jdadzok/feature/create_ngo/create_ngo_verify_screen/model/create_ngo_verify_model.dart';
import 'package:jdadzok/route/app_route.dart';

// ignore: camel_case_types
class createNGOVerifyHeadBody extends StatelessWidget {
  final bool isNgo;
  final OrganizationModel org; // can be community or NGO
  final bool showBackButton;

  const createNGOVerifyHeadBody({
    super.key,
    required this.org,
    required this.isNgo,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final profile = org.profile;
    final name = profile?.name ?? 'No name';
    final avatarUrl = profile?.avatarUrl;
    final isVerified = org.isVerified ?? false;

    final following = profile?.followingCount ?? 0;
    final followers = profile?.followersCount ?? 0;
    final likes = org.likes ?? 0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // header row text
        if (showBackButton)
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: CircleAvatar(
                  backgroundColor: Color(0XFFEFEFEF),
                  child: Icon(Icons.arrow_back, color: Colors.grey.shade700),
                ),
              ),
              Spacer(),
              Text(
              isNgo ? "NGO" : "Community",
              style: globalTextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              // textAlign: TextAlign.center,
            ),
            Spacer(),
          ],
        ),
        if (showBackButton) const SizedBox(height: 16),
        Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: avatarUrl == null
                  ? Colors.white
                  : Colors.transparent,
              backgroundImage: avatarUrl != null
                  ? NetworkImage(avatarUrl)
                  : null,
              child: avatarUrl == null
                  ? Icon(Icons.person, size: 28, color: Colors.grey)
                  : null,
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: globalTextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 8),
                    if (isVerified) ...[
                      Row(
                        children: [
                          Icon(
                            Icons.verified_user_rounded,
                            color: AppColors.primaryColor,
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "verified",
                            style: globalTextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  isNgo ? "Ngo" : "Community",
                  style: globalTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0XFF717171),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _statItem('$following', 'Following'),
            _statItem('$followers', 'Followers'),
            _statItem('$likes', 'Likes'),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // head body Edit button
                  Get.toNamed(
                    AppRoute.editCommunityNGO,
                    arguments: {'isNgo': isNgo, 'org': org},
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Edit'),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // View profile main screen
                  Get.to(() => NgoMainProfileScreen(isNgo: isNgo, org: org));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('View Profile'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _statItem(String count, String label) {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 16, color: Colors.black),
        children: [
          TextSpan(
            text: '$count ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: label),
        ],
      ),
    );
  }
}
