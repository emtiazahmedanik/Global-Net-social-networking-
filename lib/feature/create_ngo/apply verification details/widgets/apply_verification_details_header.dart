import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/const/image_path.dart';
import 'package:jdadzok/feature/create_ngo/apply%20verification%20details/controller/apply_verification_controller.dart';

class ApplyVerificationDetailsHeader extends StatelessWidget {
  const ApplyVerificationDetailsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ApplyVerificationController>();

    return Obx(() {
      // Display loading or error state
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      if (controller.error.value.isNotEmpty) {
        return Center(
          child: Text(
            'Error: ${controller.error.value}',
            style: TextStyle(color: Colors.red),
          ),
        );
      }

      // Display data
      return Row(
        children: [
          CircleAvatar(
            radius: 38,
            backgroundImage: controller.avatarUrl.isNotEmpty
                ? NetworkImage(controller.avatarUrl)
                : AssetImage(ImagePath.ngoHexaMediaImage) as ImageProvider,
            onBackgroundImageError: controller.avatarUrl.isNotEmpty
                ? (exception, stackTrace) {
                    // Fallback to asset image on network error
                  }
                : null,
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        controller.name.isNotEmpty
                            ? controller.name
                            : 'Organization Name',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          height: 1.8,
                          color: Color(0xff111827),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Text(
                  controller.orgTypeLabel.isNotEmpty
                      ? controller.orgTypeLabel
                      : 'Community',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff717171),
                  ),
                ),
                SizedBox(height: 12),
              ],
            ),
          ),
        ],
      );
    });
  }
}
