import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();

  static Future<void> init() async {
    Stripe.publishableKey = "";
    await Stripe.instance.applySettings();
  }

  Future<String?> createSetupIntent() async {
    try {
      final Dio dio = Dio();
      var response = await dio.post(
        "https://api.stripe.com/v1/setup_intents",
        data: {"usage": "off_session"},
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            "Authorization": "Bearer ",
            "Content-Type": 'application/x-www-form-urlencoded',
          },
        ),
      );
      if (response.data != null) {
        return response.data["client_secret"];
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("Error creating setup intent: $e");
      }
      return null;
    }
  }

  Future<bool> initPaymentSheet() async {
    try {
      String? setupIntentClientSecret = await createSetupIntent();

      if (setupIntentClientSecret == null) {
        if (kDebugMode) {
          print("Setup Intent creation failed.");
        }
        return false;
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          setupIntentClientSecret: setupIntentClientSecret,
          merchantDisplayName: "SpectraSynq",
          style: ThemeMode.light,
          billingDetails: const BillingDetails(
            name: 'Test User',
            email: 'test@example.com',
          ),
        ),
      );

      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Error initializing payment sheet: $e");
      }
      return false;
    }
  }

  // Present payment sheet to user
  Future<Map<String, dynamic>?> presentPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();

      if (kDebugMode) {
        print("Payment method saved successfully!");
      }

      // Return success result
      return {'success': true, 'message': 'Payment method added successfully'};
    } catch (e) {
      if (kDebugMode) {
        print("Error presenting payment sheet: $e");
      }

      String errorMessage = 'Failed to add payment method';
      if (e is StripeException) {
        errorMessage = e.error.localizedMessage ?? errorMessage;
      }

      return {'success': false, 'message': errorMessage};
    }
  }

  Future<Map<String, dynamic>?> addPaymentMethod() async {
    try {
      bool initialized = await initPaymentSheet();

      if (!initialized) {
        return {
          'success': false,
          'message': 'Failed to initialize payment sheet',
        };
      }

      return await presentPaymentSheet();
    } catch (e) {
      if (kDebugMode) {
        print("Error in addPaymentMethod: $e");
      }
      return {'success': false, 'message': 'Something went wrong'};
    }
  }

  Future<bool> makePayment(int amount, String currency) async {
    try {
      String? paymentIntentClientSecret = await _createPaymentIntent(
        amount,
        currency,
      );

      if (paymentIntentClientSecret == null) {
        if (kDebugMode) {
          print("Payment Intent creation failed.");
        }
        return false;
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: "SpectraSynq",
        ),
      );

      bool isPaymentSuccess = await _processPayment();
      if (kDebugMode) {
        print("Payment successful result: $isPaymentSuccess");
      }
      return isPaymentSuccess;
    } catch (e) {
      if (kDebugMode) {
        print("Payment failed: $e");
      }
      return false;
    }
  }

  Future<bool> _processPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      if (kDebugMode) {
        print("Payment confirmed successfully!");
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Error processing payment: $e");
      }
      return false;
    }
  }

  Future<String?> _createPaymentIntent(int amount, String currency) async {
    try {
      final Dio dio = Dio();
      Map<String, dynamic> data = {
        "amount": _calculateAmount(amount),
        "currency": currency,
      };
      var response = await dio.post(
        "https://api.stripe.com/v1/payment_intents",
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            "Authorization": "Bearer ",
            "Content-Type": 'application/x-www-form-urlencoded',
          },
        ),
      );
      if (response.data != null) {
        return response.data["client_secret"];
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("Error creating payment intent: $e");
      }
      return null;
    }
  }

  String _calculateAmount(int amount) {
    final calculatedAmount = amount * 100;
    return calculatedAmount.toString();
  }
}
