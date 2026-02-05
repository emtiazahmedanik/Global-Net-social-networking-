import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/const/app_colors.dart';
import 'package:jdadzok/core/style/global_text_style.dart';
import '../../../../core/global_widegts/custom_button.dart';
import '../../../../core/global_widegts/custom_textfield.dart';
import '../controller/signup_controller.dart';

class SignupForm extends StatelessWidget {
  final SignupController controller = Get.put(SignupController());

  SignupForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Sign up",
          style: globalTextStyle(fontWeight: FontWeight.w700, fontSize: 24),
        ),

        SizedBox(height: 8),

        Text(
          "Create an account to get started",
          style: globalTextStyle(fontSize: 12),
        ),

        SizedBox(height: 24),

        CustomTextField(
          hintText: "Full Name",
          controller: controller.nameController,
        ),

        SizedBox(height: 16),

        CustomTextField(
          hintText: "Email Address",
          controller: controller.emailController,
        ),

        SizedBox(height: 16),
        Obx(
          () => CustomTextField(
            hintText: "Password",
            controller: controller.passwordController,
            isPassword: true,
            obscureText: controller.isPasswordObscured.value,
            togglePassword: controller.togglePasswordObscure,
          ),
        ),

        SizedBox(height: 16),
        Obx(
          () => CustomTextField(
            hintText: "Confirm Password",
            controller: controller.confirmPasswordController,
            isPassword: true,
            obscureText: controller.isConfirmPasswordObscured.value,
            togglePassword: controller.toggleConfirmPasswordObscure,
          ),
        ),

        SizedBox(height: 24),

        Obx(
          () => Row(
            children: [
              Checkbox(
                activeColor: AppColors.primaryColor,
                value: controller.agreeToTerms.value,
                onChanged: controller.toggleAgreement,
              ),
              Expanded(
                child: Text(
                  "I agree to the Terms and Conditions and Privacy Policy.",
                  style: globalTextStyle(),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 24),

        Obx(
          () => SizedBox(
            width: double.infinity,
            child: CustomButton(
              text: "Sign Up",
              onPressed: controller.agreeToTerms.value
                  ? controller.signup
                  : controller.showAgreementWarning,
            ),
          ),
        ),
      ],
    );
  }
}
