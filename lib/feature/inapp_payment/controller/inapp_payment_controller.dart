import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/http_service/http_network_client.dart';
import 'package:jdadzok/core/network_caller/endpoints.dart';

class InAppPaymentController extends GetxController {
  final TextEditingController cardHolderController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expMonthController = TextEditingController();
  final TextEditingController expYearController = TextEditingController();
  final TextEditingController cvcController = TextEditingController();

  var isLoading = false.obs;

  @override
  void onClose() {
    cardHolderController.dispose();
    cardNumberController.dispose();
    expMonthController.dispose();
    expYearController.dispose();
    cvcController.dispose();
    super.onClose();
  }

  bool _validateInputs() {
    if (cardHolderController.text.trim().isEmpty) {
      EasyLoading.showError('Please enter cardholder name');
      return false;
    }
    final number = cardNumberController.text.replaceAll(' ', '');
    if (number.length < 12 || number.length > 16) {
      EasyLoading.showError('Please enter valid card number (max 16 digits)');
      return false;
    }
    final expMonth = int.tryParse(expMonthController.text) ?? 0;
    final expYear = int.tryParse(expYearController.text) ?? 0;
    if (expMonth < 1 || expMonth > 12) {
      EasyLoading.showError('Please enter valid expiry month');
      return false;
    }
    if (expYear < 22) {
      EasyLoading.showError('Please enter valid expiry year');
      return false;
    }
    if (cvcController.text.length < 3) {
      EasyLoading.showError('Please enter valid CVC');
      return false;
    }
    return true;
  }

  /// Submit payment card info to backend endpoint
  Future<void> submitPayment({required String clientSecret, String? orderId}) async {
    if (!_validateInputs()) return;

    isLoading.value = true;
    EasyLoading.show(status: 'Processing payment...');

    try {
      final body = {
        'cardHolderName': cardHolderController.text.trim(),
        'cardNumber': cardNumberController.text.replaceAll(' ', ''),
        'expMonth': int.tryParse(expMonthController.text) ?? 0,
        'expYear': int.tryParse(expYearController.text) ?? 0,
        'cvc': cvcController.text.trim(),
        if (orderId != null) 'orderId': orderId,
      };

      // Pass clientSecret in header as requested
      final response = await HttpNetworkClient().postRequest(
        url: Urls.stripeWebhook,
        body: body,
        extraHeaders: {
          'clientSecret': clientSecret,
        },
      );

      final responseBody = response.responseData;

      if (responseBody != null && responseBody['received'] == true) {
        EasyLoading.showSuccess('Payment processing initiated');
        // Close and maybe show success; webhook will confirm actual result
        Get.back();
      } else {
        final msg = responseBody?['error'] ?? responseBody?['message'] ?? 'Payment failed';
        EasyLoading.showError(msg);
      }
    } catch (e) {
      EasyLoading.showError('Payment failed');
      debugPrint('Error in submitPayment: $e');
    } finally {
      isLoading.value = false;
      EasyLoading.dismiss();
    }
  }
}
