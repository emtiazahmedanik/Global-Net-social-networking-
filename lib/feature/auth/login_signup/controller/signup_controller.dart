import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jdadzok/core/http_service/http_network_client.dart';
import 'package:jdadzok/feature/auth/login_signup/controller/toggle_controller.dart';
import 'package:jdadzok/core/utils/validators.dart';
import 'package:jdadzok/route/app_route.dart';
import 'package:jdadzok/core/network_caller/endpoints.dart';

class SignupController extends GetxController {
  final AuthToggleController toggleController =
      Get.find<AuthToggleController>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var isPasswordObscured = true.obs;
  var isConfirmPasswordObscured = true.obs;
  var agreeToTerms = false.obs;

  void togglePasswordObscure() =>
      isPasswordObscured.value = !isPasswordObscured.value;
  void toggleConfirmPasswordObscure() =>
      isConfirmPasswordObscured.value = !isConfirmPasswordObscured.value;
  void toggleAgreement(bool? value) => agreeToTerms.value = value ?? false;

  void showAgreementWarning() {
    EasyLoading.showInfo("Please agree to the terms and conditions");
  }

  Future<void> signup() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirm = confirmPasswordController.text;

    // ✅ Validation
    if (name.isEmpty) {
      EasyLoading.showError("Please enter your full name");
      return;
    }
    if (email.isEmpty) {
      EasyLoading.showError("Please enter your email address");
      return;
    }
    if (!isValidEmail(email)) {
      EasyLoading.showError("Please enter a valid email address");
      return;
    }
    if (password.isEmpty) {
      EasyLoading.showError("Please enter a password");
      return;
    }
    if (!isValidPassword(password)) {
      EasyLoading.showError("Password must be at least 6 characters");
      return;
    }
    if (password != confirm) {
      EasyLoading.showError("Passwords do not match!");
      return;
    }
    if (!agreeToTerms.value) {
      showAgreementWarning();
      return;
    }

    EasyLoading.show(status: 'Creating account...');

    final payload = {
      'name': name,
      'email': email,
      'password': password,
      'authProvider': 'EMAIL',
    };

    try {
      final response = await HttpNetworkClient().postRequest(
        url: Urls.signup,
        body: payload,
      );
      final body = response.responseData;

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          body!['success'] == true) {
        debugPrint("response success: $body");
        final String userId = body['data']['user']['id'];
        EasyLoading.showInfo(body['message']);
        Get.toNamed(
          AppRoute.verify,
          arguments: {
            'email': email,
            'from': AppRoute.signup,
            'userId': userId,
          },
        );
      } else {
        EasyLoading.showError(body!['message'] ?? "Registration failed");
      }
    } catch (err) {
      EasyLoading.showError(err.toString());
      debugPrint("error : ${err.toString()}");
    } finally {
      EasyLoading.dismiss();
    }
  }

  void navigateToLogin() {
    toggleController.toggleToLogin();
    Get.back();
  }
}


// Map? verification = data?['verification'] ?? data?['verificaiton'];
//         if (verification != null && verification['token'] != null) {
//           final otp = verification['token'].toString();
//           final userId = verification['userId']?.toString();

//           EasyLoading.showSuccess(body['message'] ?? 'Registration successful');

//           Future.delayed(const Duration(milliseconds: 500), () {
//             Get.toNamed(
//               AppRoute.verify,
//               arguments: {
//                 'email': email,
//                 'from': AppRoute.signup,

//                 'userId': userId,
//                 'otp': otp,
//               },
//             );
//           });
//           return;
//         }



// final data = body['data'];
//         final accessToken = data?['accessToken'];
//         if (accessToken != null) {
//           final prefs = await SharedPreferences.getInstance();
//           await prefs.setString("accessToken", accessToken);

//           EasyLoading.showSuccess(body['message'] ?? 'Registration successful');

//           Future.delayed(const Duration(milliseconds: 500), () {
//             Get.toNamed(
//               AppRoute.verify,
//               arguments: {'email': email, 'from': AppRoute.signup},
//             );
//           });
//           return;
//         }

//         EasyLoading.showError("Registration failed: Invalid response data");