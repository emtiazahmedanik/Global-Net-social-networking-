import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jdadzok/core/http_service/http_network_client.dart';
import 'package:jdadzok/core/services_class/local_service/shared_preferences_helper.dart';
import '../../../../route/app_route.dart';
import 'package:jdadzok/core/network_caller/endpoints.dart';

class VerifyCodeController extends GetxController {
  final codeController = TextEditingController();
  final RxString email = ''.obs;
  final RxString userId = ''.obs;

  final String from = Get.arguments['from'];
  final String? userIdArg = Get.arguments['userId'];
  final String? emailArgs = Get.arguments['email'];

  @override
  void onInit() {
    email.value = emailArgs ?? '';
    userId.value = userIdArg ?? '';
    super.onInit();
  }

  // void setEmail(String newEmail) {
  //   email.value = newEmail;
  // }

  // void setUserId(String newUserId) {
  //   userId.value = newUserId;
  // }

  void verifyCode() async{
    
    if (codeController.text.length != 6) {
      EasyLoading.showError("Please enter a valid 6-digit code.");
      return;
    }
    await verifyCodeNetwork();
  }

  Future<void> verifyCodeNetwork() async {
    final code = codeController.text.trim();

    if (userId.isEmpty) {
      EasyLoading.showError('User ID missing for verification');
      return;
    }

    EasyLoading.show(status: 'Verifying...');

    final payload = {
      'token': code,
      'userId': userId.value,
    };

    try {
      final response = await HttpNetworkClient().postRequest(
        url: Urls.verifyOTP,
        body: payload,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.responseData;
        debugPrint('respnse verify: $body');
        if (body != null && body['success'] == true) {
          final token = body['data']['accessToken'];
          await SharedPreferencesHelper.saveTokenAndRole(token);
          EasyLoading.showSuccess(body['message'] ?? 'Token verified');
          if (from == AppRoute.signup) {
            Get.toNamed(AppRoute.choice);
            return;
          } else if (from == AppRoute.forgotPassword) {
            Get.toNamed(AppRoute.resetPassword, arguments: {'userId': userId});
            return;
          }
          EasyLoading.showError('Invalid verification flow');
          return;
        }
        EasyLoading.showError(body!['message'] ?? 'Verification failed');
      } else {
        EasyLoading.showError('Server error: ${response.statusCode}');
      }
    } catch (err) {
      EasyLoading.showError(err.toString());
    } finally {
      EasyLoading.dismiss();
    }
  }

  void resendEmailCode() async {
    final currentEmail = email.value;
    if (currentEmail.isEmpty) {
      EasyLoading.showError('No email provided');
      return;
    }

    EasyLoading.show(status: 'Sending verification email...');

    try {
      final payload = {'email': currentEmail};

      final HttpNetworkResponse response = await HttpNetworkClient()
          .postRequest(url: Urls.resendOTP, body: payload);
      final Map<String, dynamic>? body = response.responseData;
      if (body != null && response.isSuccess) {
        EasyLoading.showSuccess(body['message'] ?? 'Verification code sent');
        return;
      } else {
        EasyLoading.showError(body!['message'] ?? 'Failed to resend code');
        return;
      }
    } catch (e) {
      debugPrint('resend email otp error: $e');
    }
  }

  void sendSmsCode() {
    EasyLoading.showSuccess("Verification code sent via SMS.");
  }

  @override
  void dispose() {
    super.dispose();
    codeController.dispose();
  }
}
