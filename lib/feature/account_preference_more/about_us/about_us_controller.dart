import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:jdadzok/core/network_caller/endpoints.dart';

class AboutUsController extends GetxController {
  var isLoading = true.obs;
  var aboutUsData = {}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAboutUs();
  }

  Future<void> fetchAboutUs() async {
    try {
      isLoading(true);
      final response = await http.get(
        Uri.parse(Urls.aboutUs),
      );

      if (response.statusCode == 200) {
        aboutUsData.value = json.decode(response.body);
      } else {
        Get.snackbar('Error', 'Failed to load About Us');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }
}
