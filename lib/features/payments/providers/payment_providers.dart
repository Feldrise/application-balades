import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/features/payments/models/payment.dart';
import 'package:balade/features/payments/services/payments_service.dart';
import 'package:balade/features/payments/services/stripe_service.dart';
import 'package:balade/features/registrations/services/registration_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

// Provider for payments service
final paymentsServiceProvider = Provider<PaymentsService>((ref) {
  return PaymentsService.instance;
});

// Provider for registration service
final registrationServiceProvider = Provider<RegistrationService>((ref) {
  return RegistrationService.instance;
});

// Provider for Stripe service
final stripeServiceProvider = Provider<StripeService>((ref) {
  return StripeService.instance;
});

// Provider to get a specific payment by ID
final paymentProvider = FutureProvider.autoDispose.family<Payment, int>((ref, paymentId) async {
  final authed = ref.watch(authenticationProvider);
  final service = ref.read(paymentsServiceProvider);

  if (authed == null) {
    throw Exception('NOT_AUTHENTICATED');
  }

  return await service.getPayment(paymentId, authorization: 'Bearer ${authed.token}');
});

// Provider to get payments for a registration
final registrationPaymentsProvider = FutureProvider.autoDispose.family<List<Payment>, int>((ref, registrationId) async {
  final authed = ref.watch(authenticationProvider);
  final service = ref.read(paymentsServiceProvider);

  if (authed == null) {
    throw Exception('NOT_AUTHENTICATED');
  }

  return await service.getRegistrationPayments(registrationId, authorization: 'Bearer ${authed.token}');
});

// Provider to get payments for a group
final groupPaymentsProvider = FutureProvider.autoDispose.family<List<Payment>, int>((ref, groupId) async {
  final authed = ref.watch(authenticationProvider);
  final service = ref.read(paymentsServiceProvider);

  if (authed == null) {
    throw Exception('NOT_AUTHENTICATED');
  }

  return await service.getGroupPayments(groupId, authorization: 'Bearer ${authed.token}');
});

// Provider to get registration group details
final registrationGroupProvider = FutureProvider.autoDispose.family<RegistrationGroup?, int>((ref, groupId) async {
  final authed = ref.watch(authenticationProvider);
  final service = ref.read(registrationServiceProvider);

  if (authed == null) {
    throw Exception('NOT_AUTHENTICATED');
  }

  return await service.getGroupDetails(groupId, authorization: 'Bearer ${authed.token}');
});

// State for payment actions
class PaymentActionsState {
  final bool isLoading;
  final String? error;
  final PaymentCreationResponse? currentPayment;
  final String? stripePublishableKey;

  const PaymentActionsState({this.isLoading = false, this.error, this.currentPayment, this.stripePublishableKey});

  PaymentActionsState copyWith({bool? isLoading, String? error, PaymentCreationResponse? currentPayment, String? stripePublishableKey}) {
    return PaymentActionsState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      currentPayment: currentPayment ?? this.currentPayment,
      stripePublishableKey: stripePublishableKey ?? this.stripePublishableKey,
    );
  }
}

// StateNotifier for payment actions
class PaymentActionsNotifier extends StateNotifier<PaymentActionsState> {
  final PaymentsService _paymentsService;
  final StripeService _stripeService;
  final String? _authToken;

  PaymentActionsNotifier(this._paymentsService, this._stripeService, this._authToken) : super(const PaymentActionsState());

  /// Initialize payment for registration or group
  Future<bool> initializePayment(PaymentCreationRequest request) async {
    if (_authToken == null) {
      state = state.copyWith(error: 'Authentication required');
      return false;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _paymentsService.createPayment(request, authorization: 'Bearer $_authToken');

      // Initialize Stripe with the publishable key
      _stripeService.initialize(response.publishableKey);

      state = state.copyWith(isLoading: false, currentPayment: response, stripePublishableKey: response.publishableKey);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  /// Confirm payment using Stripe
  Future<bool> confirmPayment() async {
    if (state.currentPayment == null) {
      state = state.copyWith(error: 'No payment initialized');
      return false;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _stripeService.confirmPayment(state.currentPayment!.clientSecret);

      if (result.status == PaymentIntentsStatus.Succeeded) {
        state = state.copyWith(isLoading: false);
        return true;
      } else {
        state = state.copyWith(isLoading: false, error: 'Payment was not successful');
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  /// Check payment status
  Future<Payment?> checkPaymentStatus() async {
    if (state.currentPayment == null || _authToken == null) {
      return null;
    }

    try {
      return await _paymentsService.getPayment(state.currentPayment!.payment.id, authorization: 'Bearer $_authToken');
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Reset state
  void reset() {
    state = const PaymentActionsState();
  }
}

// Provider for payment actions
final paymentActionsProvider = StateNotifierProvider.autoDispose<PaymentActionsNotifier, PaymentActionsState>((ref) {
  final authed = ref.watch(authenticationProvider);
  return PaymentActionsNotifier(ref.read(paymentsServiceProvider), ref.read(stripeServiceProvider), authed?.token);
});

/// Helper to determine if a registration needs payment
bool registrationNeedsPayment(dynamic registration, dynamic ramble) {
  // Check if ramble has payment enabled
  if (ramble?.paymentEnabled != true) return false;

  // Check if registration is confirmed
  if (registration?.status != 'confirmed') return false;

  // Check if payment is required or optional
  return ramble?.paymentRequired == true;
}

/// Helper to check if payment is available for a registration
bool paymentAvailableForRegistration(dynamic registration, dynamic ramble) {
  // Check if ramble has payment enabled
  if (ramble?.paymentEnabled != true) return false;

  // Check if registration is confirmed
  if (registration?.status != 'confirmed') return false;

  return true;
}
