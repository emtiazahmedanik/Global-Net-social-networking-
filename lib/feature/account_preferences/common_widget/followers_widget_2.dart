import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:jdadzok/feature/personal_view/controller/personal_profile_view_controller.dart';

class FollowersWidget2 extends StatelessWidget {
  FollowersWidget2({super.key});

  final PersonalProfileViewController controller =
      Get.find<PersonalProfileViewController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: EdgeInsets.symmetric(horizontal: 28.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  controller.profile.value?.data?.followingCount.toString() ?? '',
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
                  controller.profile.value?.data?.followersCount.toString() ?? '',
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
                  controller.userMetrics.value?.totalLikes.toString() ?? '',
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
      ),
    );
  }
}
