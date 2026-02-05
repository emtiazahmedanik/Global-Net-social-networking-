// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/const/image_path.dart';
import 'package:jdadzok/core/global_widegts/search_widget.dart';
import 'package:jdadzok/feature/explore/controller/explore_screen_controller.dart';
import 'package:jdadzok/feature/explore/widget/all_trending_list.dart';
import 'package:jdadzok/feature/explore/widget/explore_screen_button.dart';
import 'package:jdadzok/feature/explore/widget/trending_community_list.dart';
import 'package:jdadzok/feature/explore/widget/trending_ngo_list.dart';

// ignore: must_be_immutable
class ExploreScreen extends StatelessWidget {
  ExploreScreen({super.key});

  final exploreScreenController = Get.put(ExploreScreenController());
  final searchController = TextEditingController();

  List<Widget> pages = [
    AllTrendingList(),
    TrendingCommunityList(),
    TrendingNgoList(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Center(
                child: Text(
                  "Explore",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 29),

              SearchWidget(
                searchController: searchController,
                onTapSearch: () {
                  exploreScreenController.performSearch(searchController.text);
                },
                onChanged: (value) {
                  exploreScreenController.performSearch(value);
                },
              ),
              SizedBox(height: 20),
              Obx(
                () => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      exploreScreenButton(
                        ImagePath.exploreScreenTrendingImage,
                        "Trending",
                        () => exploreScreenController.selectedIndex.value = 0,
                        exploreScreenController.selectedIndex.value == 0,
                      ),
                      SizedBox(width: 10),
                      exploreScreenButton(
                        ImagePath.exploreScreenCommunityImage,
                        "Community",
                        () => exploreScreenController.selectedIndex.value = 1,
                        exploreScreenController.selectedIndex.value == 1,
                      ),
                      SizedBox(width: 10),
                      exploreScreenButton(
                        ImagePath.exploreScreenNGOImage,
                        "NGO",
                        () => exploreScreenController.selectedIndex.value = 2,
                        exploreScreenController.selectedIndex.value == 2,
                      ),
                    ],
                  ),
                ),
              ),

              ///
              SizedBox(height: 20),
              Obx(
                () => Expanded(
                  child: IndexedStack(
                    index: exploreScreenController.selectedIndex.value,
                    children: pages,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
