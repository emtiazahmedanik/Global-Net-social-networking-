import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:jdadzok/core/const/image_path.dart';
import 'package:jdadzok/feature/chat/chat_controller/chat_controller.dart';
import 'package:jdadzok/feature/chat/screen/individual_chat_screen.dart';

import '../../../theme/app_colors.dart';
import '../widgets/chat_list_widget.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatController controller = Get.put(ChatController());

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 19),
              child: Row(
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const ShapeDecoration(
                        color: AppColors.lightGrey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 24,
                        color: Color(0xFF111827),
                      ),
                    ),
                  ),

                  // Centered title
                  Expanded(
                    child: const Text(
                      'Chat',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 18,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  // Search button
                  // GestureDetector(
                  //   onTap: () {
                  //     // handle your functionality
                  //   },
                  //   child: Container(
                  //     width: 38,
                  //     height: 38,
                  //     padding: const EdgeInsets.all(7),
                  //     decoration: const ShapeDecoration(
                  //       color: AppColors.lightGrey,
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.all(Radius.circular(100)),
                  //       ),
                  //     ),
                  //     child: SvgPicture.asset(
                  //       IconsPath.searchIcon,
                  //       width: 22,
                  //       height: 22,
                  //       colorFilter: const ColorFilter.mode(
                  //         Color(0xFF111827),
                  //         BlendMode.srcIn,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Online users section
                    Obx(
                      () => SizedBox(
                        height: 70,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.participantsList.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 16),
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: ShapeDecoration(
                                    image: DecorationImage(
                                      image:
                                          controller
                                              .participantsList[index]
                                              .participent
                                              .last
                                              .avatarUrl
                                              .isNotEmpty
                                          ? NetworkImage(
                                              controller
                                                  .participantsList[index]
                                                  .participent
                                                  .last
                                                  .avatarUrl,
                                            )
                                          : AssetImage(ImagePath.profileImage009),
                                      fit: BoxFit.cover,
                                    ),
                                    shape: const CircleBorder(),
                                  ),
                                ),
                                Text(controller.participantsList[index].participent.last.name)
                              ],
                            );
                          },
                        ),
                      ),
                    ),

                    
                    Divider(color: Colors.grey.shade100,),
                    const SizedBox(height: 20),

                    // Chat list
                    Expanded(
                      child: Obx(
                        () => ListView.separated(
                          itemCount: controller.participantsList.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 20),
                          itemBuilder: (context, index) {
                            //return SizedBox.shrink();
                            final chat = controller.participantsList[index];
                            return ChatListWidget(
                              chat: chat,
                              onTap: () {
                                controller.selectedChatIndex.value = index;
                                controller.selectedUserId.value =
                                    chat.participent.last.userId;
                                controller.selectedChatId.value =
                                    chat.participent.last.chatId;
                                debugPrint(
                                  'tapped id is : ${controller.selectedUserId.value}',
                                );
                                Get.to(() => IndividualChatScreen());
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
