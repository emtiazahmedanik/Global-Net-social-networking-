import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/style/global_text_style.dart';
import '../../../../core/global_widegts/custom_button.dart';
import '../../../../core/global_widegts/custom_textfield.dart';
import '../controller/login_controller.dart';

class LoginForm extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());

  LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Welcome!",
          style: globalTextStyle(fontWeight: FontWeight.w700, fontSize: 24),
        ),
        SizedBox(height: 24),

        CustomTextField(
          hintText: "Email Address",
          controller: controller.emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),

        Obx(
          () => CustomTextField(
            hintText: "Password",
            controller: controller.passwordController,
            isPassword: true,
            obscureText: controller.isObscured.value,
            togglePassword: controller.toggleObscure,
          ),
        ),

        const SizedBox(height: 10),

        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: controller.navigateToForgotPassword,
            child: Text(
              "Forgot password?",
              style: globalTextStyle(color: Colors.blue),
            ),
          ),
        ),

        SizedBox(height: 10),

        SizedBox(
          width: double.infinity,
          child: CustomButton(text: "Login", onPressed: controller.login),
        ),

        SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Not a member? ", style: globalTextStyle()),
            GestureDetector(
              onTap: controller.navigateToSignup,
              child: Text(
                "Register now",
                style: globalTextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
