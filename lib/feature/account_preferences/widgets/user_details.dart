import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/const/icons_path.dart';
import 'package:jdadzok/core/global_widegts/global_cached_network_image.dart';
import 'package:jdadzok/feature/account_preferences/controller/user_detail_controller.dart';
import 'package:jdadzok/core/utils/cap_level_utils.dart';

class UserDetails extends StatelessWidget {
  UserDetails({super.key});

  final controller = Get.put(UserDetailController());

  @override
  Widget build(BuildContext context) {
    return Obx((){
      var profileData = controller.profile.value?.data;
      return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: SizedBox(
            height: 60,
            width: 60,
            child: getCachedNetworkImage(
              imageUrl: profileData?.avatarUrl ?? '',
            ),
          ),
        ),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  profileData?.name ?? '',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    height: 1.8,
                    color: Color(0xff111827),
                  ),
                ),
                SizedBox(width: 4),
                Row(
                  children: [
                    Image.asset(
                      'assets/icons/verified_icon.png',
                      width: 16,
                      height: 16,
                    ),
                    SizedBox(width: 4),
                    ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        capColorFrom(profileData?.user?.capLevel ?? 'NONE'),
                        BlendMode.srcIn,
                      ),
                      child: Image.asset(IconsPath.capIcon, width: 16, height: 16),
                    ),
                  ],
                ),
              ],
            ),

            Text(
              profileData?.user?.role ?? '',
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
    );
    }) ;
  }
}
