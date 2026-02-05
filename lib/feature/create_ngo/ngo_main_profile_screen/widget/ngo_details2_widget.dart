import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/feature/account_preferences/controller/expandable_text_controller.dart';
import 'package:jdadzok/feature/account_preferences/common_widget/details_text_widget.dart';
import 'package:jdadzok/feature/create_ngo/ngo_main_profile_screen/controller/ngo_main_profile_screen_controller.dart';
import 'package:jdadzok/route/app_route.dart';

class NgoDetails2Widget extends StatelessWidget {
  const NgoDetails2Widget({super.key});

  @override
  Widget build(BuildContext context) {
    final NgoMainProfileScreenController controller = Get.find();
    final bio =
        controller.org.value?.profile?.bio ??
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                ' Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  height: 1.8,
                  color: Color(0xff000000),
                ),
              ),
              Spacer(),
              TextButton(
                onPressed: () {
                  // head body Edit button
                  final org = controller.org.value;
                  if (org != null) {
                    Get.toNamed(
                      AppRoute.editCommunityNGO,
                      arguments: {'isNgo': org.isNgo, 'org': org},
                    );
                  }
                },
                child: Row(
                  children: [
                    Text(
                      'Edit',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff000000),
                      ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xff000000)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          ExpandableText(text: bio, controller: ExpandableTextController()),
        ],
      ),
    );
  }
}
