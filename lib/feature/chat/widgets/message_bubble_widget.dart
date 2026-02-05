import 'package:flutter/material.dart';
import 'package:jdadzok/core/global_widegts/build_gloabal_post_time.dart';
import 'package:jdadzok/feature/chat/model/message_model.dart';

class MessageBubbleWidget extends StatelessWidget {
  final MessageModel message;
  final bool isMe;

  const MessageBubbleWidget({
    super.key,
    required this.message,
    required this.isMe
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
            left: isMe ? 60 : 16,
            right: isMe ? 16 : 60,
            bottom: 8,
          ),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: ShapeDecoration(
            color: isMe ? const Color(0xFF2D55FF) : const Color(0xFFEDEDED),
            shape: RoundedRectangleBorder(
              borderRadius: isMe
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(17),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(2),
                    )
                  : const BorderRadius.only(
                      topLeft: Radius.circular(17),
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(2),
                      bottomRight: Radius.circular(30),
                    ),
            ),
          ),

          
          child: _buildMessageContent(),
        ),

        // TIME + READ RECEIPT
        Container(
          margin: EdgeInsets.only(
            left: isMe ? 0 : 16,
            right: isMe ? 16 : 0,
            bottom: 16,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              buidGlobalPostTime(DateTime.parse(message.time)),
              if (isMe) ...[
                const SizedBox(width: 4),
                // Icon(
                //   message.isRead ? Icons.done_all : Icons.done,
                //   size: 16,
                //   color: message.isRead
                //       ? const Color(0xFF2D55FF)
                //       : const Color(0xFF6A6A6A),
                // )
              ]
            ],
          ),
        ),
      ],
    );
  }

  // -------------------------------------------------------------
  // 🔥 DIFFERENT MESSAGE TYPES (TEXT / IMAGE / FILE)
  // -------------------------------------------------------------
  Widget _buildMessageContent() {
    switch (message.mediaType) {
      case 'IMAGE':
        return _buildImageMessage();

      // case 'VIDEO':
      //   return _buildFileMessage();

      default:
        return _buildTextMessage();
    }
  }

  // -------------------------------------------------------------
  // 📝 TEXT MESSAGE
  // -------------------------------------------------------------
  Widget _buildTextMessage() {
    return Text(
      message.content,
      style: TextStyle(
        color: isMe ? Colors.white : const Color(0xFF161616),
        fontSize: 12,
        height: 1.2,
      ),
    );
  }

  // -------------------------------------------------------------
  // 🖼️ IMAGE MESSAGE
  // -------------------------------------------------------------
  Widget _buildImageMessage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Image.network(
        message.mediaUrl,
        width: 180,
        height: 180,
        fit: BoxFit.cover,
        errorBuilder: (ctx, err, stack) => const Icon(
          Icons.broken_image,
          size: 60,
          color: Colors.grey,
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // 📄 FILE (PDF, DOC, ZIP etc.)
  // -------------------------------------------------------------
  // Widget _buildFileMessage() {
  //   return GestureDetector(
  //     onTap: () {
  //       
  //     },
  //     child: Row(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         const Icon(Icons.insert_drive_file, color: Colors.white),
  //         const SizedBox(width: 8),
  //         Expanded(
  //           child: Text(
  //             message.fileName ?? "File",
  //             overflow: TextOverflow.ellipsis,
  //             style: TextStyle(
  //               color: message.isMe ? Colors.white : const Color(0xFF161616),
  //               fontSize: 12,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
