import 'package:flutter/material.dart';
import 'package:jdadzok/core/global_widegts/build_gloabal_post_time.dart';
import 'package:jdadzok/core/global_widegts/global_cached_network_image.dart';
import 'package:jdadzok/feature/home/model/comment_response_model.dart';
import '../../../theme/app_colors.dart';

class CommentItem extends StatelessWidget {
  final CommentResponseModel comment;

  const CommentItem({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: SizedBox(
            height: 40,
            width: 40,
            child: getCachedNetworkImage(
              imageUrl: comment.author?.authorProfile?.avatarUrl ?? '',
            ),
          ),
        ),

        //getCachedNetworkImage(imageUrl: comment.author.)
        const SizedBox(width: 10),

        // Comment content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Author name and content
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    //comment.authorName,
                    comment.author?.authorProfile?.name ?? '',
                    style: const TextStyle(
                      color: AppColors.black,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          maxLines: 3,
                          '${comment.text}   ',
                          style: TextStyle(
                            color: Color(0xFF6A6A6A),
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      if (comment.createdAt != null)
                        buidGlobalPostTime(DateTime.parse(comment.createdAt!)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (comment.mediaUrl != null)
                    comment.mediaUrl!.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: getCachedNetworkImage(
                              imageUrl: comment.mediaUrl ?? '',
                              width: double.maxFinite,
                              height: 160,
                            ),
                          )
                        : SizedBox.shrink(),
                ],
              ),

              // View replies if has replies
              // if (comment.hasReplies) ...[
              //   const SizedBox(height: 5),
              //   GestureDetector(
              //     onTap: () {
              //       // Handle view replies
              //     },
              //     child: Row(
              //       children: [
              //         Text(
              //           'View replies (${comment.repliesCount})',
              //           style: const TextStyle(
              //             color: Color(0xFF6A6A6A),
              //             fontSize: 12,
              //             fontFamily: 'Inter',
              //             fontWeight: FontWeight.w500,
              //           ),
              //         ),
              //         const SizedBox(width: 3),
              //         const Icon(
              //           Icons.keyboard_arrow_down,
              //           size: 12,
              //           color: Color(0xFF6A6A6A),
              //         ),
              //       ],
              //     ),
              //   ),
              // ],
            ],
          ),
        ),
      ],
    );
  }
}
