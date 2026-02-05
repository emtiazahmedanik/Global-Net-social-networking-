import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/feature/analytics/controller/marketplace_card_controller.dart';

class MarketplaceCardWidget extends StatelessWidget {
  const MarketplaceCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MarketplaceCardController());

    return Obx(() {
      final data = controller.currentCardData;

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildTextContainer(data[0], "Active Ads"),
            _buildTextContainer(data[1], "Total Ads"),
            _buildTextContainer(data[2], "Total Sales"),
          ],
        ),
      );
    });
  }

  Widget _buildTextContainer(String topText, String bottomText) {
    final borderColor = Colors.blue.shade100;

    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),

        boxShadow: [
          BoxShadow(
            color: borderColor.withValues(alpha: 1.8),
            blurRadius: 14,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            topText,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              height: 1.6,
            ),
          ),
          SizedBox(height: 8),
          Text(
            bottomText,
            style: TextStyle(
              fontSize: 14,
              color: Color(0XFF6A6A6A),
              fontWeight: FontWeight.w400,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
