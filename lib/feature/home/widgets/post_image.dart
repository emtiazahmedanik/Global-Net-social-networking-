import 'package:flutter/material.dart';
import 'package:jdadzok/feature/home/model/feed_response_model.dart';
import '../../../theme/app_colors.dart';

class PostImage extends StatelessWidget {
  final PostModel post;

  const PostImage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    if (post.mediaUrls.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      height: 223,
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          post.mediaUrls.first,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            width: double.infinity,
            height: 223,
            color: AppColors.lightGrey,
            child: Icon(Icons.image, color: AppColors.greyText, size: 48),
          ),
        ),
      ),
    );
  }
}
