import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/const/icons_path.dart';
import 'package:jdadzok/feature/marketplace/widgets/marketplace_header.dart';
import 'package:jdadzok/feature/marketplace/widgets/show_get_dialog.dart';
import 'package:jdadzok/theme/app_colors.dart';
import '../controller/create_ad_controller.dart';

class CreateAdPostScreen extends StatelessWidget {
  const CreateAdPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateAdController());

    return PopScope(
      canPop: !controller.hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && controller.hasUnsavedChanges) {
          ShowGetDialog.showDiscardDialog();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // Header
              MarketplaceHeader(
                title: 'New Ad Post',
                buttonText: 'Publish',
                enableBackButton: true,
                onBackPressed: () => controller.handleBackPress(),
                onButtonPressed: () {
                  // Handle post button press
                  controller.postNewAd();
                },
                isSearchEnabled: false,
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category
                      _buildSectionTitle('Category'),
                      const SizedBox(height: 8),
                      _buildCategoryDropdown(controller),

                      const SizedBox(height: 24),

                      // Ads title
                      _buildSectionTitle('Ads title'),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: controller.titleController,
                        hintText: 'What are you selling?',
                      ),

                      const SizedBox(height: 24),

                      // Price
                      _buildSectionTitle('Price'),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: controller.priceController,
                        hintText: 'Enter amount',
                        keyboardType: TextInputType.number,
                      ),

                      const SizedBox(height: 24),

                      // Location
                      _buildSectionTitle('Location'),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: controller.locationController,
                        hintText: 'Enter your location',
                      ),

                      const SizedBox(height: 24),

                      // Description
                      _buildSectionTitle('Description'),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: controller.descriptionController,
                        hintText: 'Write here...',
                        maxLines: 5,
                      ),

                      const SizedBox(height: 24),

                      // Availability
                      _buildSectionTitle('Availability'),
                      const SizedBox(height: 8),

                      //_buildAvailabilityDropdown(controller),
                      _buildTextField(
                        controller: controller.availabilityController,
                        hintText: "Number of available stock",
                        keyboardType: TextInputType.number
                      ),

                      const SizedBox(height: 24),

                      // Selected Images
                      Obx(() => _buildSelectedImages(controller)),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ), // Close SafeArea
      ), // Close Scaffold
    ); // Close WillPopScope
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    TextInputType? keyboardType,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFEFEFEF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
          border: InputBorder.none,
        ),
        style: const TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
  }

  Widget _buildCategoryDropdown(CreateAdController controller) {
    return Obx(
      () => GestureDetector(
        onTap: () => _showCategoryBottomSheet(controller),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFEFEFEF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  controller.selectedCategory.value.isEmpty
                      ? 'Select'
                      : controller.selectedCategory.value,
                  style: TextStyle(
                    fontSize: 16,
                    color: controller.selectedCategory.value.isEmpty
                        ? Colors.grey
                        : Colors.black,
                  ),
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.grey,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildSelectedImages(CreateAdController controller) {
    return Column(
      children: [
        ...controller.selectedImages.map(
          (imagePath) => Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: FileImage(File(imagePath)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: () => controller.removeImage(imagePath),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Add more images button
        GestureDetector(
          onTap: () => controller.pickImage(),
          child: Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primaryColor,
                width: 2,
                style: BorderStyle.solid,
              ),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    IconsPath.imagePickerIcon,
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Upload Media',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showCategoryBottomSheet(CreateAdController controller) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Category',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ...controller.categories.asMap().entries.map((entry) {
                int index = entry.key;
                String category = entry.value;

                return ListTile(
                  title: Text(category),
                  onTap: () {
                    controller.selectedCategory.value = category;
                    controller.selectedCategoryIndex.value = index;
                    Get.back();
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

}
