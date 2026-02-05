import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/const/app_colors.dart';
import 'package:jdadzok/core/style/global_text_style.dart';
import 'package:jdadzok/feature/create_ngo/ngo_main_profile_screen/controller/ngo_main_profile_screen_controller.dart';

class NGOUserDetails extends StatelessWidget {
  final String name;
  final String profileType;
  final String followingCount;
  final String followersCount;
  final String likesCount;
  const NGOUserDetails({
    super.key,
    required this.name,
    required this.profileType,
    required this.followingCount,
    required this.followersCount,
    required this.likesCount,
  });

  @override
  Widget build(BuildContext context) {
    final NgoMainProfileScreenController controller = Get.find();
    final isVerified = controller.org.value?.isVerified ?? false;
    // capLevel shown if present - using icon placeholder for now
    final hasCap = (controller.org.value?.capLevel != null && controller.org.value!.capLevel!.isNotEmpty);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, height: 1.8, color: Color(0xff111827))),
                SizedBox(width: 6),
                if (isVerified) ...[
                  Image.asset('assets/icons/verified_icon.png', width: 16, height: 16),
                  SizedBox(width: 4),
                  Text('verified', style: globalTextStyle(color: AppColors.primaryColor)),
                ],
                if (hasCap) ...[
                  SizedBox(width: 6),
                  Image.asset('assets/icons/green_cap_icon.png', width: 16, height: 16),
                ],
              ]),
              SizedBox(height: 6),
              Text(profileType, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xff717171))),
            ]),
          ],
        ),
        SizedBox(height: 14),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Column(children: [
            Text(followingCount, style: globalTextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
            Text("Following", style: globalTextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0XFF717171))),
          ]),
          Column(children: [
            Text(followersCount, style: globalTextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
            Text("Followers", style: globalTextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0XFF717171))),
          ]),
          Column(children: [
            Text(likesCount, style: globalTextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
            Text("Likes", style: globalTextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0XFF717171))),
          ]),
        ]),
      ],
    );
  }
}
