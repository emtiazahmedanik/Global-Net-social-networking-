import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/const/image_path.dart';
import 'package:jdadzok/feature/chat/controller/videocall_controller.dart';
import 'package:jdadzok/feature/chat/screen/videocall_ended_screen.dart';

class OnGoingVideoCallScreen extends StatelessWidget {
  const OnGoingVideoCallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VideocallController());

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ImagePath.callingImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Top-right small image
            Positioned(
              top: 2,
              right: 16,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  height: 190,
                  width: 140,
                  child: Image.asset("assets/images/videocall_Image.png"),
                ),
              ),
            ),

            // Bottom controls + timer
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Center(
                  child: Column(
                    children: const [
                      SizedBox(height: 50),
                      SizedBox(height: 4),
                      Text(
                        "03:40",
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 18,
                  ),
                  margin: const EdgeInsets.only(bottom: 40),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: .2),
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
                          bgColor: Colors.red,
                          onTap: () {
                            Get.to(VideoCallEndedScreen());
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
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
