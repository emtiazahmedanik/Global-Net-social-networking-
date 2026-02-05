import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:jdadzok/core/network_caller/endpoints.dart';
import 'package:jdadzok/feature/home/model/feed_response_model.dart';

class FeedService {

  Future<FeedResponse?> fetchFeed(int page, {String? search}) async {
    final url = "${Urls.baseUrl}/posts?page=$page&limit=20&metadata=true&author=false&search=${search ?? ''}";
    debugPrint('Fetch Feed URL: $url');
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      return FeedResponse.fromJson(jsonBody);
    } else {
      throw Exception("Failed to load posts");
    }
  }
}
