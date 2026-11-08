import 'package:balade/features/payments/services/stripe_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider for Stripe service
final stripeServiceProvider = Provider<StripeService>((ref) {
  return StripeService.instance;
});
