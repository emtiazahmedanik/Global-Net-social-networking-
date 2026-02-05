import 'package:flutter/foundation.dart';
import 'package:jdadzok/core/http_service/http_network_client.dart';
import 'package:jdadzok/core/network_caller/endpoints.dart';

class UserMetricsService {
  /// Fetch user metrics with type and range
  /// type: post / like / comment / share / follower
  /// range: 7d / 1m / 6m / 1y
  static Future<Map<String, dynamic>?> getUserMetrics({
    required String type,
    required String range,
  }) async {
    try {
      final url = '${Urls.userMetrics}?type=$type&range=$range';
      
      if (kDebugMode) {
        print('Fetching user metrics: $url');
      }

      final response = await HttpNetworkClient().getRequest(url: url);

      if (kDebugMode) {
        print('User metrics response: ${response.responseData}');
      }

      if (response.isSuccess && response.responseData != null) {
        return response.responseData;
      } else {
        if (kDebugMode) {
          print('User metrics failed: ${response.errorMessage}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('User metrics error: $e');
      }
      return null;
    }
  }
}

