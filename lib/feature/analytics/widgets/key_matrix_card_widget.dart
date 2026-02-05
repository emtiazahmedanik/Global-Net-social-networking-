import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/feature/analytics/controller/keymatrix_controller.dart';

class KeymatrixCardWidget extends StatelessWidget {
  const KeymatrixCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<KeymatrixController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(3, (index) {
              return Container(
                width: 110,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue.shade100),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.shade100,
                      blurRadius: 14,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              );
            }),
          ),
        );
      }

      final data = controller.currentData;
      final range = controller.selectedRange.value;
      
      // Map range to display text
      final rangeDisplayMap = {
        '7d': '7days',
        '1m': '1months',
        '6m': '6months',
        '1y': '1years',
      };
      final rangeDisplay = rangeDisplayMap[range] ?? '7days';

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(data.length, (index) {
            final item = data[index];
            return StatCard(
              value: item['value'],
              label: index == 0
                  ? 'Posts'
                  : index == 1
                  ? 'Followers'
                  : 'Likes',
              percentage: item['percentage'],
              isPositive: item['isPositive'],
              range: rangeDisplay,
            );
          }),
        ),
      );
    });
  }
}

class StatCard extends StatelessWidget {
  final String value;
  final String label;
  final String percentage;
  final bool isPositive;
  final String range;

  const StatCard({
    super.key,
    required this.value,
    required this.label,
    required this.percentage,
    required this.isPositive,
    required this.range,
  });

  @override
  Widget build(BuildContext context) {
    Color trendColor = isPositive ? Colors.blue : Colors.red;
    IconData trendIcon = isPositive ? Icons.trending_up : Icons.trending_down;

    return Container(
      width: 110,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue.shade100),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100,
            blurRadius: 14,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 14, color: Colors.grey)),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(trendIcon, size: 14, color: trendColor),
              SizedBox(width: 2),
              Text(
                percentage,
                style: TextStyle(fontSize: 14, color: trendColor),
              ),
              SizedBox(width: 4),
              Text(range, style: TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}
