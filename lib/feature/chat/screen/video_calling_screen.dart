import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/const/image_path.dart';
import 'package:jdadzok/feature/chat/controller/videocall_controller.dart';
import 'package:jdadzok/feature/chat/screen/ongoing_video_call_screen.dart';

class VideoCallingScreen extends StatelessWidget {
  const VideoCallingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VideocallController());

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImagePath.callingImage),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(
                child: Column(
                  children: const [
                    SizedBox(height: 50),
                    Text(
                      "David Wayne",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // White so it's visible on bg
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Calling ...",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70, // Slightly transparent white
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom buttons bar
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 18,
                ),
                margin: const EdgeInsets.only(bottom: 40),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(
                    alpha: .35,
                  ), // Transparent background
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Obx(
                  () => Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildIconButton(
                        icon: controller.isSpeakerOn.value
                            ? Icons.volume_up
                            : Icons.volume_mute,
                        bgColor: Colors.grey[800]!,
                        onTap: controller.toggleSpeaker,
                      ),
                      const SizedBox(width: 20),
                      _buildIconButton(
                        icon: controller.isMicOn.value
                            ? Icons.mic
                            : Icons.mic_off,
                        bgColor: Colors.grey[800]!,
                        onTap: controller.toggleMic,
                      ),
                      const SizedBox(width: 20),
                      _buildIconButton(
                        icon: controller.isCameraOn.value
                            ? Icons.videocam
                            : Icons.videocam_off,
                        bgColor: Colors.grey[800]!,
                        onTap: controller.toggleCamera,
                      ),
                      const SizedBox(width: 20),
                      _buildIconButton(
                        icon: Icons.call_end,
                        bgColor: Colors.green,
                        onTap: () {
                          Get.to(OnGoingVideoCallScreen());
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 25,
        backgroundColor: Colors.white,
        child: Icon(icon, color: bgColor, size: 28),
      ),
    );
  }
}
