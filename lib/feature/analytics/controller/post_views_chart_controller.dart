import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';

class PostviewsChartController extends GetxController {
  var selectedRange = TimeRange.thisMonth.obs;

  List<FlSpot> get chartData {
    switch (selectedRange.value) {
      case TimeRange.thisMonth:
        return [
          FlSpot(0, 9000),
          FlSpot(1, 11000),
          FlSpot(2, 8500),
          FlSpot(3, 12000),
        ];
      case TimeRange.last3Months:
        return [
          FlSpot(0, 20000),
          FlSpot(1, 30000),
          FlSpot(2, 25000),
          FlSpot(3, 28000),
          FlSpot(4, 35000),
        ];
      case TimeRange.last6Months:
        return [
          FlSpot(0, 15000),
          FlSpot(1, 20000),
          FlSpot(2, 30000),
          FlSpot(3, 28000),
          FlSpot(4, 40000),
          FlSpot(5, 42000),
        ];
      case TimeRange.thisYear:
        return [
          FlSpot(0, 90000),
          FlSpot(1, 85000),
          FlSpot(2, 80000),
          FlSpot(3, 50000),
          FlSpot(4, 48000),
          FlSpot(5, 47000),
          FlSpot(6, 30000),
          FlSpot(7, 70000),
          FlSpot(8, 75000),
          FlSpot(9, 95000),
          FlSpot(10, 20000),
        ];
    }
  }
}

enum TimeRange { thisMonth, last3Months, last6Months, thisYear }
