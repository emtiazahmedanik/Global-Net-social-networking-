import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';

enum TimeRange { d7, m1, m6, y1 }

enum MetricType { posts, followers, likes }

extension TimeRangeExtension on TimeRange {
  String get label {
    switch (this) {
      case TimeRange.d7:
        return '7 days';
      case TimeRange.m1:
        return '1 month';
      case TimeRange.m6:
        return '6 months';
      case TimeRange.y1:
        return '1 year';
    }
  }
}

extension MetricTypeExtension on MetricType {
  String get label {
    switch (this) {
      case MetricType.posts:
        return 'Posts';
      case MetricType.followers:
        return 'Followers';
      case MetricType.likes:
        return 'Likes';
    }
  }
}

class ChartFunctionController extends GetxController {
  var selectedTimeRange = TimeRange.d7.obs;
  var selectedMetric = MetricType.posts.obs;

  // static/sample chart data to restore previous behavior
  final Map<MetricType, Map<TimeRange, List<FlSpot>>> chartData = {
    MetricType.posts: {
      TimeRange.d7: List.generate(7, (i) => FlSpot(i.toDouble(), [5, 3, 6, 4, 7, 2, 8][i].toDouble())),
      TimeRange.m1: List.generate(30, (i) => FlSpot(i.toDouble(), (i % 7 + 1).toDouble())),
      TimeRange.m6: List.generate(6, (i) => FlSpot(i.toDouble(), (10 + i * 5).toDouble())),
      TimeRange.y1: List.generate(12, (i) => FlSpot(i.toDouble(), (20 + i * 3).toDouble())),
    },
    MetricType.followers: {
      TimeRange.d7: List.generate(7, (i) => FlSpot(i.toDouble(), [50, 55, 53, 60, 62, 58, 65][i].toDouble())),
      TimeRange.m1: List.generate(30, (i) => FlSpot(i.toDouble(), (40 + (i % 5) * 3).toDouble())),
      TimeRange.m6: List.generate(6, (i) => FlSpot(i.toDouble(), (200 + i * 30).toDouble())),
      TimeRange.y1: List.generate(12, (i) => FlSpot(i.toDouble(), (400 + i * 25).toDouble())),
    },
    MetricType.likes: {
      TimeRange.d7: List.generate(7, (i) => FlSpot(i.toDouble(), [12, 9, 14, 11, 16, 8, 18][i].toDouble())),
      TimeRange.m1: List.generate(30, (i) => FlSpot(i.toDouble(), (10 + (i % 6) * 2).toDouble())),
      TimeRange.m6: List.generate(6, (i) => FlSpot(i.toDouble(), (50 + i * 10).toDouble())),
      TimeRange.y1: List.generate(12, (i) => FlSpot(i.toDouble(), (80 + i * 6).toDouble())),
    },
  };

  @override
  void onInit() {
    super.onInit();
    // keep previous static data behavior: no API calls here
    update();
  }

  List<FlSpot> get currentChartData {
    return chartData[selectedMetric.value]?[selectedTimeRange.value] ?? [FlSpot(0, 0)];
  }

  // simple static metric summary to show number value on top card
  Map<String, dynamic> get currentMetricData {
    switch (selectedMetric.value) {
      case MetricType.posts:
        return {'value': 125, 'percentage': '8%', 'isPositive': true};
      case MetricType.followers:
        return {'value': 4320, 'percentage': '2.4%', 'isPositive': true};
      case MetricType.likes:
        return {'value': 980, 'percentage': '-1.2%', 'isPositive': false};
    }
  }

  void changeMetric(MetricType metric) {
    selectedMetric.value = metric;
    update();
  }

  void changeTimeRange(TimeRange range) {
    selectedTimeRange.value = range;
    update();
  }
}
