import 'package:flutter/material.dart';
import 'package:jdadzok/core/global_widegts/build_gloabal_post_time.dart';
import 'package:jdadzok/core/global_widegts/global_cached_network_image.dart';
import 'package:jdadzok/feature/chat/model/participent_list_model.dart';

class ChatListWidget extends StatelessWidget {
  final ParticipentListModel chat;
  final VoidCallback onTap;

  const ChatListWidget({super.key, required this.chat, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 244.51,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: getCachedNetworkImage(
                      imageUrl: chat.participent.last.avatarUrl,
                      width: 40,
                      height: 40,
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 156,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 156,
                          child: Text(
                            chat.participent.last.name,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                              height: 1.20,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        SizedBox(
                          width: 156,
                          child: Text(
                            chat.lastMessage?.content ?? 'No messages yet',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              // color: chat.unreadCount > 0
                              //     ? const Color(0xFF2D55FF)
                              //     : const Color(0xFF6A6A6A),
                              fontSize: 12,
                              fontFamily: 'Inter',
                              // fontWeight: chat.unreadCount > 0
                              //     ? FontWeight.w500
                              //     : FontWeight.w400,
                              height: 1.20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                chat.lastMessage?.createdAt != null &&
                        chat.lastMessage!.createdAt.isNotEmpty
                    ? buidGlobalPostTime(
                        DateTime.parse(chat.lastMessage!.createdAt),
                      )
                    : Text(''),
                const SizedBox(height: 4),
                // chat.unreadCount > 0
                //     ? Container(
                //         constraints: const BoxConstraints(
                //           minWidth: 20,
                //           minHeight: 20,
                //         ),
                //         padding: const EdgeInsets.symmetric(
                //           horizontal: 6,
                //           vertical: 2,
                //         ),
                //         decoration: const ShapeDecoration(
                //           color: Color(0xFF2D55FF),
                //           shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.all(Radius.circular(10)),
                //           ),
                //         ),
                //         child: Center(
                //           child: Text(
                //             chat.unreadCount.toString(),
                //             textAlign: TextAlign.center,
                //             style: const TextStyle(
                //               color: Colors.white,
                //               fontSize: 11,
                //               fontFamily: 'Inter',
                //               fontWeight: FontWeight.w600,
                //               height: 1.0,
                //             ),
                //           ),
                //         ),
                //       )
                //     : const SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
