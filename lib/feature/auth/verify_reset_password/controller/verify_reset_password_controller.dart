import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jdadzok/core/http_service/http_network_client.dart';
import '../../../../route/app_route.dart';
import 'package:jdadzok/core/network_caller/endpoints.dart';

class VerifyResetPasswordController extends GetxController {
  final codeController = TextEditingController();
  final RxString email = ''.obs;
  final RxString userId = ''.obs;

  String? userIdArg;
  String? emailArgs;

  @override
  void onInit() {
    super.onInit();
    // Get arguments passed from verification_page_screen
    final args = Get.arguments;
    if (args != null) {
      userIdArg = args['userId'];
      emailArgs = args['email'];
      email.value = emailArgs ?? '';
      userId.value = userIdArg ?? '';
    }
    debugPrint('VerifyResetPasswordController initialized - userId: ${userId.value}, email: ${email.value}');
  }

  void verifyToken() async {
    final code = codeController.text.trim();
    
    if (code.length != 6) {
      EasyLoading.showError("Please enter a valid 6-digit code.");
      return;
    }

    if (userId.value.isEmpty) {
      EasyLoading.showError('User ID missing for verification');
      debugPrint('ERROR: User ID is empty');
      return;
    }

    await verifyTokenNetwork(code);
  }

  Future<void> verifyTokenNetwork(String token) async {
    EasyLoading.show(status: 'Verifying token...');

    final payload = {
      'token': token,
      'userId': userId.value,
    };

    debugPrint('Verify Token Request - URL: ${Urls.verifyToken}');
    debugPrint('Verify Token Request - Payload: $payload');

    try {
      final response = await HttpNetworkClient().postRequest(
        url: Urls.verifyToken,
        body: payload,
      );

      debugPrint('Verify Token Response - Status Code: ${response.statusCode}');
      debugPrint('Verify Token Response - Is Success: ${response.isSuccess}');
      debugPrint('Verify Token Response - Response Data: ${response.responseData}');
      debugPrint('Verify Token Response - Error Message: ${response.errorMessage}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.responseData;
        if (body != null && body['success'] == true) {
          EasyLoading.showSuccess(body['message'] ?? 'Token verified successfully');
          debugPrint('SUCCESS: Token verified, navigating to reset password screen');
          // Navigate to reset password screen with userId
          Get.toNamed(
            AppRoute.resetPassword,
            arguments: {'userId': userId.value},
          );
          return;
        }
        final errorMsg = body?['message'] ?? 'Verification failed';
        debugPrint('ERROR: Verification failed - $errorMsg');
        EasyLoading.showError(errorMsg);
      } else {
        final errorMsg = 'Server error: ${response.statusCode}';
        debugPrint('ERROR: $errorMsg');
        EasyLoading.showError(errorMsg);
      }
    } catch (err) {
      debugPrint('EXCEPTION in verifyTokenNetwork: $err');
      debugPrint('Exception type: ${err.runtimeType}');
      EasyLoading.showError('Something went wrong: ${err.toString()}');
    } finally {
      EasyLoading.dismiss();
    }
  }

  void resendEmailCode() async {
    final currentEmail = email.value;
    if (currentEmail.isEmpty) {
      EasyLoading.showError('No email provided');
      debugPrint('ERROR: No email provided for resend');
      return;
    }

    EasyLoading.show(status: 'Sending verification email...');
    debugPrint('Resend Email Request - Email: $currentEmail');

    try {
      final payload = {'email': currentEmail};

      final response = await HttpNetworkClient().postRequest(
        url: Urls.forgotPassword,
        body: payload,
      );

      debugPrint('Resend Email Response - Status Code: ${response.statusCode}');
      debugPrint('Resend Email Response - Is Success: ${response.isSuccess}');
      debugPrint('Resend Email Response - Response Data: ${response.responseData}');

      if (response.isSuccess && response.responseData != null) {
        final body = response.responseData as Map<String, dynamic>;
        if (body['success'] == true) {
          // Update userId if provided in response
          if (body['data'] != null && body['data'] is Map && (body['data'] as Map)['userId'] != null) {
            userId.value = (body['data'] as Map)['userId'];
            debugPrint('Updated userId from resend response: ${userId.value}');
          }
          EasyLoading.showSuccess(body['message'] ?? 'Verification code sent');
          return;
        }
        final errorMsg = body['message'] ?? 'Failed to resend code';
        debugPrint('ERROR: Failed to resend - $errorMsg');
        EasyLoading.showError(errorMsg);
      } else {
        final errorMsg = response.errorMessage ?? 'Failed to resend code';
        debugPrint('ERROR: $errorMsg');
        EasyLoading.showError(errorMsg);
      }
    } catch (e) {
      debugPrint('EXCEPTION in resendEmailCode: $e');
      debugPrint('Exception type: ${e.runtimeType}');
      EasyLoading.showError('Failed to resend code: ${e.toString()}');
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }
}

