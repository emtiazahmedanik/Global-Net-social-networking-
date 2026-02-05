import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/feature/create_ngo/apply%20verification%20details/controller/apply_verification_controller.dart';

class ApplyVerificationProfileDetails extends StatelessWidget {
  const ApplyVerificationProfileDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ApplyVerificationController>();
    
    return Obx(() {
      // Don't display anything if no data or loading
      if (controller.isLoading.value || !controller.hasData) {
        return SizedBox.shrink();
      }

      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  height: 1.8,
                  color: Color(0xff000000),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            controller.mission.isNotEmpty
                ? controller.mission
                : (controller.bio.isNotEmpty
                    ? controller.bio
                    : 'No details available'),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
        ],
      );
    });
  }
}
