import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:jdadzok/feature/analytics/service/user_metrics_service.dart';

class KeymatrixController extends GetxController {
  var selectedRange = '7d'.obs;
  var isLoading = false.obs;

  // Store metrics data for each type
  final RxMap<String, Map<String, dynamic>> metricsData = <String, Map<String, dynamic>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMetrics();
  }

  /// Fetch metrics for all types (post, like, comment, share, follower)
  Future<void> fetchMetrics() async {
    isLoading.value = true;
    
    try {
      final types = ['post', 'like', 'comment', 'share', 'follower'];
      
      for (final type in types) {
        final response = await UserMetricsService.getUserMetrics(
          type: type,
          range: selectedRange.value,
        );
        
        if (response != null) {
          metricsData[type] = response;
        }
      }
    } catch (e) {
      if (Get.isRegistered<EasyLoading>()) {
        EasyLoading.showError('Failed to load metrics');
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Get count for a specific type
  int getCountForType(String type) {
    final data = metricsData[type];
    if (data != null && data['filteredCount'] != null) {
      return data['filteredCount']['count'] ?? 0;
    }
    return 0;
  }

  /// Get current data for display (post, follower, like)
  List<Map<String, dynamic>> get currentData {
    return [
      {
        'value': getCountForType('post').toString(),
        'percentage': '0%', // Can be calculated if needed
        'isPositive': true,
      },
      {
        'value': getCountForType('follower').toString(),
        'percentage': '0%',
        'isPositive': true,
      },
      {
        'value': getCountForType('like').toString(),
        'percentage': '0%',
        'isPositive': true,
      },
    ];
  }
}
