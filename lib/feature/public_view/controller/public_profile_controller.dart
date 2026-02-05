import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/feature/public_view/model/public_profile_model.dart';
import 'package:jdadzok/feature/public_view/service/public_profile_service.dart';

class PublicProfileController extends GetxController {
  final PublicProfileService _profileService = PublicProfileService();

  final Rx<PublicProfileResponse?> profileData = Rx<PublicProfileResponse?>(
    null,
  );
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Future<void> fetchUserProfile(String userId) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _profileService.fetchUserProfile(userId);

      if (response != null) {
        profileData.value = response;
      } else {
        errorMessage.value = 'Failed to load user profile';
      }
    } catch (e) {
      errorMessage.value = 'Error: ${e.toString()}';
      debugPrint('Error fetching user profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    profileData.value = null;
    super.onClose();
  }
}
