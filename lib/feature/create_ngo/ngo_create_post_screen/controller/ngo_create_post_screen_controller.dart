// lib/feature/create_ngo/ngo_create_post_screen/controller/ngo_create_post_screen_controller.dart

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jdadzok/core/services_class/upload_file_service/upload_aws_file.dart';
import 'package:jdadzok/feature/create_ngo/ngo_create_post_screen/service/ngo_create_post_api_service.dart';

enum MediaType { none, image, video }

class NgoCreatePostScreenController extends GetxController {
  /// Constructor: pass whether this is an NGO post and optional org id
  final bool isNgo;
  final RxString orgId  = ''.obs; // for ngo -> ngoId, for community -> communityId

  NgoCreatePostScreenController({this.isNgo = false});

  // UI + input
  final TextEditingController postTEController = TextEditingController();
  final RxString postText = ''.obs;

  // toggles
  final RxBool isVolunteerSelected = false.obs;
  final RxBool isDonationSelected = false.obs;

  // media
  final Rx<File?> pickedFile = Rx<File?>(null);
  final Rx<MediaType> mediaType = MediaType.none.obs;

  // posting state
  final RxBool isPosting = false.obs;

  // quick getter
  bool get hasMedia => pickedFile.value != null;

  @override
  void onInit() {
    super.onInit();
    postTEController.addListener(() {
      postText.value = postTEController.text;
    });
  }

  /// Pick image (gallery). Currently only image is used here (like your UI).
  Future<void> pickImage() async {
    try {
      final XFile? picked = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picked != null) {
        pickedFile.value = File(picked.path);
        mediaType.value = MediaType.image;
        EasyLoading.showInfo('Image selected');
        update();
      } else {
        if (kDebugMode) print('No image selected');
      }
    } catch (e) {
      if (kDebugMode) print('pickImage error: $e');
      EasyLoading.showError('Failed to pick image');
    }
  }

  /// Remove selected media
  void removeMedia() {
    pickedFile.value = null;
    mediaType.value = MediaType.none;
  }

  /// Whether user can post (text or media present and not currently posting)
  bool get canPost {
    final textPresent = postText.value.trim().isNotEmpty;
    return (textPresent || hasMedia) && !isPosting.value;
  }

  /// Main create post method for NGO / Community
  Future<void> createPost() async {
    if (!canPost) return;

    isPosting.value = true;
    EasyLoading.show();

    debugPrint('Creating post for ${isNgo ? 'NGO' : 'Community'} with orgId: ${orgId.value}');

    try {
      // upload media if exists
      List<String> mediaUrls = [];
      if (hasMedia && pickedFile.value != null) {
        final uploaded = await UploadAwsFile.uploadFile(pickedFile.value!);
        if (uploaded.isNotEmpty) {
          mediaUrls.add(uploaded);
        } else {
          EasyLoading.showError('Media upload failed');
          isPosting.value = false;
          return;
        }
      }

      // determine postFrom value
      final postFrom = isNgo ? 'NGO' : 'COMMUNITY';

      if (kDebugMode) {
        print('here check: isNgo: $isNgo, orgId: $orgId');
      }
      if (kDebugMode) {
        print('communityId: ${!isNgo ? orgId : null}, ngoId: ${isNgo ? orgId : null}');
      }

      // call API service - this helper wraps HttpNetworkClient
      final success = await ngoCreatePostApiService(
        text: postTEController.text.trim(),
        mediaUrls: mediaUrls,
        mediaType: mediaType.value == MediaType.none ? 'NONE' : (mediaType.value == MediaType.image ? 'IMAGE' : 'VIDEO'),
        visibility: 'PUBLIC', // you can provide dropdown later if required
        postFrom: postFrom,
        ngoId: isNgo ? orgId.value : null,
        communityId: !isNgo ? orgId.value : null,
        acceptVolunteer: isVolunteerSelected.value,
        acceptDonation: isDonationSelected.value,
      );

      if (kDebugMode) {
        print(success);
      }

      if (success) {
        EasyLoading.showSuccess('Post submitted');
        // clear UI
        postTEController.clear();
        removeMedia();
        isPosting.value = false;
        // close page or go back
        Get.back();
      } else {
        EasyLoading.showError('Post failed');
      }
    } catch (e, st) {
      if (kDebugMode) {
        print('ngo create post error: $e');
        print(st);
      }
      EasyLoading.showError('Post failed');
    } finally {
      isPosting.value = false;
      EasyLoading.dismiss();
    }
  }

  @override
  void onClose() {
    postTEController.dispose();
    super.onClose();
  }
}
