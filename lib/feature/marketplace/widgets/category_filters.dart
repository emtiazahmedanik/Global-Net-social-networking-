// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/const/app_colors.dart';
import 'package:jdadzok/feature/marketplace/controller/marketplace_controller.dart';

class CategoryFilters extends StatelessWidget {
  const CategoryFilters({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MarketplaceController>();

    return SizedBox(
      height: 50,
      child: Obx(() {
        final svalue = controller.selectedCategory.value;
        return ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: controller.categories.length,
          separatorBuilder: (_,_) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            String title = controller.categories[index];
            bool isSelected = controller.selectedCategory.value == title;

            return GestureDetector(
              onTap: () {
                controller.selectedCategory.value = title;
                if(controller.selectedCategory.value == 'All'){
                  controller.fetchAllProducts();
                  return;
                }
                controller.fetchCategoryAllProducts(query: title);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryColor : Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: isSelected ? Colors.grey[800]! : Colors.grey[300]!,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  // return _buildCategoryChip(
  //             title,
  //             null, // your API has no icon, so keep null
  //             isSelected,
  //             () => controller.selectCategory(title),
  //           );

}
