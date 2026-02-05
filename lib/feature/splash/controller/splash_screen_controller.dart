import 'dart:async';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../route/app_route.dart';

class SplashScreenController extends GetxController {
  void checkIsLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token != null && token.isNotEmpty) {
        Timer(const Duration(milliseconds: 400), () {
          Get.offAllNamed(AppRoute.bottomNavbar);
        });
      } else {
        Timer(const Duration(seconds: 2), () {
          Get.offAllNamed(AppRoute.welcomeScreen);
        });
      }
    } catch (_) {
      Timer(const Duration(seconds: 2), () {
        Get.offAllNamed(AppRoute.welcomeScreen);
      });
    }
  }

  @override
  void onInit() {
    super.onInit();
    checkIsLogin();
  }
}
