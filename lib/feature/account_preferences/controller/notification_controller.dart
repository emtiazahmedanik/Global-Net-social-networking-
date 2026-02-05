import 'package:get/get.dart';

class NotificationController extends GetxController {
  RxBool isNotificationOn = true.obs;

  void toggleNotification(bool value) {
    isNotificationOn.value = value;
  }
}
