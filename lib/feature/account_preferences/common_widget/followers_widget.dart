import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:jdadzok/feature/account_preferences/controller/user_detail_controller.dart';

class Followers extends StatelessWidget {
  Followers({super.key});

  final controller = Get.find<UserDetailController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Obx(
          () => Text(
            controller.profile.value?.data?.followingCount.toString() ?? '',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              height: 1.8,
              color: Color(0xff000000),
            ),
          ),
        ),
        SizedBox(width: 4),
        Text(
          'Following',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            letterSpacing: 0,
            height: 1.6,
            color: Color(0xff717171),
          ),
        ),
        SizedBox(width: 16),
        Obx(
          () => Text(
            controller.profile.value?.data?.followersCount.toString() ?? '',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              height: 1.8,
              color: Color(0xff000000),
            ),
          ),
        ),
        SizedBox(width: 4),
        Text(
          'Followers',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            letterSpacing: 0,
            height: 1.6,
            color: Color(0xff717171),
          ),
        ),
        SizedBox(width: 16),
        Obx(
          () => Text(
            controller.userMetrics.value?.totalLikes.toString() ?? 'nan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              height: 1.8,
              color: Color(0xff000000),
            ),
          ),
        ),
        SizedBox(width: 4),
        Text(
          'Likes',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            letterSpacing: 0,
            height: 1.6,
            color: Color(0xff717171),
          ),
        ),
      ],
    );
  }
}
