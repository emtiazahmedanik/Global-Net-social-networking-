// ignore_for_file: file_names

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/feature/analytics/controller/vertical_rectangle_chart_controller.dart';

class VerticalRectangleChart extends StatelessWidget {
  const VerticalRectangleChart({super.key});

  final List<String> labels = const [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VerticalRectangleChartController());

    return AspectRatio(
      aspectRatio: 1.6,
      child: Obx(() {
        final values = controller.currentChartData;
        final labels = controller.currentXAxisLabels;
        return BarChart(
          BarChartData(
            maxY: 40,
            barTouchData: BarTouchData(enabled: true),
            gridData: FlGridData(show: false),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 32,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index < 0 || index >= labels.length) {
                      return SizedBox.shrink();
                    }
                    return SideTitleWidget(
                      meta: meta,
                      child: Text(
                        labels[index],
                        style: TextStyle(fontSize: 10),
                      ),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 10,
                  getTitlesWidget: (value, meta) {
                    const labelMap = {
                      0: '0',
                      10: '10k',
                      20: '20k',
                      30: '30k',
                      40: '40k',
                    };
                    if (!labelMap.containsKey(value.toInt())) {
                      return SizedBox.shrink();
                    }
                    return SideTitleWidget(
                      meta: meta,
                      child: Text(
                        labelMap[value.toInt()]!,
                        style: TextStyle(fontSize: 10),
                      ),
                    );
                  },
                ),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            barGroups: List.generate(values.length, (index) {
              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: values[index],
                    width: 26,
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.blueAccent.shade100,
                        Colors.blueAccent.shade700,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(0),
                  ),
                ],
              );
            }),
          ),
        );
      }),
    );
  }
}
