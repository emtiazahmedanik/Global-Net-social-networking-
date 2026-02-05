// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:jdadzok/feature/home/model/feed_response_model.dart';
// import '../../../theme/app_colors.dart';
// import '../../../core/const/icons_path.dart';
// import '../../share/controller/share_controller.dart';
// import 'comments_modal.dart';
// import 'action_button.dart';

// class PostActions extends StatefulWidget {
//   final PostModel post;

//   const PostActions({super.key, required this.post});

//   @override
//   State<PostActions> createState() => _PostActionsState();
// }

// class _PostActionsState extends State<PostActions> {
//   late bool isLiked;
//   late int likesCount;

//   @override
//   void initState() {
//     super.initState();
//     isLiked = widget.post.isLiked;
//     likesCount = widget.post.likes;
//   }

//   void _toggleLike() {
//     setState(() {
//       if (isLiked) {
//         isLiked = false;
//         likesCount--;
//       } else {
//         isLiked = true;
//         likesCount++;
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.symmetric(horizontal: 12),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // Like Button
//               ActionButton(
//                 iconPath: IconsPath.reactionIcon,
//                 count: likesCount,
//                 iconColor: isLiked ? AppColors.redColor : AppColors.greyText,
//                 textColor: isLiked ? AppColors.redColor : AppColors.greyText,
//                 onTap: _toggleLike,
//               ),
//               SizedBox(width: 8),
//               // Comment Button
//               ActionButton(
//                 iconPath: IconsPath.commentIcon,
//                 count: widget.post.comments,
//                 onTap: () {
//                   showModalBottomSheet(
//                     context: context,
//                     isScrollControlled: true,
//                     backgroundColor: Colors.transparent,
//                     builder: (context) => CommentsModal(
//                       post: widget.post,
//                       commentsCount: widget.post.comments,
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//           // Share Button
//           ActionButton(
//             iconPath: IconsPath.shareIcon,
//             text: 'Share',
//             iconSize: 24,
//             onTap: () {
//               final ShareController shareController = Get.put(
//                 ShareController(),
//               );
//               shareController.sharePost(widget.post);
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
