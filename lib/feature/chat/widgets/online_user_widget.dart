import 'package:flutter/material.dart';
import '../model/chat_model.dart';

class OnlineUserWidget extends StatelessWidget {
  final ChatModel user;

  const OnlineUserWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile image with online indicator overlay
          Stack(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: ShapeDecoration(
                  image: DecorationImage(
                    image: AssetImage(user.profileImage),
                    fit: BoxFit.cover,
                  ),
                  shape: const OvalBorder(),
                ),
              ),
              if (user.isOnline)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: const ShapeDecoration(
                      color: Color(0xFF22C55E),
                      shape: OvalBorder(
                        side: BorderSide(width: 2, color: Colors.white),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 50,
            child: Text(
              user.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF111827),
                fontSize: 12,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 1.20,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
