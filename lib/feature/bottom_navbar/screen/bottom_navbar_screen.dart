import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/const/icons_path.dart';
import 'package:jdadzok/feature/bottom_navbar/controller/bottom_navbar_controller.dart';
import 'package:jdadzok/feature/bottom_navbar/widget/custom_bottom_nav_item.dart';
import 'package:jdadzok/feature/explore/screen/explore_screen.dart';
import 'package:jdadzok/feature/home/screen/home_page.dart';

import 'package:jdadzok/feature/account_preferences/screen/user_account_preferences.dart';

import 'package:jdadzok/feature/marketplace/screen/marketplace_screen.dart';

class BottomNavbarScreen extends StatelessWidget {
  BottomNavbarScreen({super.key});

  final BottomNavbarController controller = Get.put(BottomNavbarController());

  final List<Widget> pages = [
    HomePage(),
    ExploreScreen(),
    Container(), // Placeholder for center action
    MarketplaceScreen(),
    UserAccountPreferences(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.selectedIndex.value,
          children: pages,
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Home
                CustomBottomNavItem(
                  iconPath: IconsPath.homeIcon,
                  isSelected: controller.selectedIndex.value == 0,
                  onTap: () => controller.changeTab(0),
                ),

                // Explorer
                CustomBottomNavItem(
                  iconPath: IconsPath.explorerIcon,
                  isSelected: controller.selectedIndex.value == 1,
                  onTap: () => controller.changeTab(1),
                ),

                // Center Plus / Create Post Button
                CustomBottomNavItem(
                  iconPath: IconsPath.plusIcon,
                  isSelected: false,
                  onTap: () => controller.goToCreatePost(),
                  isCenter: true,
                ),

                // Marketplace
                CustomBottomNavItem(
                  iconPath: IconsPath.marketplaceIcon,
                  isSelected: controller.selectedIndex.value == 3,
                  onTap: () => controller.changeTab(3),
                ),

                // Profile
                CustomBottomNavItem(
                  iconPath: IconsPath.userIcon,
                  isSelected: controller.selectedIndex.value == 4,
                  onTap: () => controller.changeTab(4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
