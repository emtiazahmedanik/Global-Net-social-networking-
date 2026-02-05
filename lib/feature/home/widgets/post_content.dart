import 'package:flutter/material.dart';
import 'package:jdadzok/feature/home/model/feed_response_model.dart';
import '../../../theme/app_colors.dart';

class PostContent extends StatelessWidget {
  final PostModel post;

  const PostContent({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    if (post.text.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (post.text.isNotEmpty)
            Text(
              post.text,
              style: TextStyle(
                color: AppColors.black,
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                height: 1.50,
              ),
            ),
          // if (post.title != null && post.content != null) SizedBox(height: 4),
          // if (post.content != null)
          //   Text(
          //     post.content!,
          //     style: TextStyle(
          //       color: AppColors.greyText,
          //       fontSize: 14,
          //       fontFamily: 'Inter',
          //       fontWeight: FontWeight.w400,
          //       height: 1.50,
          //     ),
          //   ),
        ],
      ),
    );
  }
}
