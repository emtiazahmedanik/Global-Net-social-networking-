import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/http_service/http_network_client.dart';
import 'package:jdadzok/core/network_caller/endpoints.dart';

class ChangePasswordScreenController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController oldPasswordEditingController =
      TextEditingController();
  final TextEditingController newPasswordEditingController =
      TextEditingController();
  final TextEditingController reTypePasswordEditingController =
      TextEditingController();

  final RxBool isLoading = false.obs;

  Future<void> changePassword() async {
    final oldPass = oldPasswordEditingController.text.trim();
    final newPass = newPasswordEditingController.text.trim();
    final reType = reTypePasswordEditingController.text.trim();

    if (newPass != reType) {
     
      EasyLoading.showError('Passwords do not match');
      return;
    }

    try {
      isLoading(true);
      final body = {
        'currentPassword': oldPass,
        'newPassword': newPass,
      };
      final response =
          await HttpNetworkClient().postRequest(url: Urls.changePassword, body: body);
      isLoading(false);

      if (response.isSuccess) {
        final message = response.responseData != null && response.responseData is Map && (response.responseData as Map).containsKey('message')
            ? (response.responseData as Map)['message']
            : 'Password changed successfully';
        
        EasyLoading.showSuccess(message.toString());
        // Optionally clear fields
        oldPasswordEditingController.clear();
        newPasswordEditingController.clear();
        reTypePasswordEditingController.clear();
        // Close the screen after success
        Future.delayed(Duration(milliseconds: 700), () => Get.back());
      } else {
        final err = response.errorMessage ?? 'Something went wrong';
        
        EasyLoading.showError(err);
      }
    } on Exception catch (e) {
      isLoading(false);
      
      debugPrint(e.toString());
    }
  }

  @override
  void dispose() {
    oldPasswordEditingController.dispose();
    newPasswordEditingController.dispose();
    reTypePasswordEditingController.dispose();
    super.dispose();
  }
}
