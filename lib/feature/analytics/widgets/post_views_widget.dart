import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/feature/analytics/controller/chart_controller_function.dart';

class PostViewsWidget extends StatelessWidget {
  const PostViewsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChartFunctionController());

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Obx(() {
            return GestureDetector(
              onTap: () async {
                final selected = await showMenu<MetricType>(
                  context: context,
                  position: RelativeRect.fromLTRB(-50, 560, 0, 0),
                  items: MetricType.values.map((metric) {
                    return PopupMenuItem(
                      value: metric,
                      child: Text(metric.label),
                    );
                  }).toList(),
                );
                if (selected != null) controller.changeMetric(selected);
              },
              child: Row(
                children: [
                  Text(
                    controller.selectedMetric.value.label,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Icon(Icons.arrow_drop_down),
                ],
              ),
            );
          }),
          Spacer(),

          Obx(() {
            return GestureDetector(
              onTap: () async {
                final selected = await showMenu<TimeRange>(
                  context: context,
                  position: RelativeRect.fromLTRB(300, 560, 0, 0),
                  items: TimeRange.values.map((range) {
                    return PopupMenuItem(
                      value: range,
                      child: Text(range.label),
                    );
                  }).toList(),
                );
                if (selected != null) controller.changeTimeRange(selected);
              },
              child: Container(
                height: 32,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: .9),
                  borderRadius: BorderRadius.circular(21),
                ),
                child: Row(
                  children: [
                    Text(controller.selectedTimeRange.value.label),
                    Icon(Icons.arrow_drop_down),
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
