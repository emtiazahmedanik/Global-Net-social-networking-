// edit_ngo_community_profile_controller.dart
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:jdadzok/core/http_service/http_network_client.dart';
import 'package:jdadzok/core/network_caller/endpoints.dart';
import 'package:jdadzok/core/services_class/upload_file_service/upload_aws_file.dart';
import 'package:jdadzok/feature/create_ngo/create_ngo_verify_screen/controller/create_ngo_verify_controller.dart';
import 'package:jdadzok/feature/create_ngo/create_ngo_verify_screen/model/create_ngo_verify_model.dart';

class EditNgoCommunityProfileController extends GetxController {
  late final args = Get.arguments;
  CreateNgoVerifyController? createNgoVerifyController;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Text controllers
  final TextEditingController communityNameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController communityTypeController = TextEditingController();
  final TextEditingController fieldOfWorkController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  RxBool isNgo = false.obs;
  Rx<OrganizationModel?> existingOrg = Rx<OrganizationModel?>(
    null,
  ); // optional for edit

  // date
  Rx<DateTime?> selectedDate = Rx<DateTime?>(DateTime(2025, 1, 23));

  // picked image (local) — user may pick new image when editing
  Rx<File?> pickedImage = Rx<File?>(null);

  // cover image (local)
  Rx<File?> coverImage = Rx<File?>(null);

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();

    // Try to get CreateNgoVerifyController if it exists
    try {
      createNgoVerifyController = Get.find<CreateNgoVerifyController>();
    } catch (e) {
      if (kDebugMode) print('CreateNgoVerifyController not found: $e');
      createNgoVerifyController = null;
    }

    isNgo.value = args['isNgo'] as bool;
    // Check for 'org' (used in navigation) or 'existingOrg' (for backward compatibility)
    existingOrg.value =
        args['org'] as OrganizationModel? ??
        args['existingOrg'] as OrganizationModel?;

    if (kDebugMode) {
      print('Edit screen - isNgo: ${isNgo.value}');
      print('Edit screen - existingOrg: ${existingOrg.value?.profile?.name}');
    }

    // Prefill if editing
    if (existingOrg.value != null) {
      communityNameController.text = existingOrg.value!.profile?.name ?? '';
      communityTypeController.text = existingOrg.value!.type ?? '';
      fieldOfWorkController.text = existingOrg.value!.about?.mission ?? '';
      aboutController.text = existingOrg.value!.profile?.bio ?? '';
      addressController.text = existingOrg.value!.profile?.location ?? '';

      if (existingOrg.value!.about?.foundingDate != null) {
        selectedDate.value = existingOrg.value!.about!.foundingDate;
      }

      if (kDebugMode) {
        print('Fields populated:');
        print('  Name: ${communityNameController.text}');
        print('  Type: ${communityTypeController.text}');
        print('  Mission: ${fieldOfWorkController.text}');
        print('  Bio: ${aboutController.text}');
        print('  Location: ${addressController.text}');
        print('  Date: ${dateController.text}');
      }
    }

    dateController.text = formattedDate;
  }

  String get formattedDate => selectedDate.value != null
      ? DateFormat('dd/MM/yyyy').format(selectedDate.value!)
      : '';

  void pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      selectedDate.value = picked;
      dateController.text = formattedDate;
    }
  }

  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        pickedImage.value = File(image.path);
      }
    } catch (e) {
      if (kDebugMode) print("Error picking image: $e");
    }
  }

  Future<void> pickCoverFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        coverImage.value = File(image.path);
      }
    } catch (e) {
      if (kDebugMode) print("Error picking cover image: $e");
    }
  }

  /// Update (PATCH) or Create (POST) depending on existingOrg presence.
  /// For an edit flow you will normally pass existingOrg non-null and controller will PATCH.
  void onClickUpdate() async {
    // validations
    // ignore: unnecessary_null_comparison
    if (existingOrg == null && pickedImage.value == null) {
      EasyLoading.showError("Upload Image");
      return;
    }
    if (communityTypeController.text.isEmpty) {
      EasyLoading.showError("Select Type");
      return;
    }

    try {
      EasyLoading.show();

      String avatarUrl = '';
      String coverUrl = '';

      // If picked new avatar image, upload; else keep existing
      if (pickedImage.value != null) {
        avatarUrl = await UploadAwsFile.uploadFile(pickedImage.value!);
        if (avatarUrl.isEmpty) {
          EasyLoading.showError('Upload Image Failed');
          return;
        }
      } else {
        avatarUrl = existingOrg.value?.profile?.avatarUrl ?? '';
      }

      // If picked new cover image, upload; else keep existing
      if (coverImage.value != null) {
        coverUrl = await UploadAwsFile.uploadFile(coverImage.value!);
        if (coverUrl.isEmpty) {
          EasyLoading.showError('Cover upload failed');
          return;
        }
      } else {
        coverUrl = existingOrg.value?.profile?.coverUrl ?? '';
      }

      // Build date
      final selectedDateStr = dateController.text.trim(); // dd/MM/yyyy
      final date = DateFormat("dd/MM/yyyy").parse(selectedDateStr, true);
      final isoDate = date.toUtc().toIso8601String();

      // Build body following swagger edit payload
      final Map<String, dynamic> body = {
        if (isNgo.value)
          'ngoType': communityTypeController.text.trim()
        else
          'communityType': communityTypeController.text.trim(),
        "profile": {
          "name": communityNameController.text.trim(),
          "username": null,
          "title": null,
          "bio": aboutController.text.trim(),
          "avatarUrl": avatarUrl,
          "coverUrl": coverUrl,
          "location": addressController.text.trim(),
        },
        "about": {
          "location": addressController.text.trim(),
          "foundingDate": isoDate,
          "mission": fieldOfWorkController.text.trim(),
          "website": null,
        },
      };

      // ignore: unnecessary_null_comparison
      final bool isUpdate = existingOrg != null;
      String url = '';
      if (isUpdate) {
        final id = existingOrg.value!.id;
        if (isNgo.value) {
          url = Urls.updateNgo.replaceAll('{id}', id);
        } else {
          url = Urls.updateCommunity.replaceAll('{id}', id);
        }
      } else {
        url = isNgo.value ? Urls.createNgo : Urls.createCommunity;
      }

      dynamic response;
      if (isUpdate) {
        // ensure HttpNetworkClient supports patchRequest
        response = await HttpNetworkClient().patchRequest(url: url, body: body);
      } else {
        response = await HttpNetworkClient().postRequest(url: url, body: body);
      }

      final responseBody = response.responseData;
      debugPrint('update/create response: $responseBody');

      if (responseBody != null && responseBody['success'] == true) {
        EasyLoading.dismiss();
        EasyLoading.showSuccess(isUpdate ? 'Updated successfully' : 'Created successfully');

        // Refresh controllers if available
        createNgoVerifyController?.fetchMyCommunities();
        createNgoVerifyController?.fetchMyNgos();
        // Navigate back to verify screen and refresh (you can customize)
         // ba previous
      } else {
        EasyLoading.showError('Request Failed');
        if (kDebugMode) print(responseBody);
      }
    } catch (e) {
      if (kDebugMode) print('post ngo error : $e');
      EasyLoading.showError('Something went wrong');
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  void onClose() {
    communityNameController.dispose();
    dateController.dispose();
    communityTypeController.dispose();
    fieldOfWorkController.dispose();
    aboutController.dispose();
    addressController.dispose();
    super.onClose();
  }
}
