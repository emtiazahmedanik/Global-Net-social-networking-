import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_colors.dart';
import '../controller/home_controller.dart';
import '../widgets/home_header.dart';
import '../widgets/category_chip.dart';
import '../widgets/post_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());

    return Scaffold(
      backgroundColor: AppColors.white,
      body: RefreshIndicator(
        onRefresh: controller.loadFirstPage,
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              // Header
              HomeHeader(
                onSearchChanged: controller.updateSearchText,
                searchController: controller.searchController,
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      // Categories
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 0),
                        child: Obx(
                          () => SizedBox(
                            height: 55,
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              scrollDirection: Axis.horizontal,
                              itemCount: controller.categories.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(width: 8),
                              itemBuilder: (context, index) {
                                final category = controller.categories[index];
                                return CategoryChip(
                                  category: category,
                                  onTap: () =>
                                      controller.selectCategory(category.id),
                                 isFirstCategory: index == 0,
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                      // Posts
                      Obx(() {
                        if (controller.feedResponseList.isEmpty) {
                          return SizedBox.shrink();
                        }
                        if (controller.isFeedPostLoading.value) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        return ListView.builder(
                          padding: EdgeInsets.only(top: 10),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.feedResponseList.length + 1,
                          itemBuilder: (context, index) {
                            if (index == controller.feedResponseList.length) {
                              return controller.isMoreLoading.value
                                  ? const Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 20,
                                      ),
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                  : const SizedBox.shrink();
                            }
                            final post = controller.feedResponseList[index];

                            if (post.likes.isNotEmpty) {
                              for (var data in post.likes) {
                                if (data.userId == controller.userId.value) {
                                  post.isLiked.value = true;
                                }
                              }
                            } else {
                              post.isLiked.value = false;
                            }

                            if (controller.feedResponseList.length > 3) {
                              if (controller.feedResponseList.length - 1 ==
                                  index) {
                                return Center(
                                  child: GestureDetector(
                                    onTap: () async {
                                      await controller.loadNextPage();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.blue.withValues(
                                          alpha: 0.1,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 6,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          spacing: 5,
                                          children: [
                                            Text(
                                              'New Post',
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            Icon(Icons.refresh, size: 12),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            }
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom:
                                    index <
                                        controller.feedResponseList.length - 1
                                    ? 15
                                    : 0,
                              ),
                              child: Column(children: [PostCard(post: post)]),
                            );
                          },
                        );
                      }),

                      const SizedBox(height: 20),
                    ],
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
