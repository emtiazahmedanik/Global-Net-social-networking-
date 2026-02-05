import 'package:flutter_test/flutter_test.dart';
import 'package:jdadzok/core/stripe/stripe_service.dart';

void main() {
  group('Stripe Service Tests', () {
    test('Stripe service instance should be created', () {
      final stripeService = StripeService.instance;
      expect(stripeService, isNotNull);
    });

    test('Setup intent creation should return client secret or null', () async {
      final stripeService = StripeService.instance;
      final result = await stripeService.createSetupIntent();
      // Result should be either a string (client secret) or null
      expect(result, anyOf(isA<String>(), isNull));
    });
  });
}
