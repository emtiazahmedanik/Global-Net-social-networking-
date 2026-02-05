import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/const/icons_path.dart';
import 'package:jdadzok/core/global_widegts/custom_view_button.dart';
import 'package:jdadzok/feature/create_ngo/apply%20verification/widgets/bullet_text_widget.dart';
import 'package:jdadzok/route/app_route.dart';

class ApplyVerificationScreen extends StatelessWidget {
  const ApplyVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Get.back(),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Verifications",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 48),
                ],
              ),
              SizedBox(height: 16),

              Row(
                children: [
                  Container(
                    height: size.width * 0.08,
                    width: size.width * 0.08,
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: Image.asset(IconsPath.appIcon),
                  ),
                  SizedBox(width: 8),
                  Text.rich(
                    TextSpan(
                      text: "Synq",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: "Ulan",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              Text(
                "Verify your identity to get the official blue verified badge.",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 20),

              Text(
                "How this works:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),

              BulletText(text: "You'll need a valid government-issued ID"),
              BulletText(
                text:
                    "The name on your ID will need to match the name on your LinkedIn profile",
              ),
              BulletText(
                text:
                    "You'll need to agree to share certain data from the ID with LinkedIn for security purposes",
              ),
              BulletText(
                text:
                    "Confirmation of your verification will appear on your profile",
              ),

              SizedBox(height: size.height * 0.1),
              Spacer(),

              CustomViewButton(
                text: "Let's Verify",
                onPressed: () {
                  // Get the arguments passed from CreateNgoVerifyProfileScreen
                  final Map<String, dynamic>? args =
                      Get.arguments as Map<String, dynamic>?;

                  // Navigate to ApplyVerificationDetailsScreen with the same arguments
                  Get.toNamed(
                    AppRoute.applyVerificationDetailsScreen,
                    arguments: args ?? {},
                  );
                },
                color: Color(0XFF2D55FF),
                width: double.infinity,
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
