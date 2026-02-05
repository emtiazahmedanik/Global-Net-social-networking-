// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jdadzok/core/global_widegts/custom_view_button.dart';
import 'package:jdadzok/feature/create_ngo/upload%20documents/controller/filepicker_controller.dart';
import 'package:jdadzok/feature/create_ngo/upload%20documents/widgets/upload_box_widget.dart';
import 'package:jdadzok/feature/create_ngo/upload%20documents/service/ngo_verification_service.dart';
import 'package:jdadzok/feature/create_ngo/create_ngo_verify_screen/model/create_ngo_verify_model.dart';

class UploadDocumentScreen extends StatelessWidget {
  const UploadDocumentScreen({super.key});

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Color(0XFFFFFFFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          insetPadding: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Your request has been sent!",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  message.isNotEmpty 
                      ? message 
                      : "You'll get a confirmation email and notification as soon as our verification team verifies your documents. This could take a few days. Thanks for connecting with us.",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                CustomViewButton(
                  text: "Got it",
                  onPressed: () {
                    Get.back();
                    Get.back(); // Go back to previous screen
                  },
                  color: const Color(0XFF2D55FF),
                  width: double.infinity,
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Color(0XFFFFFFFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          insetPadding: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 12),
                const Text(
                  "Error",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  errorMessage,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                CustomViewButton(
                  text: "OK",
                  onPressed: () {
                    Get.back();
                  },
                  color: const Color(0XFF2D55FF),
                  width: double.infinity,
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final NGOFilePickerController fileController = Get.put(
      NGOFilePickerController(),
    );

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Get.back(),
                  ),
                  const Expanded(
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
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 22),
              const Text(
                'Upload Documents',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  height: 1.8,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 28),

              const UploadBoxWidget(),

              const Spacer(),

              CustomViewButton(
                text: "Apply Verification",
                onPressed: () async {
                  if (fileController.selectedFilePath.isEmpty) {
                    EasyLoading.showInfo("Add your file");
                    return;
                  }

                  // Get arguments passed from previous screens
                  final Map<String, dynamic>? args = Get.arguments as Map<String, dynamic>?;
                  final verificationType = args?['verificationType'] as String? ?? 'GOVERMENT_AND_PASSPORT';
                  final org = args?['org'] as OrganizationModel?;

                  if (org == null) {
                    EasyLoading.showError("Organization information missing");
                    return;
                  }

                  final ngoId = org.id;
                  if (ngoId.isEmpty) {
                    EasyLoading.showError("NGO ID missing");
                    return;
                  }

                  EasyLoading.show(status: 'Submitting verification request...');

                  try {
                    final file = File(fileController.selectedFilePath.value);
                    final result = await NgoVerificationService.applyVerification(
                      ngoId: ngoId,
                      verificationType: verificationType,
                      file: file,
                    );

                    EasyLoading.dismiss();

                    if (result['success'] == true) {
                      final message = result['message'] as String? ?? '';
                      _showSuccessDialog(context, message);
                    } else {
                      final errorMsg = result['error'] as String? ?? result['message'] as String? ?? 'Failed to submit verification request';
                      _showErrorDialog(context, errorMsg);
                    }
                  } catch (e) {
                    EasyLoading.dismiss();
                    _showErrorDialog(context, 'Something went wrong: ${e.toString()}');
                  }
                },
                color: const Color(0XFF2D55FF),
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
