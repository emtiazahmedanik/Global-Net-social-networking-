// import 'dart:developer';
// import 'package:dimake/core/const/stripe_keys.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';

// class StripeService {
//   StripeService._();

//   static final StripeService instance = StripeService._();

//   Future<void> setupPaymentMethod() async {
//     try {
//       // Step 1: Create SetupIntent and retrieve client secret
//       String? setupIntentClientSecret = await _createSetupIntent();

//       if (setupIntentClientSecret == null) {
//         log('Setup Intent creation failed');
//         return;
//       }

//       log('Setup Intent Created: $setupIntentClientSecret');

//       // Step 2: Initialize the Payment Sheet with SetupIntent
//       await Stripe.instance.initPaymentSheet(
//         paymentSheetParameters: SetupPaymentSheetParameters(
//           setupIntentClientSecret: setupIntentClientSecret,
//           merchantDisplayName: "Bd Calling IT",
//         ),
//       );

//       // Step 3: Present the Payment Sheet for the user to confirm the payment method
//       await _confirmSetupIntent(setupIntentClientSecret);
//     } catch (e) {
//       log('Setup Failed: $e');
//     }
//   }

//   Future<void> _confirmSetupIntent(String setupIntentClientSecret) async {
//     try {
//       // Present the Payment Sheet for the user
//       await Stripe.instance.presentPaymentSheet();

//       // Confirm that the Payment Sheet was successfully completed
//       log('Setup Successful!');

//       // Step 4: Retrieve final details including the payment method ID
//       await _getSetupDetails(setupIntentClientSecret);
//     } catch (e) {
//       log('Setup Confirmation Failed: $e');
//     }
//   }

//   Future<void> _getSetupDetails(String setupIntentClientSecret) async {
//     try {
//       final Dio dio = Dio();

//       // Extract SetupIntent ID from the client secret
//       final setupIntentId = setupIntentClientSecret.split('_secret')[0];
//       log('Setup Intent ID: $setupIntentId');

//       // Retrieve SetupIntent details from Stripe
//       var response = await dio.get(
//         "https://api.stripe.com/v1/setup_intents/$setupIntentId",
//         options: Options(
//           headers: {
//             "Authorization": "Bearer $stripeSecretKey",
//             "Content-Type": 'application/x-www-form-urlencoded'
//           },
//         ),
//       );

//       log('Response Status: ${response.statusCode}');
//       log('Response Data: ${response.data}');

//       // Retrieve and log the payment method ID if available
//       if (response.data != null && response.data['payment_method'] != null) {
//         String paymentMethodId = response.data['payment_method'];
//         log('Payment Method ID: $paymentMethodId');
//       } else {
//         log('No payment method returned from Stripe');
//       }
//     } catch (e) {
//       log('Failed to retrieve setup details: $e');
//     }
//   }

//   Future<String?> _createSetupIntent() async {
//     try {
//       final Dio dio = Dio();
//       Map<String, dynamic> data = {
//         "payment_method_types[]": "card",
//         // Uncomment if associating with a customer
//         // "customer": "cus_yourCustomerIdHere",
//       };
//       var response = await dio.post(
//         "https://api.stripe.com/v1/setup_intents",
//         data: data,
//         options: Options(
//           contentType: Headers.formUrlEncodedContentType,
//           headers: {
//             "Authorization": "Bearer $stripeSecretKey",
//           },
//         ),
//       );

//       if (response.data != null) {
//         log('Setup Intent Response: ${response.data}');
//         return response.data["client_secret"];
//       }
//       return null;
//     } catch (e) {
//       log('Error creating SetupIntent: $e');
//       return null;
//     }
//   }
// }

// import 'dart:developer';
// import 'package:dimake/core/const/stripe_keys.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';

// class StripeService {
//   StripeService._();

//   static final StripeService instance = StripeService._();

//   /// Sets up a payment method using Stripe.
//   Future<String?> setupPaymentMethod() async {
//     try {
//       // Step 1: Create SetupIntent and retrieve client secret
//       String? setupIntentClientSecret = await _createSetupIntent();

//       if (setupIntentClientSecret == null) {
//         log('Setup Intent creation failed');
//         return null;
//       }

//       log('Setup Intent Created: $setupIntentClientSecret');

//       // Step 2: Initialize the Payment Sheet with SetupIntent
//       await Stripe.instance.initPaymentSheet(
//         paymentSheetParameters: SetupPaymentSheetParameters(
//           setupIntentClientSecret: setupIntentClientSecret,
//           merchantDisplayName: "Bd Calling IT",
//         ),
//       );

//       // Step 3: Present the Payment Sheet and confirm the payment method
//       String? paymentMethodId =
//           await _confirmSetupIntent(setupIntentClientSecret);
//       return paymentMethodId;
//     } catch (e) {
//       log('Setup Failed: $e');
//       return null;
//     }
//   }

//   /// Confirms the SetupIntent and retrieves the payment method ID.
//   Future<String?> _confirmSetupIntent(String setupIntentClientSecret) async {
//     try {
//       // Present the Payment Sheet for the user
//       await Stripe.instance.presentPaymentSheet();

//       log('Setup Successful!');

//       // Step 4: Retrieve and return the payment method ID
//       return await _getPaymentMethodId(setupIntentClientSecret);
//     } catch (e) {
//       log('Setup Confirmation Failed: $e');
//       return null;
//     }
//   }

//   /// Retrieves the payment method ID from the SetupIntent.
//   Future<String?> _getPaymentMethodId(String setupIntentClientSecret) async {
//     try {
//       final Dio dio = Dio();

//       // Extract SetupIntent ID from the client secret
//       final setupIntentId = setupIntentClientSecret.split('_secret')[0];
//       log('Setup Intent ID: $setupIntentId');

//       // Retrieve SetupIntent details from Stripe
//       var response = await dio.get(
//         "https://api.stripe.com/v1/setup_intents/$setupIntentId",
//         options: Options(
//           headers: {
//             "Authorization": "Bearer $stripeSecretKey",
//             "Content-Type": 'application/x-www-form-urlencoded',
//           },
//         ),
//       );

//       log('Response Status: ${response.statusCode}');
//       log('Response Data: ${response.data}');

//       // Retrieve and return the payment method ID
//       if (response.data != null && response.data['payment_method'] != null) {
//         String paymentMethodId = response.data['payment_method'];
//         log('Payment Method ID: $paymentMethodId');
//         return paymentMethodId;
//       } else {
//         log('No payment method returned from Stripe');
//         return null;
//       }
//     } catch (e) {
//       log('Failed to retrieve payment method ID: $e');
//       return null;
//     }
//   }

//   /// Creates a SetupIntent using Stripe API.
//   Future<String?> _createSetupIntent() async {
//     try {
//       final Dio dio = Dio();
//       Map<String, dynamic> data = {
//         "payment_method_types[]": "card",
//         // Uncomment if associating with a customer
//         // "customer": "cus_yourCustomerIdHere",
//       };
//       var response = await dio.post(
//         "https://api.stripe.com/v1/setup_intents",
//         data: data,
//         options: Options(
//           contentType: Headers.formUrlEncodedContentType,
//           headers: {
//             "Authorization": "Bearer $stripeSecretKey",
//           },
//         ),
//       );

//       if (response.data != null) {
//         log('Setup Intent Response: ${response.data}');
//         return response.data["client_secret"];
//       }
//       return null;
//     } catch (e) {
//       log('Error creating SetupIntent: $e');
//       return null;
//     }
//   }
// }
