// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jdadzok/core/http_service/http_network_client.dart';
import 'package:jdadzok/core/network_caller/endpoints.dart';
import 'package:jdadzok/core/services_class/upload_file_service/upload_aws_file.dart';
import 'package:jdadzok/feature/edit_profile/model/profile_model.dart';

class EditProfileScreenController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String selectedGender = 'Male';

  final List<String> genders = ['Male', 'Female', 'Other'];

  final TextEditingController firstNameTEController = TextEditingController();
  final TextEditingController lastNameTEController = TextEditingController();
  final TextEditingController experienceTEController = TextEditingController();
  final TextEditingController descriptionTEController = TextEditingController();
  final TextEditingController addressTEController = TextEditingController();

  //For Date Of Birth
  Rx<DateTime?> selectedDate = DateTime(2025, 1, 23).obs;
  final dateController = TextEditingController();
  RxBool isValidated = false.obs;

  Rxn<File> coverImage = Rxn<File>();
  Rxn<File> profileImage = Rxn<File>();

  ProfileResponse? profileResponse;
  Rxn<ProfileResponse> profile = Rxn<ProfileResponse>();

  @override
  void onInit() {
    super.onInit();
    dateController.text = formattedDate;
    getProfile();
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

  void getProfile() async {
    final response = await HttpNetworkClient().getRequest(
      url: Urls.getProfileInfo,
    );
    final body = response.responseData;
    if (body != null && body['success'] == true) {
      profileResponse = ProfileResponse.fromJson(body);
      profile.value = profileResponse;
      if (kDebugMode) {
        print(profileResponse?.data?.name);
        print(profileResponse?.data?.user?.email);
        print(profileResponse?.data?.username);
      }
      setInitialValue();
    }
  }

  void onClickSave() async {
    String uploadedCoverImage = '';
    String uploadedProfileImage = '';

    if (kDebugMode) {
      print(coverImage.value?.path);
    }
    validation();
    if (isValidated.value == false) return;
    if (coverImage.value != null) {
      uploadedCoverImage = await UploadAwsFile.uploadFile(coverImage.value!);
    }
    if (profileImage.value != null) {
      uploadedProfileImage = await UploadAwsFile.uploadFile(
        profileImage.value!,
      );
    }

    final input = dateController.text.trim();
    final dt = DateFormat('dd/MM/yyyy').parse(input);
    final isoDob = DateFormat('yyyy-MM-dd').format(dt);

    final Map<String, dynamic> body = {
      "name": firstNameTEController.text,
      "bio": descriptionTEController.text.trim(),
      "location": addressTEController.text.trim(),
      "isToggleNotification": false,
      "dateOfBirth": isoDob,
      "gender": selectedGender.toString(),
      "experience": experienceTEController.text.trim(),
    };

    if (uploadedProfileImage.isNotEmpty) {
      final Map<String, dynamic> avatarUrl = {
        "avatarUrl": uploadedProfileImage,
      };
      body.addAll(avatarUrl);
    }
    if (uploadedCoverImage.isNotEmpty) {
      final Map<String, dynamic> coverUrl = {"coverUrl": uploadedCoverImage};
      body.addAll(coverUrl);
    }

    try {
      final response = await HttpNetworkClient().patchRequest(
        url: Urls.updateProfile,
        body: body,
      );
      final Map<String, dynamic>? responseBody = response.responseData;
      if (responseBody != null && responseBody["success"] == true) {
        EasyLoading.showSuccess('Profile updated successfully');
        coverImage.value = null;
        profileImage.value = null;
        Get.back();
      } else {
        EasyLoading.showError('Profile updated failed');
      }
    } catch (e) {
      debugPrint("post error: $e");
    }

    if (kDebugMode) {
      print(" the final body is $body");
    }
  }

  void setInitialValue() {
    firstNameTEController.text = profileResponse?.data?.name ?? '';
    selectedGender = profileResponse?.data?.gender ?? '';
    experienceTEController.text = profileResponse?.data?.experience ?? '';
    descriptionTEController.text = profileResponse?.data?.bio ?? '';
    experienceTEController.text = profileResponse?.data?.experience ?? '';
    addressTEController.text = profileResponse?.data?.location ?? '';
    if (profileResponse?.data?.dateOfBirth != null) {
      DateTime dt = DateTime.parse(profileResponse!.data!.dateOfBirth!);
      dateController.text = DateFormat('dd/MM/yyyy').format(dt);
    }
  }

  void validation() async {
    if (firstNameTEController.text.trim().isEmpty) {
      return await EasyLoading.showError('Please enter your first name');
    } else if (dateController.text.trim().isEmpty) {
      return await EasyLoading.showError('Please select date of birth');
    } else if (selectedGender.isEmpty) {
      return await EasyLoading.showError('Please select your gender');
    } else if (experienceTEController.text.trim().isEmpty) {
      return await EasyLoading.showError('Please enter your experience');
    } else if (descriptionTEController.text.trim().isEmpty) {
      return await EasyLoading.showError('Please enter description');
    } else if (addressTEController.text.trim().isEmpty) {
      return await EasyLoading.showError('Please enter your address');
    }
    isValidated.value = true;
  }

  @override
  void dispose() {
    firstNameTEController.dispose();
    lastNameTEController.dispose();
    addressTEController.dispose();
    dateController.dispose();
    descriptionTEController.dispose();
    experienceTEController.dispose();
    super.dispose();
  }
}
