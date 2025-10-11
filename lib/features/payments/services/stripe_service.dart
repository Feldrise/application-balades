import 'package:flutter_stripe/flutter_stripe.dart';

class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();

  /// Initialize Stripe with publishable key
  void initialize(String publishableKey) {
    Stripe.publishableKey = publishableKey;
    Stripe.instance.applySettings();
  }

  /// Confirm payment with client secret
  Future<PaymentIntent> confirmPayment(String clientSecret) async {
    try {
      final result = await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: clientSecret,
        data: const PaymentMethodParams.card(paymentMethodData: PaymentMethodData(billingDetails: BillingDetails())),
      );

      return result;
    } catch (e) {
      throw StripeException('Payment confirmation failed: $e');
    }
  }

  /// Create payment method for card
  Future<PaymentMethod> createPaymentMethod(CardFieldInputDetails cardDetails) async {
    try {
      final result = await Stripe.instance.createPaymentMethod(
        params: PaymentMethodParams.card(paymentMethodData: PaymentMethodData(billingDetails: BillingDetails())),
      );

      return result;
    } catch (e) {
      throw StripeException('Payment method creation failed: $e');
    }
  }
}

/// Exception for Stripe-specific errors
class StripeException implements Exception {
  final String message;

  const StripeException(this.message);

  @override
  String toString() => 'StripeException: $message';
}
