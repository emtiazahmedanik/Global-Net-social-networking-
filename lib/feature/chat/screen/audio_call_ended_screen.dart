import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/const/image_path.dart';
import 'package:jdadzok/core/global_widegts/custom_button.dart';
import 'package:jdadzok/feature/chat/screen/individual_chat_screen.dart';

class AudioCallEndedScreen extends StatelessWidget {
  const AudioCallEndedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
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
                    "Call Ended",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Spacer(),
            CustomButton(
              text: 'GO Back',
              onPressed: () {
                Get.to(IndividualChatScreen());
              },
            ),
          ],
        ),
      ),
    );

    //             // Bottom buttons bar
  }
}
