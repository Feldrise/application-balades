import 'dart:convert';
import 'package:balade/core/constants.dart';
import 'package:balade/features/payments/models/payment.dart';
import 'package:http/http.dart' as http;

class PaymentsService {
  PaymentsService._();

  final String serviceBaseUrl = '$kApiBaseUrl/payments';

  static final PaymentsService instance = PaymentsService._();

  /// Create a payment intent for a registration or group
  Future<PaymentCreationResponse> createPayment(PaymentCreationRequest request, {required String authorization}) async {
    final http.Response response = await http.post(
      Uri.parse(serviceBaseUrl),
      headers: {'Content-Type': 'application/json', 'Authorization': authorization},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return PaymentCreationResponse.fromJson(jsonDecode(response.body) as Map<String, Object?>);
    } else {
      throw Exception('Failed to create payment: ${response.body}');
    }
  }

  /// Get payment details by ID
  Future<Payment> getPayment(int id, {required String authorization}) async {
    final Uri uri = Uri.parse('$serviceBaseUrl/$id');
    final http.Response response = await http.get(uri, headers: {'Content-Type': 'application/json', 'Authorization': authorization});

    if (response.statusCode == 200) {
      return Payment.fromJson(jsonDecode(response.body) as Map<String, Object?>);
    } else {
      throw Exception('Failed to get payment: ${response.body}');
    }
  }

  /// Get all payments for a registration
  Future<List<Payment>> getRegistrationPayments(int registrationId, {required String authorization}) async {
    final Uri uri = Uri.parse('$kApiBaseUrl/registrations/$registrationId/payments');
    final http.Response response = await http.get(uri, headers: {'Content-Type': 'application/json', 'Authorization': authorization});

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
      return jsonList.map((json) => Payment.fromJson(json as Map<String, Object?>)).toList();
    } else {
      throw Exception('Failed to get registration payments: ${response.body}');
    }
  }

  /// Get all payments for a group
  Future<List<Payment>> getGroupPayments(int groupId, {required String authorization}) async {
    final Uri uri = Uri.parse('$serviceBaseUrl/groups/$groupId');
    final http.Response response = await http.get(uri, headers: {'Content-Type': 'application/json', 'Authorization': authorization});

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
      return jsonList.map((json) => Payment.fromJson(json as Map<String, Object?>)).toList();
    } else {
      throw Exception('Failed to get group payments: ${response.body}');
    }
  }

  /// Process a refund (admin only)
  Future<void> processRefund(int paymentId, RefundRequest request, {required String authorization}) async {
    final Uri uri = Uri.parse('$serviceBaseUrl/$paymentId/refund');
    final http.Response response = await http.post(uri, headers: {'Content-Type': 'application/json', 'Authorization': authorization}, body: jsonEncode(request.toJson()));

    if (response.statusCode != 200) {
      throw Exception('Failed to process refund: ${response.body}');
    }
  }
}

/// Exception for payment-specific errors
class PaymentException implements Exception {
  final String message;
  final int? statusCode;

  const PaymentException(this.message, {this.statusCode});

  @override
  String toString() => 'PaymentException: $message';
}
