import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/const/app_colors.dart';
import 'package:jdadzok/core/const/icons_path.dart';
import 'package:jdadzok/core/style/global_text_style.dart';
import '../../../../core/global_widegts/custom_button.dart';
import '../controller/verify_code_controller.dart';

class VerifyCodeScreen extends StatelessWidget {
  VerifyCodeScreen({super.key});

  final VerifyCodeController controller = Get.put(VerifyCodeController());

  @override
  Widget build(BuildContext context) {
    // final String email = Get.arguments['email'];
    // controller.setEmail(email);
    // final String? userId = Get.arguments['userId'];
    // if (userId != null) controller.setUserId(userId);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),

              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () => Get.back(),
                ),
              ),

              SizedBox(height: 20),

              Center(
                child: Text(
                  "Enter the code we sent to",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: 4),

              Center(
                child: Obx(
                  () => Text(
                    controller.email.value,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              SizedBox(height: 8),

              Center(
                child: Text(
                  "We sent 6 digit code to your email address.",
                  style: TextStyle(fontSize: 14, color: AppColors.greyColor),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: 30),

              TextField(
                controller: controller.codeController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  hintText: "Enter Code",
                  hintStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.primaryColor,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.primaryColor,
                      width: 2,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),

              SizedBox(height: 30),

              GestureDetector(
                onTap: controller.resendEmailCode,
                child: Row(
                  children: [
                    Image.asset(IconsPath.emailIcon, height: 24, width: 24),
                    SizedBox(width: 10),
                    Text("Send email again", style: globalTextStyle()),
                  ],
                ),
              ),

              SizedBox(height: 20),

              Spacer(),

              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: "Verify",
                  onPressed: controller.verifyCode,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
