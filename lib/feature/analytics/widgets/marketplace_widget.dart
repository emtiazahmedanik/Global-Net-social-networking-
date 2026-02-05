import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/feature/analytics/controller/marketplace_card_controller.dart';

class MarketplaceWidget extends StatelessWidget {
  const MarketplaceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MarketplaceCardController());

    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Marketplace',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                height: 1.8,
              ),
            ),
            Text('SpectraSync storefront'),
          ],
        ),
        Spacer(),
        GestureDetector(
          onTapDown: (TapDownDetails details) {
            showMenu(
              context: context,
              position: RelativeRect.fromLTRB(
                details.globalPosition.dx,
                details.globalPosition.dy,
                0,
                0,
              ),
              items: controller.timeRangeLabels.entries.map((entry) {
                return PopupMenuItem<String>(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList(),
            ).then((value) {
              if (value != null) {
                controller.updateRange(value);
              }
            });
          },
          child: Obx(() {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(21),
                color: Color(0xFF6A6A6A).withValues(alpha: .6),
              ),
              padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
              child: Row(
                children: [
                  Text(
                    controller.selectedRange.value,
                    style: TextStyle(color: Colors.black),
                  ),
                  Icon(Icons.arrow_drop_down, color: Colors.black),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}
