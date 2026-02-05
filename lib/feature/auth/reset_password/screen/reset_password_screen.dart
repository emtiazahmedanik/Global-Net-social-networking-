import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/global_widegts/custom_button.dart';
import 'package:jdadzok/core/global_widegts/custom_textfield.dart';
import '../controller/reset_password_controller.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});

  final ResetPasswordController controller = Get.put(ResetPasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                "Reset your password",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                "Set a new password",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 32),

              const Text(
                "Password",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),

              CustomTextField(
                hintText: "Type new password",
                controller: controller.newPasswordController,
                isPassword: true,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                hintText: "Re-type password",
                controller: controller.confirmPasswordController,
                isPassword: true,
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: "Change password",
                  onPressed: controller.resetPassword,
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}