import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/const/image_path.dart';
import 'package:jdadzok/feature/real_time_calling/controller/call_controller.dart';

class IncomingCallScreen extends StatelessWidget {
  // final String callerName;
  // final String callerImage;
  // final bool isVideoCall;

   IncomingCallScreen({
    super.key,
    // required this.callerName,
    // required this.callerImage,
    // this.isVideoCall = false,
  });

  final CallController callController = Get.find<CallController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          /// Background Image
          // Image.network(
          //   callerImage,
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

                /// Caller Info
                Column(
                  children: [

                    Obx(
                      () =>callController.callerImage.value.isNotEmpty ? CircleAvatar(
                        radius: 55,
                        backgroundImage: NetworkImage(callController.callerImage.value),
                      ) : CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.grey,
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    
                    // CircleAvatar(
                    //   radius: 55,
                    //   backgroundColor: Colors.grey,
                    //   child: Icon(
                    //     Icons.person,
                    //     size: 60,
                    //     color: Colors.white,
                    //   ),
                    // ),
                    const SizedBox(height: 20),
                    Obx(
                      () => Text(
                        callController.callerName.value,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Incoming video call',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),

                /// Buttons
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      /// Decline
                      _callButton(
                        icon: Icons.call_end,
                        color: Colors.red,
                        label: 'Decline',
                        onTap: () {
                          callController.declineCall();
                        },
                      ),

                      /// Accept
                      _callButton(
                        icon: Icons.videocam,
                        color: Colors.green,
                        label: 'Accept',
                        onTap: () {
                          // Accept call and navigate to video call screen
                          callController.acceptCall();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _callButton({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
            radius: 35,
            backgroundColor: color,
            child: Icon(icon, color: Colors.white, size: 30),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
