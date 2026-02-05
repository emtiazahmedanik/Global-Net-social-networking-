// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/global_widegts/custom_view_button.dart';
import 'package:jdadzok/feature/edit_profile/screen/edit_profile_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/foundation.dart';

class ProfileActionButton extends StatelessWidget {
  const ProfileActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CustomViewButton(
            text: 'View Analytics',
            color: Color(0XFF2D55FF),
            width: 199,
            onPressed: () {
              Get.toNamed(('AnalyticsScreen'));
            },
            textColor: Colors.white,
          ),
          
          GestureDetector(
            child: Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: AssetImage(
                    'assets/icons/edit_profile_button_icon.png',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            onTap: () {
              debugPrint('tapped edit profile button');

              Get.to(() => EditProfileScreen());
            },
          ),
          GestureDetector(
            child: Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: AssetImage('assets/icons/share_button_icon.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            onTap: () async {
              debugPrint('tapped share button');
              try {
                await Share.share('Check out my profile on Jdadzok!');
                EasyLoading.showSuccess('Share sheet opened');
              } catch (e) {
                if (kDebugMode) debugPrint('Share failed: $e');
                EasyLoading.showError('Unable to share');
              }
            },
          ),
        ],
      ),
    );
  }
}
