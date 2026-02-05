import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/feature/home/index.dart';
import 'package:jdadzok/feature/home/model/feed_response_model.dart';
import '../../../theme/app_colors.dart';

class PostOptionsModal extends StatelessWidget {
  final PostModel post;

  PostOptionsModal({super.key, required this.post});

  final controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: () {},
          child: DraggableScrollableSheet(
            initialChildSize: 0.45,
            minChildSize: 0.3,
            maxChildSize: 0.6,
            builder: (context, scrollController) => Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  // Handle bar
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    child: Container(
                      width: 40,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),

                  // Options list
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 8,
                        top: 16,
                        bottom: 20,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          children: [
                            _buildOptionItem(
                              context,
                              icon: Icons.person_add_outlined,
                              title: 'Add Friend',
                              onTap: () => _handleOption(context, 'Add Friend'),
                            ),
                            SizedBox(height: 8),
                            _buildOptionItem(
                              context,
                              icon: Icons.share_outlined,
                              title: 'Share Profile',
                              onTap: () =>
                                  _handleOption(context, 'Share Profile'),
                            ),
                            SizedBox(height: 8),
                            _buildOptionItem(
                              context,
                              icon: Icons.bookmark_border,
                              title: 'Save post',
                              onTap: () => _handleOption(context, 'Save post'),
                            ),
                            SizedBox(height: 8),
                            _buildOptionItem(
                              context,
                              icon: Icons.visibility_off_outlined,
                              title: 'Hide Post',
                              onTap: () => _handleOption(context, 'Hide Post'),
                            ),
                            SizedBox(height: 8),
                            _buildOptionItem(
                              context,
                              icon: Icons.report_outlined,
                              title: 'Report',
                              onTap: () => _handleOption(context, 'Report'),
                            ),
                            SizedBox(height: 8),
                            _buildOptionItem(
                              context,
                              icon: Icons.link,
                              title: 'Copy link',
                              onTap: () => _handleOption(context, 'Copy link'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.black),
            SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                color: AppColors.black,
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleOption(BuildContext context, String option) {
    Navigator.of(context).pop();

    // Show feedback message

    switch (option) {
      case 'Add Friend':
        // Handle add friend logic
        controller.sendFriendRequest(userId: post.authorId);
        break;
      case 'Share Profile':
        // Handle share profile logic
        break;
      case 'Save post':
        // Handle save post logic
        controller.savePost(postId: post.id);
        break;
      case 'Hide Post':
        // Handle hide post logic
        controller.hidePost(postId: post.id);
        break;
      case 'Report':
        // Handle report logic
        showReportDialog((reason) {
          if (kDebugMode) {
            print("User reported: $reason");
          }
          controller.reportPost(postId: post.id, reason: reason);
        });
        break;
      case 'Copy link':
        // Handle copy link logic
        break;
    }
  }
}

void showReportDialog(Function(String) onSubmit) {
  final TextEditingController reasonController = TextEditingController();

  Get.defaultDialog(
    title: "Report Post",
    radius: 10,
    content: Column(
      children: [
        Text(
          "Please tell us the reason for reporting this post:",
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: reasonController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: "Enter your reason...",
            border: OutlineInputBorder(),
          ),
        ),
      ],
    ),
    textConfirm: "Submit",
    textCancel: "Cancel",
    confirmTextColor: Colors.white,
    onConfirm: () {
      final reason = reasonController.text.trim();

      if (reason.isNotEmpty) {
        onSubmit(reason); // 👈 return typed reason
        Get.back(); // close dialog
      } else {
        Get.snackbar("Error", "Please enter a reason");
      }
    },
  );
}
