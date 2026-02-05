import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jdadzok/core/http_service/http_network_client.dart';
import 'package:jdadzok/core/services_class/local_service/shared_preferences_helper.dart';
import 'package:jdadzok/feature/auth/login_signup/controller/toggle_controller.dart';
import 'package:jdadzok/core/utils/validators.dart';
import 'package:jdadzok/route/app_route.dart';
import 'package:jdadzok/core/network_caller/endpoints.dart';

class LoginController extends GetxController {
  final AuthToggleController toggleController =
      Get.find<AuthToggleController>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  RxString userId = ''.obs;
  var isObscured = true.obs;

  void toggleObscure() => isObscured.value = !isObscured.value;

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty) {
      EasyLoading.showError("Please enter your email address");
      return;
    }
    if (!isValidEmail(email)) {
      EasyLoading.showError("Please enter a valid email address");
      return;
    }
    if (password.isEmpty) {
      EasyLoading.showError("Please enter your password");
      return;
    }
    if (!isValidPassword(password)) {
      EasyLoading.showError("Password must be at least 6 characters");
      return;
    }

    EasyLoading.show(status: "Signing in...");

    final payload = {"email": email, "password": password};

    try {
      final response = await HttpNetworkClient().postRequest(
        url: Urls.login,
        body: payload,
      );

      final body = response.responseData;

      if (response.statusCode == 201 && body?['success'] == true) {
        final accessToken = body?['data']['accessToken'];
        userId.value = body?['data']['user']['id'];
        if (accessToken != null) {
          await SharedPreferencesHelper.saveTokenAndRole(accessToken);
          debugPrint('eije here token saved $accessToken');
          await SharedPreferencesHelper.saveUserId(userId.value);

          await postSettings();

          Get.offAllNamed(AppRoute.bottomNavbar);

          return;
        }
      } else {
        EasyLoading.showError(body?['message'] ?? "Login failed");
      }
    } catch (e) {
      debugPrint("login exception: $e");
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> postSettings() async {
    try {
      final body = {
        "like": 1,
        "comment": 1,
        "share": 1,
        "post": 1,
        "greenCapScore": 1,
        "redCapScore": 1,
        "blackCapScore": 1,
        "yellowCapScore": 1,
        "productSpentPercentage": 4,
        "productPromotionPercentage": 2,
      };
      final response = await HttpNetworkClient().postRequest(
        url: Urls.postSettings,
        body: body,
      );
      final responseBody = response.responseData;
      if (responseBody != null && response.statusCode == 200 ||
          response.statusCode == 201) {
        debugPrint('success post setting');
      }
    } catch (e) {
      debugPrint('post error: $e');
    }
  }

  void navigateToSignup() {
    toggleController.toggleToSignup();
    //Get.toNamed(AppRoute.signup);
  }

  void navigateToForgotPassword() {
    Get.toNamed(AppRoute.forgotPassword);
  }
}
