import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jdadzok/core/http_service/http_network_client.dart';
import 'package:jdadzok/core/network_caller/endpoints.dart';
import 'package:jdadzok/core/services_class/upload_file_service/upload_aws_file.dart';
import 'package:jdadzok/feature/marketplace/model/category_response_model.dart';
import 'package:jdadzok/feature/marketplace/widgets/show_get_dialog.dart';

class CreateAdController extends GetxController {
  @override
  void onInit() {
    fetchProductCategory();
    super.onInit();
  }

  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController availabilityController = TextEditingController();


  var selectedCategory = ''.obs;
  RxInt selectedCategoryIndex = 0.obs;
  var selectedAvailability = 'In stock'.obs;
  var selectedImages = <String>[].obs;
  var isLoading = false.obs;

  RxList<String> categories = <String>[].obs;
  RxList<String> categoriesId = <String>[].obs;

  final List<String> availabilityOptions = [
    'In stock',
    'Out of stock',
    'Limited stock',
    'Pre-order',
  ];

  final ImagePicker _picker = ImagePicker();

  @override
  void onClose() {
    titleController.dispose();
    priceController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  void fetchProductCategory() async {
    final response = await HttpNetworkClient().getRequest(
      url: Urls.getProductCategory,
    );
    final responseBody = response.responseData;
    if (responseBody != null && responseBody['success'] == true) {
      debugPrint('categpries: $responseBody');
      final CategoryResponse categoryResponse = CategoryResponse.fromJson(
        responseBody,
      );
      categories.value = categoryResponse.data.map((e) => e.name).toList();
      categoriesId.value = categoryResponse.data.map((e) => e.id).toList();
    }
  }

  Future<void> postNewAd() async {
    List<String> urls = [];
    if (categoriesId.isEmpty) {
      EasyLoading.showError('No category available');
      return;
    }
    if (selectedImages.isNotEmpty) {
      debugPrint('images: $selectedImages');
      EasyLoading.show(status: 'Uploading Images..');
      urls = await uploadFilesAws();
      EasyLoading.dismiss();
    }
    

    try {
      final body = {
      "categoryId": categoriesId[selectedCategoryIndex.value],
      "title": titleController.text.trim(),
      "description": descriptionController.text.trim(),
      "price": priceController.text.trim(),
      "isVisible": true,
      "availability": availabilityController.text,
      "location": locationController.text.trim(),
    };
    if(urls.isNotEmpty){
      body.addAll({"digitalFileUrl": urls,});
    }

    debugPrint('final body: $body');

      final response = await HttpNetworkClient().postRequest(url: Urls.marketplaceProducts, body: body);
      final responseBody = response.responseData;
      if(responseBody!=null && responseBody['success']==true){
        EasyLoading.showSuccess('Ad post successful');
        Get.back();
      }
      
    } catch (e) {
      debugPrint("product creation error: $e");
    }
  }

  Future<List<String>> uploadFilesAws() async {
    try {
      List<String> urls = [];
      for (int i = 0; i < selectedImages.length; i++) {
        final file = File(selectedImages[i]);
        String url = await UploadAwsFile.uploadFile(file);
        urls.add(url);
      }
      return urls;
    } catch (e) {
      return [];
    }
  }

  // Check if there are any unsaved changes
  bool get hasUnsavedChanges {
    return titleController.text.trim().isNotEmpty ||
        priceController.text.trim().isNotEmpty ||
        locationController.text.trim().isNotEmpty ||
        descriptionController.text.trim().isNotEmpty ||
        selectedCategory.value.isNotEmpty ||
        selectedImages.isNotEmpty;
  }

  // Show discard confirmation dialog

  // Save draft functionality
  void saveDraft() {
    // In a real app, you would save to local storage or server
    // For demo purposes, just show a success message
    EasyLoading.showSuccess(
      'Draft Saved\nYour ad has been saved as a draft',
      duration: const Duration(milliseconds: 1500),
    );

    // Optionally save form data to local storage here
    // SharedPreferences or GetStorage could be used
  }

  // Handle back button press
  void handleBackPress() {
    if (hasUnsavedChanges) {
      ShowGetDialog.showDiscardDialog();
    } else {
      Get.back();
    }
  }

  // Safe navigation back method
  void navigateBack() {
    try {
      // Simple and direct back navigation
      Get.back();
    } catch (e) {
      // Fallback to marketplace if Get.back() fails
      Get.offNamed('/marketplace');
    }
  }

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        // In a real app, you would upload the image and get a URL
        // For demo purposes, we'll use a placeholder URL
        selectedImages.add(image.path);
        EasyLoading.showSuccess('Image added successfully');
      }
    } catch (e) {
      EasyLoading.showError('Failed to pick image: $e');
    }
  }

  void removeImage(String imagePath) {
    selectedImages.remove(imagePath);
    EasyLoading.showSuccess('Image removed successfully');
  }

  bool _validateForm() {
    if (selectedCategory.value.isEmpty) {
      EasyLoading.showError('Please select a category');
      return false;
    }

    if (titleController.text.trim().isEmpty) {
      EasyLoading.showError('Please enter a title');
      return false;
    }

    if (priceController.text.trim().isEmpty) {
      EasyLoading.showError('Please enter a price');
      return false;
    }

    if (locationController.text.trim().isEmpty) {
      EasyLoading.showError('Please enter a location');
      return false;
    }

    if (descriptionController.text.trim().isEmpty) {
      EasyLoading.showError('Please enter a description');
      return false;
    }

    if (selectedImages.isEmpty) {
      EasyLoading.showError('Please add at least one image');
      return false;
    }

    return true;
  }

  Future<void> publishAd() async {
    if (!_validateForm()) return;

    isLoading.value = true;

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Create ad data
      final adData = {
        'title': titleController.text.trim(),
        'price': double.parse(priceController.text.trim()),
        'location': locationController.text.trim(),
        'description': descriptionController.text.trim(),
        'category': selectedCategory.value,
        'availability': selectedAvailability.value,
        'images': selectedImages.toList(),
        'createdAt': DateTime.now().toIso8601String(),
      };

      // Process the ad data (send to API, save to database, etc.)
      // For demo purposes, we're just showing success message
      // ignore: avoid_print
      debugPrint('Ad data prepared: ${adData.length} fields');

      EasyLoading.showSuccess(
        'Ad published successfully!',
        duration: const Duration(seconds: 2),
      );

      // Clear form
      clearForm();

      // Navigate back or to success screen
      Get.back();
    } catch (e) {
      EasyLoading.showError('Failed to publish ad: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void clearForm() {
    titleController.clear();
    priceController.clear();
    locationController.text = 'Yandee, Cameroon';
    descriptionController.clear();
    selectedCategory.value = '';
    selectedAvailability.value = 'In stock';
    selectedImages.clear();
  }
}
