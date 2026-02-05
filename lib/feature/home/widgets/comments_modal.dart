// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jdadzok/feature/home/index.dart';
import 'package:jdadzok/feature/home/model/feed_response_model.dart';
import 'package:jdadzok/feature/home/widgets/emoji_picker.dart';
import '../../../theme/app_colors.dart';
import 'comment_item.dart';
import 'comment_input.dart';

class CommentsModal extends StatelessWidget {
  CommentsModal({super.key, required this.postModel});

  final PostModel postModel;

  final HomeController controller = Get.find<HomeController>();

  final TextEditingController _commentController = TextEditingController();

  ValueNotifier emojiOnOff = ValueNotifier(false);

  void _handleSendComment() {
    // Add your Logic here
    controller.commentOnPostApiCall(
      postId: postModel.id,
      text: _commentController.text.trim(),
    );

    _showMessage('Comment sent: ${_commentController.text}');
  }

  void _handleFileSelectionChanged(bool hasFile) {
    // Handle file selection state change if needed
  }

    void showEmojiPicker() {
    showModalBottomSheet(
      context: Get.context!,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => EmojiPickerSheet(controller: _commentController),
    );
  }

  void _showMessage(String message) {}

  @override
  Widget build(BuildContext context) {
    debugPrint('comment length: ${controller.commentList.length}');
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: () {},
          child: DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.3,
            maxChildSize: 0.9,
            builder: (context, scrollController) => Container(
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x19000000),
                    blurRadius: 4,
                    offset: Offset(0, -2),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Handle bar
                  Container(
                    padding: const EdgeInsets.only(top: 12),
                    child: Container(
                      width: 40,
                      height: 6,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),

                  // Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${controller.commentList.length} comments',
                          style: const TextStyle(
                            color: AppColors.black,
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: const Icon(
                            Icons.close,
                            size: 24,
                            color: AppColors.greyText,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Content - Comments list
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(16),
                      child: Obx(() {
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: controller.commentList.length,
                          separatorBuilder: (_, _) => SizedBox(height: 15),
                          itemBuilder: (_, index) {
                            final comment = controller.commentList[index];
                            return CommentItem(comment: comment);
                          },
                        );
                      }),
                    ),
                  ),

                  // Comment input
                  CommentInput(
                    controller: _commentController,
                    selectedMediaPath: controller.selectedCommentFilePath,
                    onSend: _handleSendComment,
                    onTapRemoveImage: (){
                      controller.selectedCommentFilePath.value = '';
                    },
                    onFileSelectionChanged: _handleFileSelectionChanged,
                    onPickImage: () async {
                      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
                      controller.selectedCommentFilePath.value = image?.path ?? '';

                    },
                    onEmoji: (){
                      emojiOnOff.value = !emojiOnOff.value;
                    },
                  ),
                  ValueListenableBuilder(
                    valueListenable: emojiOnOff,
                    builder: (context, value, child) {
                      return Visibility(
                        visible: emojiOnOff.value == true,
                        child: EmojiPickerSheet(controller: _commentController));
                    }
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
