import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/global_widegts/custom_toggle_tab.dart';
import '../controller/login_controller.dart';
import '../controller/signup_controller.dart';
import '../controller/toggle_controller.dart';
import '../widget/login_form.dart';
import '../widget/signup_form.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final AuthToggleController toggleController = Get.put(AuthToggleController());
  final LoginController loginController = Get.put(
    LoginController(),
    permanent: true,
  );
  final SignupController signupController = Get.put(
    SignupController(),
    permanent: true,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              SizedBox(height: 104),

              // 🔁 Toggle tab
              Container(
                width: 250,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Color(0xFFE8EDFB),
                ),
                child: Obx(
                  () => Row(
                    children: [
                      CustomToggleTab(
                        text: "Login",
                        selected: toggleController.isLoginSelected.value,
                        onTap: toggleController.toggleToLogin,
                      ),
                      CustomToggleTab(
                        text: "Sign Up",
                        selected: !toggleController.isLoginSelected.value,
                        onTap: toggleController.toggleToSignup,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 50),

              Obx(
                () => toggleController.isLoginSelected.value
                    ? LoginForm()
                    : SignupForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
