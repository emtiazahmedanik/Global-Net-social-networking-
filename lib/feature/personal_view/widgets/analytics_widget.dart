import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/feature/analytics/screen/analytics_screen.dart';

class AnalyticsWidget extends StatelessWidget {
  const AnalyticsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                ' Analytics',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  height: 1.8,
                  color: Color(0xff000000),
                ),
              ),
              Spacer(),
              GestureDetector(
                child: Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff000000),
                  ),
                ),
                onTap: () {
                  Get.to(()=>AnalyticsScreen());
                  debugPrint('Edit tapped');
                },
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xff000000)),
            ],
          ),
        ],
      ),
    );
  }
}
