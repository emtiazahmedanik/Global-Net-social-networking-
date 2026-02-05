import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/feature/marketplace/controller/product_details_controller.dart';
import 'package:jdadzok/feature/marketplace/model/marketplace_product_model.dart';
import '../widgets/build_price.dart';
import '../widgets/build_product_image.dart';
import '../widgets/build_seller_info.dart';
import '../widgets/details_action_button.dart';
import '../widgets/details_description.dart';
import '../widgets/details_header.dart';
import '../widgets/seller_details_widget.dart';

class ProductDetailsScreen extends StatelessWidget {
  final MarketplaceProduct product;

  ProductDetailsScreen({super.key, required this.product});

  final controller = Get.put(ProductDetailsController());

  @override
  Widget build(BuildContext context) {
    controller.productId.value = product.id;
    controller.fetchSingleProductData();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child:  Column(
          children: [
            // Header
            buildHeader(controller),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image
                    buildProductImageCarousel(product.digitalFileUrl),

                    const SizedBox(height: 24),

                    // Price
                    buildPrice(product.price.toDouble()),

                    const SizedBox(height: 12),

                    // Posted Time
                    _buildPostedTime(product.createdAt),

                    const SizedBox(height: 8),

                    // Title
                    _buildTitle(),

                    const SizedBox(height: 8),

                    // Seller Info
                    buildSellerInfo(product),

                    const SizedBox(height: 24),

                    // Action Buttons
                    buildActionButtons(controller,product,controller.userId.value),

                    const SizedBox(height: 24),

                    // Description
                    buildDescription(product.description),

                    const SizedBox(height: 24),

                    // Seller Details
                    SellerDetailsWidget(),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostedTime(DateTime createdAt) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    String timeText;

    if (difference.inSeconds < 60) {
      timeText = "Just now";
    } else if (difference.inMinutes < 60) {
      timeText = "${difference.inMinutes} min ago";
    } else if (difference.inHours < 24) {
      timeText = "${difference.inHours} hours ago";
    } else if (difference.inDays == 1) {
      timeText = "Yesterday";
    } else if (difference.inDays < 30) {
      timeText = "${difference.inDays} days ago";
    } else if (difference.inDays < 365) {
      timeText = "${(difference.inDays / 30).floor()} months ago";
    } else {
      timeText = "${(difference.inDays / 365).floor()} years ago";
    }

    return Text(
      "Posted: $timeText",
      style: const TextStyle(fontSize: 14, color: Colors.grey),
    );
  }

  Widget _buildTitle() {
    return Text(
      product.title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }
}
