import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/global_widegts/custom_view_button.dart';
import 'package:jdadzok/feature/create_ngo/apply%20verification%20details/controller/apply_verification_controller.dart';
import 'package:jdadzok/feature/create_ngo/apply%20verification%20details/widgets/apply_verification_profile_details.dart';
import 'package:jdadzok/feature/create_ngo/apply%20verification%20details/widgets/apply_verification_details_header.dart';
import 'package:jdadzok/feature/create_ngo/apply%20verification%20details/widgets/apply_verification_about_widget.dart';
import 'package:jdadzok/route/app_route.dart';

class ApplyVerificationDetailsScreen extends StatelessWidget {
  const ApplyVerificationDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller with arguments if provided
    final controller = Get.put(ApplyVerificationController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Obx(() {
            // Show loading indicator while fetching data
            if (controller.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }

            // Show error message if any
            if (controller.error.value.isNotEmpty && !controller.hasData) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 48),
                    SizedBox(height: 16),
                    Text(
                      'Error',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      controller.error.value,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.red),
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => Get.back(),
                      child: Text('Go Back'),
                    ),
                  ],
                ),
              );
            }

            // Show main content
            return Column(
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
                SizedBox(height: 28),
                Text(
                  'Profile information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    height: 1.8,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 12),
                ApplyVerificationDetailsHeader(),
                SizedBox(height: 16),
                ApplyVerificationProfileDetails(),
                SizedBox(height: 16),
                ApplyVerificationAboutWidget(),
                Spacer(),
                CustomViewButton(
                  text: 'Next',
                  color: Color(0XFF2D55FF),
                  width: double.infinity,
                  onPressed: () {
                    // Pass arguments to identity verification screen
                    final Map<String, dynamic>? currentArgs = Get.arguments as Map<String, dynamic>?;
                    Get.toNamed(
                      AppRoute.identityVerificationScreen,
                      arguments: currentArgs ?? {},
                    );
                  },
                  textColor: Colors.white,
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
