import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/feature/analytics/controller/vertical_rectangle_chart_controller.dart';

class SalesChartButtonWidget extends StatelessWidget {
  const SalesChartButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VerticalRectangleChartController());

    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text(
            'Sales Chart',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              height: 1.8,
            ),
          ),
          Spacer(),
          Obx(() {
            return PopupMenuButton<String>(
              onSelected: (value) {
                controller.selectedRange.value = value;
              },
              itemBuilder: (context) {
                return controller.chartDataByRange.keys
                    .map(
                      (key) => PopupMenuItem<String>(
                        value: key,
                        child: Text(key.toUpperCase()),
                      ),
                    )
                    .toList();
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(21),
                  color: Color(0xFF6A6A6A).withValues(alpha: .6),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Row(
                  children: [
                    Text(
                      controller.selectedRange.value.toUpperCase(),
                      style: TextStyle(color: Colors.black),
                    ),
                    Icon(Icons.arrow_drop_down, color: Colors.black),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
