import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:jdadzok/core/http_service/http_network_client.dart';
import 'package:jdadzok/core/network_caller/endpoints.dart';
import 'package:jdadzok/feature/create_ngo/create_ngo_verify_screen/model/create_ngo_verify_model.dart';

class NgoMainProfileScreenController extends GetxController {
  // Local picked images
  final Rxn<File> coverFile = Rxn<File>();
  final Rxn<File> avatarFile = Rxn<File>();

  // API state
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxString organizationId = ''.obs;


  // Fetched organization (community or NGO)
  final Rxn<OrganizationModel> org = Rxn<OrganizationModel>();

  // If there are multiple items returned, you can choose an index — default 0
  final RxInt selectedIndex = 0.obs;

  final ImagePicker _picker = ImagePicker();

  /// Pick image from gallery. `forCover=true` -> sets coverFile else avatarFile
  Future<void> pickImage({required bool forCover}) async {
    try {
      final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        final file = File(picked.path);
        if (forCover) {
          coverFile.value = file;
        } else {
          avatarFile.value = file;
        }
        update();
        EasyLoading.showInfo('Image selected');
      }
    } catch (e) {
      if (kDebugMode) print('pickImage error: $e');
      EasyLoading.showError('Failed to pick image');
    }
  }

  /// Fetch single organization list (communities or ngos) and set selected org
  Future<void> fetchMyOrganization({required bool isNgo}) async {
    try {
      isLoading.value = true;
      error.value = '';
      org.value = null;

      final String url = isNgo ? Urls.myNgo : Urls.myCommunity;
      final response = await HttpNetworkClient().getRequest(url: url);
      final responseBody = response.responseData;

      if (responseBody != null && responseBody['success'] == true) {
        final data = responseBody['data'] as List<dynamic>? ?? [];
        if (data.isEmpty) {
          error.value = isNgo ? 'No NGO found' : 'No Community found';
        } else {
          final list = OrganizationModel.listFromJson(data, isNgo: isNgo);
          final idx = selectedIndex.value;
          organizationId.value = list.isNotEmpty ? list[0].id : '';
          final picked = (idx >= 0 && idx < list.length) ? list[idx] : list.first;
          org.value = picked;
        }
      } else {
        error.value = responseBody != null && responseBody['message'] != null
            ? responseBody['message'].toString()
            : 'Failed to load';
        if (kDebugMode) print('fetchMyOrganization failed: $responseBody');
      }
    } catch (e) {
      if (kDebugMode) print('fetchMyOrganization error: $e');
      error.value = 'Something went wrong';
    } finally {
      isLoading.value = false;
      update();
    }
  }

  /// Convenience getters
  String get displayName => org.value?.profile?.name ?? 'No name';
  String? get avatarUrl => org.value?.profile?.avatarUrl;
  String? get coverUrl => org.value?.profile?.coverUrl;
  String get profileType => org.value?.isNgo == true ? 'NGO' : 'Community';
  String get followingCount => (org.value?.profile?.followingCount ?? 0).toString();
  String get followersCount => (org.value?.profile?.followersCount ?? 0).toString();
  String get likesCount {
    final l = org.value?.likes;
    if (l == null) return '0';
    return l.toString();
  }

  /// Choose another index (if you later show list)
  void chooseIndex(int index) {
    selectedIndex.value = index;
    update();
  }
}
