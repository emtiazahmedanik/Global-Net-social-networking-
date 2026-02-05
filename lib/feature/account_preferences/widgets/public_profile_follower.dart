import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:jdadzok/feature/public_view/controller/public_profile_controller.dart';

class PublicProfileFollower extends StatelessWidget {
  PublicProfileFollower({super.key});

  final PublicProfileController controller =
      Get.find<PublicProfileController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final profile = controller.profileData.value?.data.profile;
      if (profile == null) return SizedBox.shrink();

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 28.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  profile.followingCount.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff111827),
                  ),
                ),
                Text(
                  'Following',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff717171),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  profile.followersCount.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff111827),
                  ),
                ),
                Text(
                  'Followers',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff717171),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '0',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff111827),
                  ),
                ),
                Text(
                  'Likes',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff717171),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
