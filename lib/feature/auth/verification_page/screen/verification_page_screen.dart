// lib/feature/auth/verification_page/screen/verification_page_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/const/app_colors.dart';
import 'package:jdadzok/core/global_widegts/custom_button.dart';
import 'package:jdadzok/core/global_widegts/custom_textfield.dart';
import '../../../../../core/const/image_path.dart';
import '../controller/verification_page_controller.dart';

class VerificationPageScreen extends StatelessWidget {
  VerificationPageScreen({super.key});

  final VerificationPageController controller = Get.put(
    VerificationPageController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 30),

                Image.asset(
                  ImagePath.verifyIllustration, // use your asset path
                  height: 218,
                  width: 280,
                ),

                const SizedBox(height: 30),

                const Text(
                  'Reset Password',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Once verified, the next time you log in, you will be\nrequired to enter this password.',
                  style: TextStyle(color: AppColors.greyColor),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 30),

                CustomTextField(
                  hintText: 'youremail@gmail.com',
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 220),

                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: 'Verify',
                    onPressed: controller.verifyEmail,
                  ),
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: 'Cancel',
                    backgroundColor: AppColors.backgroundColor,
                    textColor: AppColors.primaryColor,
                    borderColor: AppColors.primaryColor,
                    onPressed: () => Get.back(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
