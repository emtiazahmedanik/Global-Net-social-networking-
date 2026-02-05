// lib/feature/create_ngo/ngo_create_post_screen/service/ngo_create_post_api_service.dart

import 'package:flutter/foundation.dart';
import 'package:jdadzok/core/http_service/http_network_client.dart';
import 'package:jdadzok/core/network_caller/endpoints.dart';

/// This function wraps the create post API and normalizes backend responses.
/// Returns `true` if post created (status 201 & success true), otherwise false.
/// It also prints helpful debug messages.
Future<bool> ngoCreatePostApiService({
  required String text,
  required List<String> mediaUrls,
  required String mediaType,
  required String visibility,
  required String postFrom,
  List<String>? taggedUserIds,
  Map<String, dynamic>? metadata,
  String? categoryId,
  String? communityId,
  String? ngoId,
  bool? acceptVolunteer,
  bool? acceptDonation,
}) async {
  if (kDebugMode) {
    print('category id in api service: $categoryId');
  }
  if (kDebugMode) {
    print('community id in api service: $communityId');
  }
  try {
    final body = <String, dynamic>{
      "text": text,
      "visibility": visibility,
      "postFrom": postFrom,
      "acceptVolunteer": acceptVolunteer ?? false,
      "acceptDonation": acceptDonation ?? false,
    };

    if (mediaUrls.isNotEmpty) body['mediaUrls'] = mediaUrls;
    if (mediaType.isNotEmpty && mediaType != 'NONE') body['mediaType'] = mediaType;
    if (taggedUserIds != null && taggedUserIds.isNotEmpty) body['taggedUserIds'] = taggedUserIds;
    if (metadata != null && metadata.isNotEmpty) body['metadata'] = metadata;
    if (categoryId != null){
      body.addAll({'categoryId': categoryId});
    } 
    if (communityId != null){
      body.addAll({'communityId': communityId});
    } 
    if (ngoId != null) body['ngoId'] = ngoId;

    if (kDebugMode) debugPrint('ngoCreatePostApiService final post body: $body');

    final response = await HttpNetworkClient().postRequest(
      url: Urls.createPost,
      body: body,
    );

    debugPrint('ngoCreatePostApiService response: $response');

    final responseBody = response.responseData;
    if (kDebugMode) debugPrint('ngoCreatePostApiService response: $responseBody');

    // success condition from swagger: 201 and success == true
    if (response.statusCode == 201 && responseBody != null && responseBody['success'] == true) {
      return true;
    }

    // If not success: try to read the message and show as debug
    var message = 'Request Failed';
    if (responseBody != null && responseBody['message'] != null) {
      final msg = responseBody['message'];
      if (msg is String) {
        message = msg;
      } else if (msg is List) {
        // join list to single string for display
        message = msg.map((e) => e.toString()).join('; ');
      } else {
        message = msg.toString();
      }
    } else if (responseBody != null && responseBody['data'] != null) {
      message = responseBody['data'].toString();
    }

    if (kDebugMode) debugPrint('Create post failed: $message');

    return false;
  } catch (e, st) {
    if (kDebugMode) {
      debugPrint('ngoCreatePostApiService error: $e');
      debugPrint('$st');
    }
    return false;
  }
}
