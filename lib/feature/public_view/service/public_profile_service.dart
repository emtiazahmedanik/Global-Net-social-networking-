import 'package:dio/dio.dart';
import 'package:jdadzok/core/network_caller/dio_client.dart';
import 'package:jdadzok/core/network_caller/endpoints.dart';
import 'package:jdadzok/feature/public_view/model/public_profile_model.dart';
import 'package:flutter/material.dart';

class PublicProfileService {
  final DioClient _dioClient = DioClient();

  Future<PublicProfileResponse?> fetchUserProfile(String userId) async {
    try {
      final response = await _dioClient.client.get(
        '${Urls.getUserProfile}/$userId',
      );

      if (response.statusCode == 200) {
        return PublicProfileResponse.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      debugPrint('Error fetching user profile: ${e.message}');
      return null;
    }
  }
}
