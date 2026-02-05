// lib/feature/create_ngo/create_ngo_profile_screen/controller/create_ngo_commuity_profile_controller.dart

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
import 'package:jdadzok/feature/create_ngo/create_ngo_verify_screen/screen/create_ngo_verify_profile_screen.dart';
import 'package:jdadzok/feature/create_ngo/create_ngo_verify_screen/model/create_ngo_verify_model.dart';

class CreateNgoCommuityProfileController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController communityNameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController communityTypeController = TextEditingController();
  final TextEditingController fieldOfWorkController = TextEditingController();

  final TextEditingController aboutController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final bool isNgo;
  final OrganizationModel? existingOrg; // optional for edit
  CreateNgoCommuityProfileController({required this.isNgo, this.existingOrg});

  //this is for using date time
  Rx<DateTime?> selectedDate = DateTime(2025, 1, 23).obs;

  @override
  void onInit() {
    super.onInit();

    // if editing (existingOrg provided) prefill fields
    if (existingOrg != null) {
      communityNameController.text = existingOrg!.profile?.name ?? '';
      communityTypeController.text = existingOrg!.type ?? '';
      fieldOfWorkController.text = existingOrg!.about?.mission ?? '';
      aboutController.text = existingOrg!.profile?.bio ?? '';
      addressController.text = existingOrg!.profile?.location ?? '';

      if (existingOrg!.about?.foundingDate != null) {
        selectedDate.value = existingOrg!.about!.foundingDate;
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

  // Rx variable to hold picked file
  Rx<File?> pickedImage = Rx<File?>(null);

  final ImagePicker _picker = ImagePicker();

  // Function to pick image from gallery
  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        pickedImage.value = File(image.path);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error picking image: $e");
      }
    }
  }

  void onClickCreate() async {
    // If creating (no existingOrg) require image; if editing, image optional
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
      String uploadedFileUrl = '';

      // Upload only if new image picked; if editing and no new image, keep existing avatar
      if (pickedImage.value != null) {
        uploadedFileUrl = await UploadAwsFile.uploadFile(pickedImage.value!);
        if (uploadedFileUrl.isEmpty) {
          EasyLoading.showError('Upload Image Failed');
          return;
        }
      } else {
        uploadedFileUrl = existingOrg?.profile?.avatarUrl ?? '';
      }

      final selectedDateStr = dateController.text.trim(); // dd/MM/yyyy
      final date = DateFormat("dd/MM/yyyy").parse(selectedDateStr, true);
      final isoDob = date.toUtc().toIso8601String();

      final Map<String, dynamic> body = {
        "foundationDate": isoDob,
        "profile": {
          "name": communityNameController.text.trim(),
          "bio": aboutController.text.trim(),
          "avatarUrl": uploadedFileUrl,
          "location": addressController.text.trim(),
        },
        "about": {
          "location": addressController.text.trim(),
          "foundingDate": isoDob,
          "mission": fieldOfWorkController.text.trim(),
        },
      };

      if (isNgo) {
        body.addAll({"ngoType": communityTypeController.text});
      } else {
        body.addAll({"communityType": communityTypeController.text});
      }

      String url = '';
      dynamic response;
      if (existingOrg != null) {
        // update (PATCH)
        final id = existingOrg!.id;
        if (isNgo) {
          url =
              Urls.updateNgo.replaceAll('{id}', id);
        } else {
          url =
              Urls.updateCommunity.replaceAll('{id}', id);
        }
        // Ensure patchRequest exists in your HttpNetworkClient
        response = await HttpNetworkClient().patchRequest(url: url, body: body);
      } else {
        // create (POST)
        url = isNgo ? Urls.createNgo : Urls.createCommunity;
        response = await HttpNetworkClient().postRequest(url: url, body: body);
      }

      final responseBody = response.responseData;
      debugPrint('Ngo Community post/patch response: $responseBody');
      if (responseBody != null && responseBody['success'] == true) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print('response : $responseBody');
        }
        Get.to(() => CreateNgoVerifyProfileScreen(isNgo: isNgo));
      } else {
        EasyLoading.showError('${responseBody['error']}');
        if (kDebugMode) {
          print(responseBody);
        }
      }

      if (kDebugMode) {
        print('final ngo body: $body');
      }
    } catch (e) {
      if (kDebugMode) {
        print('post ngo error : $e');
      }
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  void onClose() {
    // Dispose controllers
    communityNameController.dispose();
    dateController.dispose();
    communityTypeController.dispose();
    fieldOfWorkController.dispose();
    aboutController.dispose();
    addressController.dispose();
    super.onClose();
  }
}
