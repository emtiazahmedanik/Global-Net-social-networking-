import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/http_service/http_network_client.dart';
import 'package:jdadzok/core/network_caller/endpoints.dart';

class WithdrawRequestController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController amountController = TextEditingController();
  final RxBool isLoading = false.obs;

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  Future<void> sendWithdrawRequest() async {
    if (!formKey.currentState!.validate()) return;

    final value = amountController.text.trim();
    double? amt;
    try {
      amt = double.parse(value);
    } catch (e) {
      Get.dialog(AlertDialog(title: Text('Error'), content: Text('Invalid amount')));
      return;
    }

    if (amt <= 0) {
      Get.dialog(AlertDialog(title: Text('Error'), content: Text('Amount must be greater than zero')));
      return;
    }

    try {
      isLoading(true);
      final body = {'amount': amt};
      final response = await HttpNetworkClient().postRequest(url: Urls.withdrawRequestTest, body: body);
      isLoading(false);
      if (response.isSuccess) {
        final msg = (response.responseData is Map && (response.responseData as Map).containsKey('message'))
            ? (response.responseData as Map)['message']
            : 'Withdraw request queued';

        final withdrawId = (response.responseData is Map && (response.responseData as Map).containsKey('withdrawId'))
            ? (response.responseData as Map)['withdrawId']
            : null;

        Get.dialog(AlertDialog(
          title: Text('Success'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(msg.toString()),
              if (withdrawId != null) SizedBox(height: 8),
              if (withdrawId != null) Text('Request ID: $withdrawId'),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Get.back(), child: Text('OK')),
          ],
        ));

        amountController.clear();
      } else {
        final err = response.errorMessage ?? 'Something went wrong';
        Get.dialog(AlertDialog(title: Text('Error'), content: Text(err.toString()), actions: [TextButton(onPressed: () => Get.back(), child: Text('OK'))]));
      }
    } on Exception catch (e) {
      isLoading(false);
      Get.dialog(AlertDialog(title: Text('Error'), content: Text(e.toString()), actions: [TextButton(onPressed: () => Get.back(), child: Text('OK'))]));
    }
  }
}
