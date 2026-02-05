import 'package:get/get.dart';

class VerticalRectangleChartController extends GetxController {
  final RxString selectedRange = '7d'.obs;

  final Map<String, String> timeRangeLabels = const {
    '7d': '7 Days',
    '30d': '30 Days',
    '60d': '60 Days',
    '90d': '90 Days',
    '1y': '1 Year',
    'all': 'All Time',
  };

  final Map<String, List<String>> rangeCardData = const {
    '7d': ['07', '25', '\$1200'],
    '30d': ['20', '75', '\$3500'],
    '60d': ['40', '150', '\$8000'],
    '90d': ['55', '200', '\$11000'],
    '1y': ['90', '500', '\$25000'],
    'all': ['150', '700', '\$40000'],
  };

  List<String> get currentCardData =>
      rangeCardData[selectedRange.value] ?? const ['0', '0', '\$0'];

  final Map<String, List<double>> chartDataByRange = {
    '7d': [5, 10, 7, 12, 6, 8, 9],
    '30d': [6, 9, 14, 10],
    '60d': [8, 15, 10, 14, 12, 17, 16, 14],
    '90d': [12, 15, 9],
    '1y': [10, 12, 14, 10, 9, 13, 11, 10, 8, 12, 14, 15],
    'all': [20, 25, 22, 30, 28, 35, 33],
  };

  List<double> get currentChartData =>
      chartDataByRange[selectedRange.value] ?? const [];

  List<String> get currentXAxisLabels {
    final key = selectedRange.value;
    final count = currentChartData.length;

    switch (key) {
      case '7d':
        return _seq('D', count);
      case '30d':
      case '60d':
        return _seq('W', count);
      case '90d':
        return _seq('M', count);
      case '1y':
        return (count == 12) ? _months : _seq('M', count);
      case 'all':
        return _seq('Y', count);
      default:
        return _seq('', count);
    }
  }

  List<String> _seq(String prefix, int n) =>
      List<String>.generate(n, (i) => '$prefix${i + 1}');

  static const List<String> _months = <String>[
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

  void updateRange(String value) {
    if (timeRangeLabels.containsKey(value)) {
      selectedRange.value = value;
    }
  }

  bool get isValid => currentChartData.length == currentXAxisLabels.length;
}
