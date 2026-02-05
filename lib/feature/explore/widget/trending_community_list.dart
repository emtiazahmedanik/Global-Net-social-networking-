// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/const/app_colors.dart';
import 'package:jdadzok/core/const/icons_path.dart';
import 'package:jdadzok/core/global_widegts/global_cached_network_image.dart';
import 'package:jdadzok/feature/explore/controller/explore_screen_controller.dart';

class TrendingCommunityList extends StatefulWidget {
  TrendingCommunityList({super.key});

  @override
  State<TrendingCommunityList> createState() => _TrendingCommunityListState();
}

class _TrendingCommunityListState extends State<TrendingCommunityList> {
  final controller = Get.find<ExploreScreenController>();

  @override
  void initState() {
    super.initState();
    // Always fetch fresh trending communities when this widget is created
    controller.fetchTrendingCommuinty();
  }

  Future<void> _onRefresh() async {
    await controller.fetchTrendingCommuinty();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final all = controller.trendingCommunityList;
      final displayList = controller.searchQuery.value.isEmpty
          ? all
          : all.where((item) => item.name?.toLowerCase().contains(controller.searchQuery.value.toLowerCase()) ?? false).toList();

      if (displayList.isEmpty) {
        return Center(
          child: Text(
            controller.searchQuery.value.isEmpty
                ? 'No communities yet'
                : 'No results found',
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.builder(
          itemCount: displayList.length,
          itemBuilder: (context, index) {
            final item = displayList[index];
            final id = item.id ?? '';

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 0.5,
              color: Colors.white,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: getCachedNetworkImage(
                    imageUrl: item.avatarUrl ?? '',
                    width: 50,
                    height: 50,
                  ),
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        shortenText(item.name ?? ''),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      children: [
                        Image.asset(IconsPath.capIcon, width: 16, height: 16),
                        const SizedBox(width: 2),
                        Text("New", style: _textStyle()),
                      ],
                    ),
                  ],
                ),
                subtitle: Row(
                  children: [
                    Text(
                      (item.followersCount ?? 0).toString(),
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'following',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
                trailing: Obx(() {
                  final isFollowing = controller.followStatus[id] == true;
                  final isLoading = controller.loadingFollowingIds.contains(id);

                  if (isLoading) {
                    return SizedBox(
                      width: 80,
                      height: 30,
                      child: Center(child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))),
                    );
                  }

                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isFollowing ? Colors.grey[300] : AppColors.primaryColor,
                      foregroundColor: isFollowing ? Colors.black : Colors.white,
                      side: BorderSide(width: 0.5, color: isFollowing ? Colors.grey.shade300 : AppColors.primaryColor),
                      minimumSize: const Size(63, 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: () {
                      controller.toggleCommunityFollow(id, index);
                    },
                    child: Text(isFollowing ? "Following" : "Follow"),
                  );
                }),
              ),
            );
          },
        ),
      );
    });
  }
}

TextStyle _textStyle() {
  return TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryColor,
  );
}

String shortenText(String text) {
  if (text.length <= 10) {
    return text;
  }
  return "${text.substring(0, 10)}..";
}