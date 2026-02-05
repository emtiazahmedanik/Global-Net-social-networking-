import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/global_widegts/build_gloabal_post_time.dart';
import 'package:jdadzok/feature/home/model/feed_response_model.dart';
import 'package:jdadzok/feature/public_view/screen/public_profile_view.dart';
import '../../../theme/app_colors.dart';
import 'post_options_modal.dart';

class PostHeader extends StatelessWidget {
  final PostModel post;

  const PostHeader({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 12, right: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.to(() => PublicProfileView(userId: post.author.id));
                  },
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: ShapeDecoration(
                      image: DecorationImage(
                        image: NetworkImage(post.author.avatarUrl),
                        fit: BoxFit.cover,
                        onError: (exception, stackTrace) {
                          // Handle image loading error
                        },
                      ),
                      shape: OvalBorder(),
                    ),
                    child: post.author.avatarUrl.isEmpty
                        ? Icon(
                            Icons.person,
                            color: AppColors.greyText,
                            size: 24,
                          )
                        : null,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              post.author.name,
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: 14,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w700,
                                height: 1,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // if (post.isVerified) ...[
                          //   SizedBox(width: 10),
                          //   Row(
                          //     mainAxisSize: MainAxisSize.min,
                          //     children: [
                          //       SvgPicture.asset(
                          //         IconsPath.verifiedIcon,
                          //         width: 14,
                          //         height: 16,
                          //       ),
                          //       SizedBox(width: 3),
                          //       Text(
                          //         'Verified',
                          //         style: TextStyle(
                          //           color: AppColors.primaryColor,
                          //           fontSize: 12,
                          //           fontFamily: 'Inter',
                          //           fontWeight: FontWeight.w400,
                          //           height: 1,
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ],
                          //changed with capIcon
                          SizedBox(width: 0),

                          // if (post.capIcons != null) ...[
                          //   Image.asset(
                          //     IconsPath.capIcon,
                          //     height: 16,
                          //     width: 16,
                          //   ),
                          // ],
                          if (post.taggedUsers.isNotEmpty) ...[
                            SizedBox(width: 5),
                            // Text(
                            //   'is with ${post.taggedUsers.map((e) => e.name).join(', ')}',
                            //   style: TextStyle(
                            //     color: AppColors.greyText,
                            //     fontSize: 12,
                            //     fontFamily: 'Lato',
                            //     fontWeight: FontWeight.w600,
                            //     height: 1,
                            //   ),
                            // ),
                            RichText(
                              text: TextSpan(
                                text: 'is with ',
                                style: TextStyle(
                                  color: AppColors.greyText,
                                  fontSize: 12,
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.w600,
                                  height: 1,
                                ),
                                children: post.taggedUsers
                                    .map(
                                      (e) => TextSpan(
                                        text: e.name,
                                        style: TextStyle(
                                          color: AppColors.black,
                                          fontSize: 12,
                                          fontFamily: 'Lato',
                                          fontWeight: FontWeight.w800,
                                          height: 1,
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 5),
                      if(post.metadata.feelings.isNotEmpty)
                      Text(
                        'feeling ${post.metadata.feelings.toLowerCase()}',
                        style: TextStyle(
                          color: AppColors.greyText,
                          fontSize: 12,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w400,
                          height: 1,
                        ),
                      ),
                      buidGlobalPostTime(DateTime.parse(post.createdAt)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => PostOptionsModal(post: post),
              );
            },
            icon: Icon(Icons.more_vert, color: AppColors.greyText, size: 24),
          ),
        ],
      ),
    );
  }
}
