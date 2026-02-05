import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/http_service/http_network_client.dart';
import 'package:jdadzok/core/network_caller/endpoints.dart';
import 'package:jdadzok/feature/account_preferences/model/user_metrics_model.dart';
import 'package:jdadzok/feature/edit_profile/model/profile_model.dart';

class PersonalProfileViewController extends GetxController {
  Rxn<File> coverImage = Rxn<File>();
  Rxn<File> profileImage = Rxn<File>();
  //Rxn<PersonalProfileResponseModel> profile = Rxn<PersonalProfileResponseModel>();

  @override
  void onInit() {
    getProfile();
    getUserMetrics();
    super.onInit();
  }


   Rxn<ProfileResponse> profile = Rxn<ProfileResponse>();
  void getProfile() async {
    final response = await HttpNetworkClient().getRequest(
      url: Urls.getProfileInfo,
    );
    final body = response.responseData;
    if (body != null && body['success'] == true) {
      ProfileResponse profileResponse = ProfileResponse.fromJson(body);
      profile.value = profileResponse;
      if (kDebugMode) {
        print(profileResponse.data?.name);
        print(profileResponse.data?.user?.email);
        print(profileResponse.data?.username);
      }
    }
  }

  Rxn<UserMetricsModel> userMetrics = Rxn<UserMetricsModel>();
  void getUserMetrics() async {
    try{final response = await HttpNetworkClient().getRequest(
      url: Urls.userMetrics,
    );
    final body = response.responseData;
    debugPrint('user metrics: $body');
    if (body != null) {
      userMetrics.value = UserMetricsModel.fromJson(body);
    }}catch(e){
      debugPrint('this is error : $e');
    }
  }
}
