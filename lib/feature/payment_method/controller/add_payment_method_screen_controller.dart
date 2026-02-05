import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/http_service/http_network_client.dart';
import 'package:jdadzok/core/network_caller/endpoints.dart';
import 'package:jdadzok/core/stripe/stripe_service.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:url_launcher/url_launcher.dart';

class AddPaymentMethodScreenController extends GetxController {
  var savedPaymentMethods = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  RxString incomingClientSecret = ''.obs;
  RxString incomingOrderId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getStripeAccount();
    loadSavedPaymentMethods();

    // If navigated here with a clientSecret (from order creation), process payment
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args['clientSecret'] != null) {
      incomingClientSecret.value = args['clientSecret'].toString();
      incomingOrderId.value = args['orderId']?.toString() ?? '';

      // Delay to allow screen to build before showing Stripe Payment Sheet
      Future.microtask(() async {
        await processPaymentForOrder();
      });
    }
  }

  // Load saved payment methods (mock data for now)
  void loadSavedPaymentMethods() {
    // In a real app, you would load this from a database or API
    // For now, we'll keep it empty and add methods through Stripe
  }

  // Add payment method using Stripe
  Future<void> addPaymentMethod() async {
    try {
      isLoading.value = true;
      EasyLoading.show(status: 'Setting up payment...');

      final result = await StripeService.instance.addPaymentMethod();

      if (result != null && result['success'] == true) {
        // Add mock payment method data (in real app, you'd get this from Stripe)
        savedPaymentMethods.add({
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'type': 'card',
          'brand': 'visa', // This would come from Stripe
          'last4': '4242', // This would come from Stripe
          'expMonth': 12,
          'expYear': 2025,
          'isDefault': savedPaymentMethods.isEmpty,
        });

        EasyLoading.showSuccess(
          result['message'] ?? 'Payment method added successfully',
        );
      } else {
        EasyLoading.showError(
          result?['message'] ?? 'Failed to add payment method',
        );
      }
    } catch (e) {
      EasyLoading.showError('Something went wrong: $e');
    } finally {
      isLoading.value = false;
      EasyLoading.dismiss();
    }
  }

  // Remove payment method
  void removePaymentMethod(String paymentMethodId) {
    savedPaymentMethods.removeWhere(
      (method) => method['id'] == paymentMethodId,
    );
    EasyLoading.showSuccess('Payment method removed');
  }

  // Set default payment method
  void setDefaultPaymentMethod(String paymentMethodId) {
    for (var method in savedPaymentMethods) {
      method['isDefault'] = method['id'] == paymentMethodId;
    }
    savedPaymentMethods.refresh();
    EasyLoading.showSuccess('Default payment method updated');
  }

  // Get formatted card info
  String getCardInfo(Map<String, dynamic> paymentMethod) {
    final brand = paymentMethod['brand']?.toString().toUpperCase() ?? '';
    final last4 = paymentMethod['last4']?.toString() ?? '';
    return '$brand •••• $last4';
  }

  Future<void> createStripeAccount() async {
    EasyLoading.show();
    try {
      final response = await HttpNetworkClient().postRequest(
        url: Urls.createStripeAccount,
        body: {},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        EasyLoading.dismiss();
        final data = response.responseData;
        debugPrint('data: $data');
        final accountLinkUrl = data?['data']['url'];
        if (accountLinkUrl != null) {
          // Open the account link URL in a webview or browser
          await openExternalBrowser(accountLinkUrl);
        } else {
          EasyLoading.showError('Failed to get account link URL');
        }
      } else {
        EasyLoading.showError('Failed to create Stripe account');
      }
    } catch (e) {
      debugPrint('Error creating Stripe account: $e');
    }finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> openExternalBrowser(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      debugPrint('Launching URL: $url');

      // Try to launch URL directly - avoid canLaunchUrl due to platform issues
      try {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } catch (e) {
        debugPrint('External app failed: $e, trying in-app browser');
        // Fallback to in-app browser
        try {
          await launchUrl(
            uri,
            mode: LaunchMode.inAppBrowserView,
          );
        } catch (fallbackError) {
          throw 'Could not launch URL: $fallbackError';
        }
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
      EasyLoading.dismiss();
      
      // Show a dialog with the URL so user can copy it
      Get.defaultDialog(
        title: 'Open Stripe Account Setup',
        content: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Could not open browser automatically.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              SelectableText(
                url,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Please copy the URL above and open it in your browser.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        textConfirm: 'Close',
        confirmTextColor: Colors.white,
        onConfirm: () => Get.back(),
      );
    }
  }

  RxString stripeAccountId = ''.obs;
  Rxn<Map<String, dynamic>> stripeAccountData = Rxn<Map<String, dynamic>>();

  Future<void> getStripeAccount() async{
    EasyLoading.show();
    try {

      final response = await HttpNetworkClient().getRequest(
        url: Urls.getStripeAccount,
      );
      
      final data = response.responseData;
      if (data?['status'] != 'success') {
        EasyLoading.dismiss();
        EasyLoading.showError('Failed to get Stripe account');
        return;
      }
      debugPrint('data: $data');
      final accountData = data?['data'];
      if (accountData != null) {
        EasyLoading.dismiss();
        stripeAccountId.value = accountData['id'] ?? '';
        stripeAccountData.value = accountData;
      } else {
        EasyLoading.showError('Failed to get account');
      }
    } catch (e) {
      debugPrint('Error fetching Stripe account: $e');
    }finally {
      EasyLoading.dismiss();
    }
  }

  /// Process payment using the clientSecret returned by order creation API
  Future<void> processPaymentForOrder() async {
    if (incomingClientSecret.value.isEmpty) return;

    try {
      EasyLoading.show(status: 'Processing payment...');

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: incomingClientSecret.value,
          merchantDisplayName: 'SpectraSynq',
          style: ThemeMode.light,
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      EasyLoading.showSuccess('Payment completed successfully');

      // After successful payment, you might want to navigate back or show confirmation
      Get.back();
    } on StripeException catch (e) {
      EasyLoading.showError(e.error.localizedMessage ?? 'Payment failed');
      debugPrint('Stripe error: ${e.error.localizedMessage}');
    } catch (e) {
      EasyLoading.showError('Payment failed');
      debugPrint('Payment error: $e');
    } finally {
      EasyLoading.dismiss();
    }
  }
}

