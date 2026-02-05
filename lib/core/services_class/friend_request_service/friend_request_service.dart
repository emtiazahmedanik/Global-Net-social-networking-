import 'package:flutter/material.dart';
import 'package:jdadzok/core/http_service/http_network_client.dart';
import 'package:jdadzok/core/network_caller/endpoints.dart';

class FriendRequestService {
  static Future<HttpNetworkResponse?> sendFriendRequest({
    required String receiverId,
  }) async {
    try {
      final body = {"receiverId": receiverId};
      final respone = await HttpNetworkClient().postRequest(
        url: Urls.sentFriendRequest,
        body: body,
      );
      return respone;
    } catch (e) {
      debugPrint('request sent error: $e');
      return null;
    }
  }

  static Future<HttpNetworkResponse?> getPendingFriendRequests() async {
    try {
      final respone = await HttpNetworkClient().getRequest(
        url: Urls.getPendingFriendRequests,
      );
      return respone;
    } catch (e) {
      debugPrint('pending req error: $e');
      return null;
    }
  }

  /// ACCEPT FRIEND REQUEST (PATCH)
  static Future<HttpNetworkResponse?> acceptFriendRequest({
    required String requestId,
  }) async {
    try {
      final body = {"requestId": requestId, "action": "ACCEPT"};

      final response = await HttpNetworkClient().patchRequest(
        url: Urls.updateFriendRequest,
        body: body,
      );

      return response;
    } catch (e) {
      debugPrint('accept req error: $e');
      return null;
    }
  }

  /// REJECT FRIEND REQUEST (PATCH)
  static Future<HttpNetworkResponse?> rejectFriendRequest({
    required String requestId,
  }) async {
    try {
      final body = {"requestId": requestId, "action": "REJECT"};

      final response = await HttpNetworkClient().patchRequest(
        url: Urls.updateFriendRequest,
        body: body,
      );

      return response;
    } catch (e) {
      debugPrint('reject req error: $e');
      return null;
    }
  }
}
