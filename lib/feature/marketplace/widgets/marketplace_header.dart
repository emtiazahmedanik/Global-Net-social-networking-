import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/const/app_colors.dart';
import 'package:jdadzok/feature/marketplace/controller/marketplace_controller.dart';

import '../../../core/global_widegts/search_widget.dart';

class MarketplaceHeader extends StatelessWidget {
  const MarketplaceHeader({
    super.key,
    required this.title,
    required this.buttonText,
    this.onButtonPressed,
    required this.enableBackButton,
    required this.isSearchEnabled,
    this.onBackPressed,
  });
  final String title;
  final String buttonText;
  final VoidCallback? onButtonPressed;
  final bool enableBackButton;
  final bool isSearchEnabled;
  final VoidCallback? onBackPressed;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MarketplaceController>();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Top Header
          Row(
            children: [
              if (enableBackButton)
                GestureDetector(
                  onTap: onBackPressed ?? () => Get.back(),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ),
              Expanded(
                child: Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: onButtonPressed,
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text(
                    buttonText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Search Bar
          if (isSearchEnabled)
            SearchWidget(
              searchController: controller.searchController,
              onTapSearch: controller.onTapSearch,
            ),
        ],
      ),
    );
  }
}
