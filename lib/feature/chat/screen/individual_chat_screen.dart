// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/global_widegts/global_cached_network_image.dart';
import 'package:jdadzok/feature/chat/chat_controller/chat_controller.dart';
import 'package:jdadzok/feature/chat/widgets/chat_more_option_widget.dart';
import 'package:jdadzok/feature/real_time_calling/controller/call_controller.dart';
import '../../../core/const/icons_path.dart';
import '../../../theme/app_colors.dart';
import '../widgets/message_bubble_widget.dart';

class IndividualChatScreen extends StatelessWidget {
  IndividualChatScreen({super.key});

  final ChatController controller = Get.put(ChatController());
  final CallController callController = Get.find<CallController>();

  @override
  Widget build(BuildContext context) {
    // Ensure call manager is initialized once after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // If navigation provided a receiverId (from product detail), set it and fetch chat
      final arg = Get.arguments;
      if (arg != null && arg is String && arg.isNotEmpty) {
        if (controller.receiverId == null || controller.receiverId != arg) {
          controller.receiverId = arg;
          controller.selectedUserId.value = arg;
          controller.getChatIdWithUser();
        }
      }
    });

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // =======================
            // HEADER SECTION
            // =======================
            // Header: guard access to participants list to avoid RangeError
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Obx(() {
                // If we have receiver info loaded (new chat from profile), use it
                if (controller.receiverName.isNotEmpty) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: const Icon(
                              Icons.arrow_back,
                              size: 24,
                              color: Color(0xFF111827),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: getCachedNetworkImage(
                              imageUrl: controller.receiverAvatar.value,
                              width: 40,
                              height: 40,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.receiverName.value,
                                style: const TextStyle(
                                  color: Color(0xFF111827),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Online',
                                style: TextStyle(
                                  color: AppColors.greyText,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              callController.startCallWithUser(
                                hostId: controller.userId.value,
                                receiverId: controller.selectedUserId.value,
                                title: 'Video Call',
                                receiverName: controller.receiverName.value,
                              );
                              debugPrint('Video Call started');
                            },
                            child: SvgPicture.asset(
                              IconsPath.audioCallIcon,
                              width: 20,
                            ),
                          ),
                          const SizedBox(width: 15),
                          InkWell(
                            onTap: () {
                              callController.startCallWithUser(
                                hostId: controller.userId.value,
                                receiverId: controller.selectedUserId.value,
                                title: 'Video Call',
                                receiverName: controller.receiverName.value,
                              );
                              debugPrint('Video Call started');
                            },
                            child: SvgPicture.asset(
                              IconsPath.videoCallIcon,
                              width: 20,
                            ),
                          ),
                          const SizedBox(width: 15),
                          // GestureDetector(
                          //   onTap: () {
                          //     ProfileOptionsDialog.showDialogOptions(context);
                          //   },
                          //   child: const Icon(
                          //     Icons.more_vert,
                          //     size: 24,
                          //     color: Color(0xFF111827),
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  );
                }

                // Otherwise, show participant from list or loading
                if (controller.participantsList.isEmpty) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: const Icon(
                          Icons.arrow_back,
                          size: 24,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const CircularProgressIndicator(),
                    ],
                  );
                }

                final participant = controller
                    .participantsList[controller.selectedChatIndex.value]
                    .participent
                    .last;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: const Icon(
                            Icons.arrow_back,
                            size: 24,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: getCachedNetworkImage(
                            imageUrl: participant.avatarUrl,
                            width: 40,
                            height: 40,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              participant.name,
                              style: const TextStyle(
                                color: Color(0xFF111827),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Online',
                              style: TextStyle(
                                color: AppColors.greyText,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            callController.startCallWithUser(
                              hostId: controller.userId.value,
                              receiverId: controller.selectedUserId.value,
                              title: 'Video Call',
                              receiverName: controller.receiverName.value,
                            );
                            debugPrint('Video Call started');
                          },
                          child: SvgPicture.asset(
                            IconsPath.audioCallIcon,
                            width: 20,
                          ),
                        ),
                        const SizedBox(width: 15),
                        InkWell(
                          onTap: () {
                            callController.startCallWithUser(
                              hostId: controller.userId.value,
                              receiverId: controller.selectedUserId.value,
                              title: 'Video Call',
                              receiverName: controller.receiverName.value,
                            );
                            debugPrint('Video Call started');
                          },
                          child: SvgPicture.asset(
                            IconsPath.videoCallIcon,
                            width: 20,
                          ),
                        ),
                        const SizedBox(width: 15),
                        GestureDetector(
                          onTap: () {
                            ProfileOptionsDialog.showDialogOptions(context);
                          },
                          child: const Icon(
                            Icons.more_vert,
                            size: 24,
                            color: Color(0xFF111827),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
            ),

            // =======================
            // MESSAGES LIST
            // =======================
            Expanded(
              child: Obx(() {
                controller.scrollToBottom();
                return ListView.builder(
                  controller: controller.scrollController,
                  padding: const EdgeInsets.only(top: 20),
                  itemCount: controller.messageList.length + 1,
                  reverse: false,
                  itemBuilder: (context, index) {
                    if (index >= controller.messageList.length) {
                      return SizedBox.shrink();
                    }
                    final bool isMe =
                        controller.messageList[index].senderId ==
                        controller.userId.value;
                    return MessageBubbleWidget(
                      message: controller.messageList[index],
                      isMe: isMe,
                    );
                  },
                );
              }),
            ),

            // =======================
            // MESSAGE INPUT AREA
            // =======================
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => controller.openAttachmentSheet(context),
                    child: Container(
                      width: 43,
                      height: 43,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDEDED),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(Icons.add, color: Color(0xFF6A6A6A)),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Obx(() {
                    if (controller.selectedMediaPath.value.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return Stack(
                      children: [
                        controller.mediaType.value == "IMAGE"
                            ? Image.file(
                                File(controller.selectedMediaPath.value),
                                width: 43,
                                height: 43,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                color: Colors.grey.shade300,
                                width: 43,
                                height: 43,
                                child: Icon(
                                  Icons.play_circle_outline_outlined,
                                  color: Colors.black,
                                  size: 18,
                                ),
                              ),

                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () =>
                                controller.selectedMediaPath.value = '',
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),

                  const SizedBox(width: 10),

                  // Input box
                  Expanded(
                    child: Container(
                      height: 43,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDEDED),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controller.messageController,
                              decoration: const InputDecoration(
                                hintText: 'write your message',
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                          SvgPicture.asset(
                            IconsPath.voiceMessageIcon,
                            width: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  GestureDetector(
                    onTap: () => controller.sendMessage(
                      controller.messageController.text.trim(),
                    ),
                    child: Container(
                      width: 43,
                      height: 43,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Attachment sheet moved to controller: controller.openAttachmentSheet(context)
}
