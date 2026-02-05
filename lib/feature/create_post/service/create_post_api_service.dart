import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/http_service/http_network_client.dart';
import 'package:jdadzok/core/network_caller/endpoints.dart';

Future<bool> createPostApiService({
  required String token,
  required String text,
  required List<String> mediaUrls,
  required String mediaType,
  required String visibility,
  required String postFrom,
  RxList? taggedUserIds,
  Map<String, dynamic>? metadata,
  String? categoryId,
  String? communityId,
  String? ngoId,
  bool? acceptVolunteer,
  bool? acceptDonation,
}) async {
  try {
    final body = {
      "text": text,
      //"mediaUrls": mediaUrls,
      //"mediaType": mediaType,
      "visibility": visibility,
      "taggedUserIds": taggedUserIds != null ? taggedUserIds.toList() : [],
      "metadata": metadata ?? {},
      "postFrom": postFrom,
      //"categoryId": "string",
      //"communityId": "string",
      //"ngoId": "string",
      "acceptVolunteer": false,
      "acceptDonation": false,
    };
    if(mediaUrls.isNotEmpty){
      body.addAll({"mediaUrls": mediaUrls,});
    }
    if(mediaType != 'NONE'){
      body.addAll({"mediaType": mediaType});
    }

    debugPrint('final post body: $body');

    final response = await HttpNetworkClient().postRequest(
      url: Urls.createPost,
      body: body,
    );

    final responseBody = response.responseData;
    debugPrint('response of post: $responseBody');
    if(response.statusCode == 201 && responseBody?['success'] == true){
      return true;
    }
    return false;

  } catch (e) {
    debugPrint('post api error: $e');
    return false;
  }
}
