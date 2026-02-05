import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/feature/public_view/controller/public_profile_controller.dart';

class PublicProfileUserDetail extends StatelessWidget {
  PublicProfileUserDetail({super.key});

  final controller = Get.find<PublicProfileController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final profileData = controller.profileData.value?.data;
      if (profileData == null) return SizedBox.shrink();

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    profileData.profile.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      height: 1.8,
                      color: Color(0xff111827),
                    ),
                  ),
                  SizedBox(width: 4),
                  if (profileData.isVerified)
                    Row(
                      children: [
                        Image.asset(
                          'assets/icons/verified_icon.png',
                          width: 16,
                          height: 16,
                        ),
                        SizedBox(width: 4),
                      ],
                    ),
                  if (profileData.capLevel != 'NONE')
                    Image.asset(
                      'assets/icons/green_cap_icon.png',
                      width: 16,
                      height: 16,
                    ),
                ],
              ),
              Row(
                children: [
                  Text(
                    profileData.role,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff717171),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                    child: VerticalDivider(
                      color: const Color(0xff6A6A6A),
                      thickness: 1.5,
                      width: 12,
                    ),
                  ),
                  Text(
                    "Cap Level: ${profileData.capLevel}",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff717171),
                    ),
                  ),
                  SizedBox(height: 12),
                ],
              ),
            ],
          ),
        ],
      );
    });
  }
}
