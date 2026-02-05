import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/const/icons_path.dart';
import 'package:jdadzok/feature/home/controller/home_controller.dart';
import 'package:jdadzok/feature/home/model/feed_response_model.dart';
import 'package:jdadzok/feature/home/widgets/action_button.dart';
import 'package:jdadzok/feature/home/widgets/comments_modal.dart';
import 'package:jdadzok/feature/home/widgets/post_video_widget.dart';
import '../../../theme/app_colors.dart';
import 'post_header.dart';
import 'post_content.dart';
import 'post_image.dart';

class PostCard extends StatelessWidget {
  final PostModel post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,
      margin: EdgeInsets.zero,
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: ShapeDecoration(
        color: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        shadows: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 2,
            offset: Offset(0, 0),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post Header
          PostHeader(post: post),

          SizedBox(height: 10),

          // Post Content
          PostContent(post: post),

          SizedBox(height: 10),

          // Post Image
          if (post.mediaType == 'IMAGE' && post.mediaUrls.isNotEmpty && post.mediaUrls.first.isNotEmpty) PostImage(post: post),

          if (post.mediaType == 'VIDEO' && post.mediaUrls.isNotEmpty && post.mediaUrls.first.isNotEmpty) PostVideo(post: post),

          SizedBox(height: 10),

          //UserTypeButtonRow(),
          SizedBox(height: 10),

          LikeCommentShare(postModel: post),

          // Post Actions
          //PostActions(post: post),
        ],
      ),
    );
  }
}

class LikeCommentShare extends StatelessWidget {
  const LikeCommentShare({super.key, required this.postModel});

  final PostModel postModel;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ValueListenableBuilder<bool>(
        valueListenable: postModel.isLiked,
        builder: (context, like, _) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ActionButton(
                    iconPath: IconsPath.reactionIcon,
                    count: postModel.likes.length,
                    iconColor: like ? AppColors.redColor : AppColors.greyText,
                    textColor: like ? AppColors.redColor : AppColors.greyText,
                    onTap: () async {
                      final isNowLiked = !postModel.isLiked.value;
                      postModel.isLiked.value = isNowLiked;
                      if (isNowLiked) {
                        postModel.likes.add(
                          LikeModel.empty()
                        ); // just push anything, only length matters
                      } else {
                        if (postModel.likes.isNotEmpty) {
                          postModel.likes.removeLast();
                        }
                      }

                      await controller.likePostApiCall(postId: postModel.id);
                    },
                  ),
                  const SizedBox(width: 8),
                  ActionButton(
                    iconPath: IconsPath.commentIcon,
                    onTap: () async {
                      await controller.fetchCommentData(postModel.id);

                      showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        context: Get.context!,
                        builder: (_) => CommentsModal(postModel: postModel),
                      );
                    },
                  ),
                ],
              ),
              ActionButton(
                iconPath: IconsPath.shareIcon,
                text: 'Share',
                iconSize: 24,
                onTap: () {
                  controller.sharePostApiCall(postModel.id);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
