import 'package:get/get.dart';

class MarketplaceCardController extends GetxController {
  var selectedRange = '7d'.obs;

  final Map<String, String> timeRangeLabels = {
    '7d': '7 Days',
    '30d': '30 Days',
    '60d': '60 Days',
    '90d': '90 Days',
    '1y': '1 Year',
    'All': 'All Time',
  };

  final Map<String, List<String>> rangeCardData = {
    '7d': ['07', '25', '\$1200'],
    '30d': ['20', '75', '\$3500'],
    '60d': ['40', '150', '\$8000'],
    '90d': ['55', '200', '\$11000'],
    '1y': ['90', '500', '\$25000'],
    'All': ['150', '700', '\$40000'],
  };

  List<String> get currentCardData => rangeCardData[selectedRange.value]!;

  void updateRange(String value) {
    selectedRange.value = value;
  }
}
