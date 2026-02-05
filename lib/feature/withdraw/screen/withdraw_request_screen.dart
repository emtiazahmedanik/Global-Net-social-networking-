import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/style/global_text_style.dart';
import 'package:jdadzok/core/global_widegts/custom_button.dart';
import 'package:jdadzok/feature/withdraw/controller/withdraw_request_controller.dart';

class WithdrawRequestScreen extends StatelessWidget {
  final WithdrawRequestController controller = Get.put(WithdrawRequestController());

  WithdrawRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Withdraw Request'),backgroundColor: Colors.white,),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Amount', style: globalTextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                SizedBox(height: 8),
                TextFormField(
                  controller: controller.amountController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    hintText: 'Enter amount',
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                    contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'Amount is required';
                    try {
                      final v = double.parse(value.trim());
                      if (v <= 0) return 'Amount must be greater than zero';
                    } catch (e) {
                      return 'Invalid amount';
                    }
                    return null;
                  },
                ),
                Spacer(),
                SizedBox(
                  height: 48,
                  width: double.infinity,
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return ElevatedButton(
                        onPressed: null,
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        ),
                      );
                    }
                    return CustomButton(text: 'Send Withdraw Request', onPressed: () => controller.sendWithdrawRequest());
                  }),
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
