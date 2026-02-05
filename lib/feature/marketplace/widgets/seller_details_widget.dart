import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/const/app_colors.dart';
import 'package:jdadzok/core/global_widegts/global_cached_network_image.dart';
import 'package:jdadzok/feature/marketplace/controller/product_details_controller.dart';
import 'package:jdadzok/feature/marketplace/model/single_product_response.dart';

class SellerDetailsWidget extends StatelessWidget {
  SellerDetailsWidget({super.key});

  final ProductDetailsController controller =
      Get.find<ProductDetailsController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final SingleProductResponse? singleProductModel =
          controller.singleProductResponse.value;
      final Seller? seller = singleProductModel?.data?.seller;

      debugPrint('product id: ${singleProductModel?.data?.id}');
      debugPrint('avatr url: ${seller?.profile?.avatarUrl}');
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Seller Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E5E5)),
            ),
            child: Column(
              children: [
                // Profile Section
                Row(
                  children: [
                    // Profile Picture
                    ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: getCachedNetworkImage(
                          imageUrl: seller?.profile?.avatarUrl ?? '',
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Name and Title
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                seller?.profile?.name ?? '',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 6),
                              // Verified Badge
                              Container(
                                width: 18,
                                height: 18,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF4285F4),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 12,
                                ),
                              ),
                              const SizedBox(width: 4),
                              // Bell Icon
                              const Icon(
                                Icons.notifications,
                                color: Color(0xFF4CAF50),
                                size: 18,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Content Creator',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Stats Row
                Row(
                  children: [
                    _buildStatItem(
                      seller?.metrics?.totalFollowing.toString() ?? '0',
                      'Following',
                    ),
                    const SizedBox(width: 24),
                    _buildStatItem(
                      seller?.metrics?.totalFollowers.toString() ?? '0',
                      'Followers',
                    ),
                    const SizedBox(width: 24),
                    _buildStatItem(
                      seller?.metrics?.totalLikes.toString() ?? '0',
                      'Likes',
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Action Buttons
                if (controller.userId.value != seller?.id)
                  Obx(() {
                    if (controller.isFriendReqSent.value) {
                      return ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        child: Row(
                          spacing: 12,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text('Request sent'), Icon(Icons.done)],
                        ),
                      );
                    }
                    return Row(
                      children: [
                        // Add Friend Button
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              if (seller?.id != null &&
                                  seller!.id!.isNotEmpty) {
                                await controller.sendFriendRequest(
                                  id: seller.id!,
                                );
                              } else {
                                EasyLoading.showError("Seller ID not found!");
                              }
                            },

                            child: Container(
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(width: 8),
                                  Text(
                                    'Add Friend',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  SizedBox(width: 8),

                                  Icon(
                                    Icons.person_add,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Share Button
                        // GestureDetector(
                        //   onTap: () {
                        //     EasyLoading.showSuccess('Sharing profile...');
                        //   },
                        //   child: Container(
                        //     width: 44,
                        //     height: 44,
                        //     decoration: BoxDecoration(
                        //       color: const Color(0xFFF5F5F5),
                        //       borderRadius: BorderRadius.circular(22),
                        //     ),
                        //     child: const Icon(
                        //       Icons.share,
                        //       color: Colors.black,
                        //       size: 20,
                        //     ),
                        //   ),
                        // ),
                      ],
                    );
                  }),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildStatItem(String count, String label) {
    return Row(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
