import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/const/icons_path.dart';
import 'package:jdadzok/feature/analytics/controller/user_metrics_controller.dart';
import 'package:intl/intl.dart';

class MonetizationWidget extends StatelessWidget {
  const MonetizationWidget({super.key});

  Color _capColor(String cap) {
    switch (cap) {
      case 'GREEN':
        return Colors.green;
      case 'YELLOW':
        return Colors.yellow.shade700;
      case 'RED':
        return Colors.red;
      case 'BLACK':
        return Colors.black;
      case 'OSTRICH_FEATHER':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserMetricsController controller = Get.put(UserMetricsController());

    final today = DateFormat('dd MMM, yyyy').format(DateTime.now());

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Obx(() {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ' Monetization',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        height: 1.8,
                        color: Color(0xff000000),
                      ),
                    ),

                    Text(
                      today,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff6A6A6A),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  children: [
                    Text(
                      'Cap Level: ${controller.capLevel.value}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff000000),
                      ),
                    ),
                    SizedBox(width: 8),
                    ColorFiltered(
                      colorFilter: ColorFilter.mode(_capColor(controller.capLevel.value), BlendMode.srcIn),
                      child: Image.asset(IconsPath.capIcon, width: 16, height: 16),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
