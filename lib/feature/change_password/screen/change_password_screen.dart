// ignore_for_file: strict_top_level_inference

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/global_widegts/custom_button.dart';
import 'package:jdadzok/core/style/global_text_style.dart';
import 'package:jdadzok/feature/change_password/controller/change_password_screen_controller.dart';
import 'package:jdadzok/feature/change_password/widget/text_field_widget.dart';

// ignore: must_be_immutable
class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreenController changePasswordScreenController = Get.put(
    ChangePasswordScreenController(),
  );
  ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: CircleAvatar(
                      backgroundColor: Color(0XFFEFEFEF),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                  Spacer(),
                  Text(
                    "Change Password",
                    style: globalTextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Spacer(),
                ],
              ),
              SizedBox(height: 49),
              Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: changePasswordScreenController.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Old Password"),
                    SizedBox(height: 10),
                    textField(
                      changePasswordScreenController
                          .oldPasswordEditingController,
                      "***alex",
                      obscure: true,
                    ),
                    SizedBox(height: 43),
                    Text("New Password"),
                    SizedBox(height: 10),
                    textField(
                      changePasswordScreenController
                          .newPasswordEditingController,
                      "smith58",
                      obscure: true,
                    ),
                    SizedBox(height: 10),
                    Text("Retype Password"),
                    SizedBox(height: 10),
                    textField(
                      changePasswordScreenController
                          .reTypePasswordEditingController,
                      "smith58",
                      obscure: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'required';
                        }
                        if (value.length < 6) {
                          return 'must be at least 6 characters';
                        }
                        if (value != changePasswordScreenController.newPasswordEditingController.text) {
                          return 'Password does not match';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              Spacer(),
              SizedBox(
                height: 48,
                width: 250,
                child: FittedBox(
                  child: Obx(() {
                    if (changePasswordScreenController.isLoading.value) {
                      return ElevatedButton(
                        onPressed: null,
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                      );
                    }
                    return CustomButton(
                      text: "Save Password",
                      onPressed: () {
                        savePasswordButton();
                      },
                    );
                  }),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  savePasswordButton() {
    if (changePasswordScreenController.formKey.currentState!.validate()) {
      // Proceed to call API
      changePasswordScreenController.changePassword();
    }
  }
}
