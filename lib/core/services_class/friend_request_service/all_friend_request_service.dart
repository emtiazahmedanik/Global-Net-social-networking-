import 'package:flutter/material.dart';
import 'package:jdadzok/core/http_service/http_network_client.dart';
import 'package:jdadzok/core/network_caller/endpoints.dart';

class AllFriendRequestService {
  static Future<HttpNetworkResponse?> getAllFriends() async {
    try {
      final response = await HttpNetworkClient().getRequest(
        url: Urls.getAllFriends,
      );
      return response;
    } catch (e) {
      debugPrint("getAllFriends error: $e");
      return null;
    }
  }
}
