import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/const/app_colors.dart';
import 'package:jdadzok/core/global_widegts/build_gloabal_post_time.dart';
import 'package:jdadzok/feature/marketplace/model/marketplace_product_model.dart';
import 'package:jdadzok/feature/marketplace/widgets/build_price.dart';
import '../controller/product_details_controller.dart';

void showPaymentBottomSheet(MarketplaceProduct product) {
  final controller = Get.put(ProductDetailsController());

  // ⭐ IMPORTANT: Set product ID + Price for API
  controller.productId.value = product.id;
  controller.productPrice.value = product.price.toDouble();

  Get.bottomSheet(
    Container(
      height: Get.height * 0.85,
      padding: const EdgeInsets.only(top: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          /// TOP DRAG INDICATOR
          Container(
            width: 45,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// PRODUCT IMAGE
                  Container(
                    width: double.infinity,
                    height: 200,
                    margin: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      image: DecorationImage(
                        image: NetworkImage(product.digitalFileUrl.first),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  /// PRICE
                  buildPrice(product.price.toDouble()),

                  const SizedBox(height: 6),

                 buidGlobalPostTime(product.createdAt),

                  const SizedBox(height: 8),

                  /// TITLE
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 8),

                  /// SELLER INFO (Static Example)
                  Row(
                    children: [
                       Text(
                        product.seller.email,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          color: Color(0xFF4285F4),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  /// ------------------------------
                  /// PLACE ORDER + QUANTITY SECTION
                  /// ------------------------------
                  Row(
                    children: [
                      const Text(
                        "Place an Order",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 10),

                      /// QUANTITY CONTROL
                      Obx(() {
                        return Row(
                          children: [
                            GestureDetector(
                              onTap: controller.decreaseQty,
                              child: Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.remove, size: 20),
                              ),
                            ),
                            const SizedBox(width: 10),

                            Text(
                              controller.quantity.value.toString(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(width: 10),

                            GestureDetector(
                              onTap: controller.increaseQty,
                              child: Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor.withAlpha(180),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.add,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// ADDRESS FIELD
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFEFEF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextFormField(
                      controller: controller.addressController,
                      keyboardType: TextInputType.streetAddress,
                      decoration: const InputDecoration(
                        hintText: "Enter your Address",
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),
                ],
              ),
            ),
          ),

          /// --------------------------------
          /// BOTTOM BUTTON (PLACE ORDER)
          /// --------------------------------
          Container(
            padding: const EdgeInsets.all(20),
            child: GestureDetector(
              onTap: () {
                controller.placeOrderApiCall(product.id);
              },
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Place and Order",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    isScrollControlled: true,
  );
}
