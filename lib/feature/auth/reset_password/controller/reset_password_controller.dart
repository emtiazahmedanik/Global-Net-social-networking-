import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jdadzok/route/app_route.dart';
import 'package:dio/dio.dart';
import 'package:jdadzok/core/network_caller/dio_client.dart';
import 'package:jdadzok/core/network_caller/endpoints.dart';

class ResetPasswordController extends GetxController {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String _formatMessage(dynamic raw) {
    if (raw == null) return 'Something went wrong';
    if (raw is String) return raw;
    if (raw is List) {
      final parts = raw
          .map((e) => e?.toString() ?? '')
          .where((s) => s.isNotEmpty)
          .toList();
      if (parts.isEmpty) return 'Something went wrong';
      return parts.join('\n');
    }
    if (raw is Map) {
      if (raw['message'] != null) return _formatMessage(raw['message']);
      return raw.toString();
    }
    return raw.toString();
  }

  void resetPassword() {
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    // Check if passwords are empty
    if (newPassword.isEmpty) {
      EasyLoading.showError("Please enter a new password");
      debugPrint('ERROR: New password is empty');
      return;
    }

    if (confirmPassword.isEmpty) {
      EasyLoading.showError("Please confirm your password");
      debugPrint('ERROR: Confirm password is empty');
      return;
    }

    // Check if passwords match
    if (newPassword != confirmPassword) {
      EasyLoading.showError("Passwords do not match");
      debugPrint('ERROR: Passwords do not match - newPassword: ${newPassword.length} chars, confirmPassword: ${confirmPassword.length} chars');
      return;
    }

    // Check password length (optional validation)
    if (newPassword.length < 6) {
      EasyLoading.showError("Password must be at least 6 characters long");
      debugPrint('ERROR: Password too short - length: ${newPassword.length}');
      return;
    }

    final String? userIdArg = Get.arguments != null
        ? Get.arguments['userId']
        : null;
    final userId = userIdArg ?? '';

    if (userId.isEmpty) {
      EasyLoading.showError(
        'User ID missing. Please retry the password reset flow.',
      );
      debugPrint('ERROR: User ID is empty');
      return;
    }

    debugPrint('Reset Password Request - userId: $userId');
    debugPrint('Reset Password Request - URL: ${Urls.resetPassword}');
    EasyLoading.show(status: 'Resetting password...');

    final payload = {'userId': userId, 'password': newPassword};
    debugPrint('Reset Password Request - Payload: {userId: $userId, password: [hidden]}');

    DioClient().client
        .post(Urls.resetPassword, data: payload)
        .then((response) {
          EasyLoading.dismiss();
          debugPrint('Reset Password Response - Status Code: ${response.statusCode}');
          debugPrint('Reset Password Response - Response Data: ${response.data}');
          
          if (response.statusCode == 200 || response.statusCode == 201) {
            final body = response.data;
            if (body != null && body['success'] == true) {
              debugPrint('SUCCESS: Password reset successful');
              EasyLoading.showSuccess(_formatMessage(body['message']));
              Future.delayed(const Duration(milliseconds: 500), () {
                debugPrint('Navigating to login screen');
                Get.offAllNamed(AppRoute.login);
              });
              return;
            }
            final errorMsg = _formatMessage(body['message']);
            debugPrint('ERROR: Password reset failed - $errorMsg');
            EasyLoading.showError(errorMsg);
          } else {
            final errorMsg = 'Server error: ${response.statusCode}';
            debugPrint('ERROR: $errorMsg');
            EasyLoading.showError(errorMsg);
          }
        })
        .catchError((err) {
          EasyLoading.dismiss();
          debugPrint('EXCEPTION in resetPassword: $err');
          debugPrint('Exception type: ${err.runtimeType}');
          
          String message = 'Something went wrong';
          if (err is DioException) {
            debugPrint('DioException - Status Code: ${err.response?.statusCode}');
            debugPrint('DioException - Response Data: ${err.response?.data}');
            debugPrint('DioException - Error Message: ${err.message}');
            
            if (err.response != null && err.response?.data != null) {
              final data = err.response?.data;
              if (data is Map && data['message'] != null) {
                message = _formatMessage(data['message']);
              } else if (err.message != null) {
                message = err.message!.toString();
              }
            } else {
              message = err.message ?? message;
            }
          } else {
            message = err.toString();
          }
          debugPrint('Final error message: $message');
          EasyLoading.showError(message);
        });
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
