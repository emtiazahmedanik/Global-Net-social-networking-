import 'package:flutter/foundation.dart';
import 'package:jdadzok/core/http_service/http_network_client.dart';
import 'package:jdadzok/core/network_caller/endpoints.dart';

class NgoDonationService {
  /// Make a donation to an NGO
  /// Returns response data if successful, null otherwise
  static Future<Map<String, dynamic>?> makeDonation({
    required String ngoId,
    required int amount,
  }) async {
    try {
      final body = {
        'ngoId': ngoId,
        'amount': amount,
      };

      if (kDebugMode) {
        print('Donation request body: $body');
      }

      final response = await HttpNetworkClient().postRequest(
        url: Urls.donationNgo,
        body: body,
      );

      if (kDebugMode) {
        print('Donation response: ${response.responseData}');
      }

      if (response.isSuccess && response.responseData != null) {
        return response.responseData;
      } else {
        if (kDebugMode) {
          print('Donation failed: ${response.errorMessage}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Donation error: $e');
      }
      return null;
    }
  }
}

