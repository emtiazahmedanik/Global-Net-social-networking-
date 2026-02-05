import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/const/image_path.dart';
import 'package:jdadzok/feature/real_time_calling/controller/call_controller.dart';

class OutgoingCallScreen extends StatelessWidget {
  // final String calleeName;
  // final String calleeImage;
  // final bool isVideoCall;

   OutgoingCallScreen({
    super.key,
    // required this.calleeName,
    // required this.calleeImage,
    // this.isVideoCall = false,
  });

  final CallController callController = Get.find<CallController>();

  @override
  Widget build(BuildContext context) {
    final String calleeName = Get.arguments ?? 'Callee';
    debugPrint('Callee Name: $calleeName');
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          /// Background Image
          // Image.network(
          //   calleeImage,
          //   fit: BoxFit.cover,
          // ),

          Image.asset(
            ImagePath.callBackground,
            fit: BoxFit.cover,
          ),

          /// Blur Effect
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              color: Colors.black.withValues(alpha: 0.6),
            ),
          ),

          /// Call UI
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 40),

                /// Callee Info
                Column(
                  children: [
                    // CircleAvatar(
                    //   radius: 55,
                    //   backgroundImage: NetworkImage(calleeImage),
                    // ),
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.grey,
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      calleeName,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Calling...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),

                /// End Call Button
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: GestureDetector(
                    onTap: () {


                      callController.declineCall();
                      
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.red,
                          child: const Icon(Icons.call_end,
                              color: Colors.white, size: 30),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'End Call',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
