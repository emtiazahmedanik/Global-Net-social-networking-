import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:jdadzok/core/network_caller/endpoints.dart';

class PrivacyPolicyController extends GetxController {
  var isLoading = true.obs;
  var privacyPolicyData = {}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPrivacyPolicy();
  }

  Future<void> fetchPrivacyPolicy() async {
    try {
      isLoading(true);
      final response = await http.get(
        Uri.parse(Urls.privacyPolicy),
      );

      if (response.statusCode == 200) {
        privacyPolicyData.value = json.decode(response.body);
      } else {
        Get.snackbar('Error', 'Failed to load Privacy Policy');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }
}
