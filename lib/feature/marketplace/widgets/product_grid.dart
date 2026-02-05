import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/global_widegts/global_cached_network_image.dart';
import 'package:jdadzok/feature/marketplace/screen/product_details_screen.dart';
import 'package:jdadzok/feature/marketplace/model/marketplace_product_model.dart';
import 'package:jdadzok/feature/marketplace/widgets/build_price.dart';
import 'package:shimmer/shimmer.dart';
import '../controller/marketplace_controller.dart';

class ProductGrid extends StatelessWidget {
  ProductGrid({super.key});

  final controller = Get.put<MarketplaceController>(MarketplaceController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildShimmerGrid();
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 16,
            childAspectRatio: 0.75,
          ),
          itemCount: controller.products.length,
          itemBuilder: (context, index) {
            final product = controller.products[index];
            return _buildProductCard(product);
          },
        ),
      );
    });
  }

  Widget _buildProductCard(MarketplaceProduct product) {
    return GestureDetector(
      onTap: () {
        Get.to(ProductDetailsScreen(product: product));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image with CachedNetworkImage + Shimmer
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child:product.digitalFileUrl.isNotEmpty ? getCachedNetworkImage(imageUrl: product.digitalFileUrl.first ?? '') : getCachedNetworkImage(imageUrl: '')
            ),
          ),

          const SizedBox(height: 8),

          // Price
          buildPrice(product.price.toDouble()),

          const SizedBox(height: 8),

          // Product Title
          Text(
            product.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 4),

          // Location
          Row(
            children: [
              const Icon(Icons.location_on, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  product.location,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


Widget _buildShimmerGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: 6, // arbitrary number of placeholders
        itemBuilder: (_, _) => const ProductShimmerCard(),
      ),
    );
  }

  class ProductShimmerCard extends StatelessWidget {
  const ProductShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Price placeholder
          Container(
            height: 20,
            width: 70,
            color: Colors.white,
          ),

          const SizedBox(height: 8),

          // Title placeholder
          Container(
            height: 16,
            width: double.infinity,
            color: Colors.white,
          ),

          const SizedBox(height: 4),

          // Location row placeholder
          Row(
            children: [
              Container(
                width: 14,
                height: 14,
                color: Colors.white,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Container(
                  height: 12,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}