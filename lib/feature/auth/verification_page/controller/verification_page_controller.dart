import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:dio/dio.dart';
import 'package:jdadzok/core/network_caller/dio_client.dart';

import '../../../../route/app_route.dart';
import 'package:jdadzok/core/network_caller/endpoints.dart';

class VerificationPageController extends GetxController {
  final TextEditingController emailController = TextEditingController();

  void verifyEmail() {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      EasyLoading.showError("Please enter your email");
      debugPrint('ERROR: Email is empty');
      return;
    }
    
    debugPrint('Forgot Password Request - Email: $email');
    debugPrint('Forgot Password Request - URL: ${Urls.forgotPassword}');
    EasyLoading.show(status: 'Sending OTP Code...');

    final payload = {'email': email};
    debugPrint('Forgot Password Request - Payload: $payload');

    DioClient().client
        .post(Urls.forgotPassword, data: payload)
        .timeout(const Duration(seconds: 15))
        .then((response) {
          EasyLoading.dismiss();
          debugPrint('Forgot Password Response - Status Code: ${response.statusCode}');
          debugPrint('Forgot Password Response - Response Data: ${response.data}');
          
          if (response.statusCode == 200 || response.statusCode == 201) {
            final body = response.data;
            if (body != null && body['success'] == true) {
              final data = body['data'];
              final userId = data != null && data['userId'] != null
                  ? data['userId']
                  : '';
              debugPrint('SUCCESS: Forgot Password Response - userId: $userId, email: $email');
              debugPrint('Navigating to verify reset password screen');
              Get.toNamed(
                AppRoute.verifyResetPassword,
                arguments: {
                  'email': email,
                  'userId': userId,
                },
              );
              EasyLoading.showSuccess(
                body['message'] ?? 'Verification OTP sent',
              );
              return;
            }
            final errorMsg = body?['message'] ?? 'Failed to send verification OTP';
            debugPrint('ERROR: Failed to send OTP - $errorMsg');
            EasyLoading.showError(errorMsg);
          } else {
            final errorMsg = 'Server error: ${response.statusCode}';
            debugPrint('ERROR: $errorMsg');
            EasyLoading.showError(errorMsg);
          }
        })
        .catchError((err) {
          EasyLoading.dismiss();
          debugPrint('EXCEPTION in verifyEmail: $err');
          debugPrint('Exception type: ${err.runtimeType}');
          
          String message = 'Something went wrong';
          if (err is DioException) {
            debugPrint('DioException - Status Code: ${err.response?.statusCode}');
            debugPrint('DioException - Response Data: ${err.response?.data}');
            debugPrint('DioException - Error Message: ${err.message}');
            
            if (err.response != null && err.response?.data != null) {
              final data = err.response?.data;
              if (data is Map && data['message'] != null) {
                message = data['message'];
              } else if (err.message != null) {
                message = err.message!;
              }
            } else {
              message = err.message ?? message;
            }
          } else if (err is TimeoutException) {
            debugPrint('ERROR: Request timed out');
            message = 'Request timed out';
          } else {
            message = err.toString();
          }
          
          debugPrint('Final error message: $message');
          EasyLoading.showError(message);
        });
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
