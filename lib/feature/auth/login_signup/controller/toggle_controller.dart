// lib/core/controller/auth_toggle_controller.dart
import 'package:get/get.dart';

class AuthToggleController extends GetxController {
  var isLoginSelected = true.obs;

  void toggleToLogin() {
    isLoginSelected.value = true;
  }

  void toggleToSignup() {
    isLoginSelected.value = false;
  }
}
