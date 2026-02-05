import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/const/image_path.dart';
import 'package:jdadzok/feature/chat/controller/audiocall_controller.dart';
import 'package:jdadzok/feature/chat/screen/audio_call_ended_screen.dart';

class OngoingAudioCall extends StatelessWidget {
  const OngoingAudioCall({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AudioCallController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(ImagePath.callingImage),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "David Wayne",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "03:45",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),

            // Bottom buttons bar
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
              margin: const EdgeInsets.only(bottom: 40),
              decoration: BoxDecoration(
                color: Colors.grey,
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
                        Get.to(AudioCallEndedScreen());
                      },
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
