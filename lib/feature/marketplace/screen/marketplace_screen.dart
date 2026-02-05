import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/feature/marketplace/controller/marketplace_controller.dart';
import '../widgets/marketplace_header.dart';
import '../widgets/category_filters.dart';
import '../widgets/product_grid.dart';
import 'create_ad_post_screen.dart';

class MarketplaceScreen extends StatelessWidget {
  MarketplaceScreen({super.key});

  final controller = Get.put(MarketplaceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async{
          controller.selectedCategory.value = 'All';
          await controller.callApies();
          },
        child: SafeArea(
          child: Column(
            children: [
              MarketplaceHeader(
                title: 'Marketplace',
                buttonText: 'Post',
                onButtonPressed: () {
                  Get.to(CreateAdPostScreen());
                },
                enableBackButton: false,
                isSearchEnabled: true,
              ),
              const SizedBox(height: 16),
              CategoryFilters(),
              const SizedBox(height: 16),
              Expanded(child: ProductGrid()),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
