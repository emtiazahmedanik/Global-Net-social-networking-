import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/const/app_colors.dart';
import 'package:jdadzok/core/style/global_text_style.dart';
import 'package:jdadzok/feature/create_ngo/create_ngo_verify_screen/model/create_ngo_verify_model.dart';
import 'package:jdadzok/feature/create_ngo/ngo_profile_donation_screen/service/ngo_donation_service.dart';

class NgoDonationDialogWidget extends StatefulWidget {
  final OrganizationModel org;
  
  const NgoDonationDialogWidget({
    super.key,
    required this.org,
  });

  @override
  State<NgoDonationDialogWidget> createState() => _NgoDonationDialogWidgetState();
}

class _NgoDonationDialogWidgetState extends State<NgoDonationDialogWidget> {
  final TextEditingController amountController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  Future<void> _makeDonation() async {
    final amountText = amountController.text.trim();
    
    if (amountText.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter an amount',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
      return;
    }

    final amount = int.tryParse(amountText);
    if (amount == null || amount <= 0) {
      Get.snackbar(
        'Error',
        'Please enter a valid amount',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    EasyLoading.show(status: 'Processing donation...');

    try {
      final response = await NgoDonationService.makeDonation(
        ngoId: widget.org.id,
        amount: amount,
      );

      EasyLoading.dismiss();

      if (response != null && response['success'] == true) {
        Get.back();
        EasyLoading.showSuccess(
          response['message'] ?? 'Donation processed successfully',
        );
      } else {
        final errorMessage = response?['message'] ?? response?['error'] ?? 'Failed to process donation';
        EasyLoading.showError(errorMessage);
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('Something went wrong. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Donate to ${widget.org.profile?.name ?? "Organization"}',
        style: globalTextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enter donation amount',
            style: globalTextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 12),
          TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            enabled: !isLoading,
            decoration: InputDecoration(
              hintText: 'Amount',
              prefixText: '\$ ',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: isLoading ? null : () {
            Get.back();
          },
          child: Text(
            'Cancel',
            style: globalTextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: isLoading ? null : _makeDonation,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: Colors.white,
          ),
          child: isLoading
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  'Donate',
                  style: globalTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ),
      ],
    );
  }
}

