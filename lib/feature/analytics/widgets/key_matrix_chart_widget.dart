import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:jdadzok/feature/analytics/controller/keymatrix_controller.dart';

class KeyMatrixChartWidget extends StatelessWidget {
  const KeyMatrixChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<KeymatrixController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: 220,
        child: Obx(() {
          final posts = controller.getCountForType('post').toDouble();
          final followers = controller.getCountForType('follower').toDouble();
          final likes = controller.getCountForType('like').toDouble();

          final maxVal = [posts, followers, likes, 1.0].reduce((a, b) => a > b ? a : b);

          return BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxVal * 1.2,
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (v, meta) {
                      final idx = v.toInt();
                      const labels = ['Posts', 'Followers', 'Likes'];
                      if (idx >= 0 && idx < labels.length) {
                        return Padding(
                          padding: EdgeInsets.only(top: 6.0),
                          child: Text(labels[idx], style: TextStyle(fontSize: 12)),
                        );
                      }
                      return SizedBox.shrink();
                    },
                    interval: 1,
                  ),
                ),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              barGroups: [
                BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: posts, color: Colors.blue, width: 22)]),
                BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: followers, color: Colors.green, width: 22)]),
                BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: likes, color: Colors.orange, width: 22)]),
              ],
            ),
          );
        }),
      ),
    );
  }
}