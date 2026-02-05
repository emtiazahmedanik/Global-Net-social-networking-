import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/feature/personal_view/controller/personal_profile_view_controller.dart';
import 'package:jdadzok/core/utils/cap_level_utils.dart';

class UserDetails2 extends StatelessWidget {
    UserDetails2({super.key});

  final controller = Get.find<PersonalProfileViewController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    controller.profile.value?.data?.name ?? '',
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
                          capColorFrom(controller.profile.value?.data?.user?.capLevel ?? 'NONE'),
                          BlendMode.srcIn,
                        ),
                        child: Image.asset(
                          'assets/icons/green_cap_icon.png',
                          width: 16,
                          height: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    controller.profile.value?.data?.user?.role ?? '',
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
                    "Cap Level: ${controller.profile.value?.data?.user?.capLevel}",
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
      ),
    );
  }
}
