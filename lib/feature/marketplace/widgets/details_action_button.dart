import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jdadzok/feature/chat/screen/individual_chat_screen.dart';
import 'package:jdadzok/feature/marketplace/controller/product_details_controller.dart';
import 'package:jdadzok/feature/marketplace/model/marketplace_product_model.dart';
import '../../../core/const/app_colors.dart';
import 'payment_bottomsheet.dart';

Widget buildActionButtons(
  ProductDetailsController controller,
  MarketplaceProduct product,
  String userId,
) {
  return Row(
    children: [
      // Payment Button
      Expanded(
        flex: 2,
        child: GestureDetector(
          onTap: () {
            showPaymentBottomSheet(product);
          },
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                'Payment',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),

      const SizedBox(width: 12),

      // Message Button
      if (userId != product.seller.id)
        Expanded(
          flex: 2,
          child: GestureDetector(
            onTap: () {
              if (product.seller.id.isNotEmpty) {
                Get.to(
                  () => IndividualChatScreen(),
                  arguments: product.seller.id,
                );
              } else {
                EasyLoading.showError('Seller information not available');
              }
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFEFEFEF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'Message',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),

      const SizedBox(width: 12),

      // More Options Button
      GestureDetector(
        onTap: () {
          _showMoreOptions(controller, product);
        },
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFFEFEFEF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.more_vert, color: Colors.black, size: 28),
        ),
      ),
    ],
  );
}

void _showMoreOptions(
  ProductDetailsController controller,
  MarketplaceProduct product,
) {
  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top indicator
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: 20),

          

          // Save to favourite
          _buildBottomSheetOption(
            icon: Icons.favorite_border,
            title: 'Save to favourite',
            onTap: () {
              controller.saveFavoriteProductApiCall(product.id);
              Get.back();
              //EasyLoading.showSuccess('Added to favourites');
            },
          ),

          // Hide Post
          _buildBottomSheetOption(
            icon: Icons.visibility_off,
            title: 'Hide Post',
            onTap: () {
              controller.hideProductApiCall(product.id);
              Get.back();
              EasyLoading.showSuccess('Post hidden');
            },
          ),

          // Report
          // _buildBottomSheetOption(
          //   icon: Icons.flag_outlined,
          //   title: 'Report',
          //   onTap: () {
          //     Get.back();
          //     EasyLoading.showSuccess('Post reported');
          //   },
          // ),

          // Copy link
          // _buildBottomSheetOption(
          //   icon: Icons.link,
          //   title: 'Copy link',
          //   onTap: () {
          //     Get.back();
          //     EasyLoading.showSuccess('Link copied to clipboard');
          //   },
          // ),

          const SizedBox(height: 30),
        ],
      ),
    ),
  );
}

Widget _buildBottomSheetOption({
  required IconData icon,
  required String title,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 15),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.black),
          const SizedBox(width: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    ),
  );
}
