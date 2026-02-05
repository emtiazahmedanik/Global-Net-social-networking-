// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:jdadzok/feature/inapp_payment/controller/inapp_payment_controller.dart';
import 'package:jdadzok/theme/app_colors.dart';
import 'package:jdadzok/core/style/global_text_style.dart';

class InAppPaymentScreen extends StatelessWidget {
  InAppPaymentScreen({Key? key}) : super(key: key);

  final InAppPaymentController controller =
      Get.put(InAppPaymentController());

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final clientSecret = args?['clientSecret']?.toString() ?? '';
    final orderId = args?['orderId']?.toString();

    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Method', style: globalTextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stripe Header (like an image/logo)
            // Row(
            //   children: [
            //     Container(
            //       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            //       decoration: BoxDecoration(
            //         color: AppColors.primaryColor.withAlpha(25),
            //         borderRadius: BorderRadius.circular(20),
            //       ),
            //       child: Row(
            //         children: const [
            //           Icon(Icons.payment, color: Colors.blue, size: 18),
            //           SizedBox(width: 6),
            //           Text('stripe', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w700)),
            //         ],
            //       ),
            //     ),
            //     SizedBox(width: 12),
            //     // card brand icons
            //     Icon(Icons.credit_card, color: Colors.blueAccent),
            //     SizedBox(width: 6),
            //     Icon(Icons.credit_card, color: Colors.orange),
            //   ],
            // ),

            SizedBox(height: 16),

            Text('Enter your payment details', style: globalTextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            SizedBox(height: 8),
            Text('By continuing you agree to our Terms & Condition', style: TextStyle(fontSize: 12, color: Colors.grey)),
            SizedBox(height: 16),

            // Cardholder name with label
            Text('Cardholder name', style: TextStyle(fontSize: 13, color: Colors.grey.shade700, fontWeight: FontWeight.w600)),
            SizedBox(height: 6),
            TextField(
              controller: controller.cardHolderController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: 'John Doe',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              ),
            ),
            SizedBox(height: 12),

            // Card Number with label and formatter
            Text('Card Number', style: TextStyle(fontSize: 13, color: Colors.grey.shade700, fontWeight: FontWeight.w600)),
            SizedBox(height: 6),
            TextField(
              controller: controller.cardNumberController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(19), // 16 digits + 3 spaces = 19
                CardNumberInputFormatter(),
              ],
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: '4242 4242 4242 4242',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              ),
            ),

            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Exp Month', style: TextStyle(fontSize: 13, color: Colors.grey.shade700, fontWeight: FontWeight.w600)),
                      SizedBox(height: 6),
                      TextField(
                        controller: controller.expMonthController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(2)],
                        decoration: InputDecoration(
                          hintText: 'MM',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Exp Year', style: TextStyle(fontSize: 13, color: Colors.grey.shade700, fontWeight: FontWeight.w600)),
                      SizedBox(height: 6),
                      TextField(
                        controller: controller.expYearController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
                        decoration: InputDecoration(
                          hintText: 'YY',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),

            // CVC
            Text('CVC', style: TextStyle(fontSize: 13, color: Colors.grey.shade700, fontWeight: FontWeight.w600)),
            SizedBox(height: 6),
            TextField(
              controller: controller.cvcController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
              decoration: InputDecoration(
                hintText: '123',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              ),
            ),

            SizedBox(height: 14),
            Row(
              children: [
                Switch(value: false, onChanged: (_) {}),
                SizedBox(width: 8),
                Text('set as default', style: TextStyle(color: Colors.black87)),
              ],
            ),

            Spacer(),

            Obx(() => GestureDetector(
              onTap: controller.isLoading.value
                ? null
                : () => controller.submitPayment(clientSecret: clientSecret, orderId: orderId),
              child: Container(
                height: 56,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: controller.isLoading.value
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Next', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                ),
              ),
            )),

            SizedBox(height: 8),
          ],
        ),
      ),
    );


  }
}


// Formatter to display card number as 4242 4242 4242 4242
class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final digitsOnly = newValue.text.replaceAll(RegExp(r"[^0-9]"), '');
    final limited = digitsOnly.length > 16 ? digitsOnly.substring(0, 16) : digitsOnly;

    final buffer = StringBuffer();
    for (int i = 0; i < limited.length; i++) {
      buffer.write(limited[i]);
      final isLast = i == limited.length - 1;
      final nextIsBlockEnd = ((i + 1) % 4 == 0) && !isLast;
      if (nextIsBlockEnd) buffer.write(' ');
    }

    final formatted = buffer.toString();

    // Calculate new cursor position
    int offset = formatted.length - newValue.text.length;
    int newOffset = newValue.selection.baseOffset + offset;
    if (newOffset < 0) newOffset = 0;
    if (newOffset > formatted.length) newOffset = formatted.length;

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: newOffset),
    );
  }
}

