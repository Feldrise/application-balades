import 'dart:convert';

import 'package:balade/core/constants.dart';
import 'package:balade/features/admin/reservations_management/models/admin_reservation_filter.dart';
import 'package:balade/features/admin/reservations_management/models/admin_reservation_list.dart';
import 'package:balade/features/admin/reservations_management/models/bulk_reservation_action_result.dart';
import 'package:balade/features/reservations/models/reservation/create_reservation_request.dart';
import 'package:balade/features/reservations/models/reservation/reservation.dart';
import 'package:http/http.dart' as http;

/// A reservation refused by the API, with its machine-readable reason when it has one.
class ReservationException implements Exception {
  const ReservationException(this.message, {this.reason});

  final String message;
  final String? reason;

  @override
  String toString() => message;
}

/// The booker already has a reservation for this ramble: [reservationId] is that reservation.
class ReservationAlreadyExistsException extends ReservationException {
  const ReservationAlreadyExistsException(super.message, {required this.reservationId}) : super(reason: 'reservation_already_exists');

  final int reservationId;
}

/// A payment the booker has to make right away, created by the API from the participants' tariffs.
class PaymentToMake {
  const PaymentToMake({required this.amount, required this.clientSecret, required this.publishableKey});

  factory PaymentToMake.fromJson(Map<String, Object?> json) {
    final payment = json['payment'] as Map<String, Object?>;
    return PaymentToMake(amount: (payment['amount'] as num).toInt(), clientSecret: json['client_secret'] as String, publishableKey: json['publishable_key'] as String);
  }

  /// Amount in cents
  final int amount;

  /// Stripe client secret of the payment intent, on the guide's account
  final String clientSecret;

  /// Stripe publishable key of the guide
  final String publishableKey;
}

/// A reservation as saved, with the payment to make right away when there is one.
class ReservationWithPayment {
  const ReservationWithPayment(this.reservation, this.payment);

  factory ReservationWithPayment.fromJson(Map<String, Object?> json) {
    final payment = json['payment'];
    return ReservationWithPayment(Reservation.fromJson(json), payment is Map<String, Object?> ? PaymentToMake.fromJson(payment) : null);
  }

  final Reservation reservation;
  final PaymentToMake? payment;
}

class ReservationsService {
  ReservationsService({http.Client? client, String? baseUrl}) : _client = client ?? http.Client(), _serviceUrl = '${baseUrl ?? kApiBaseUrl}/reservations';

  static final ReservationsService instance = ReservationsService();

  final http.Client _client;
  final String _serviceUrl;

  /// Create a reservation. Public: the booker's account is found or created from the contact email.
  Future<Reservation> createReservation(CreateReservationRequest request) async {
    final response = await _client.post(Uri.parse(_serviceUrl), headers: _headers(null), body: jsonEncode(request.toJson()));

    if (response.statusCode == 201) {
      return Reservation.fromJson(jsonDecode(response.body) as Map<String, Object?>);
    }
    throw _exceptionFrom(response);
  }

  /// Get one reservation, for its booker or an allowed admin or guide
  Future<Reservation> fetchReservation(int id, {required String token}) async {
    final response = await _client.get(Uri.parse('$_serviceUrl/$id'), headers: _headers(token));

    if (response.statusCode == 200) {
      return Reservation.fromJson(jsonDecode(response.body) as Map<String, Object?>);
    }
    throw _exceptionFrom(response);
  }

  /// Get the reservations of the authenticated booker
  Future<List<Reservation>> fetchUserReservations({required String token}) async {
    final response = await _client.get(Uri.parse(_serviceUrl), headers: _headers(token));

    if (response.statusCode == 200) {
      final list = jsonDecode(response.body) as List<dynamic>;
      return list.map((json) => Reservation.fromJson(json as Map<String, Object?>)).toList();
    }
    throw _exceptionFrom(response);
  }

  /// Add participants to a reservation, all of them or none. Participants added to a confirmed
  /// reservation are confirmed with it, and their complementary payment comes with the reservation.
  Future<ReservationWithPayment> addParticipants(int id, List<ParticipantRequest> participants, {required String token}) async {
    final response = await _client.post(Uri.parse('$_serviceUrl/$id/participants'), headers: _headers(token), body: jsonEncode({'participants': participants.map((p) => p.toJson()).toList()}));
    return _reservationWithPaymentFrom(response);
  }

  /// Confirm the reservation, for its booker only. When online payment is enabled, the payment of the
  /// amount due comes with the reservation; confirming again a confirmed reservation gives what is still due.
  Future<ReservationWithPayment> confirmReservation(int id, {required String token}) async {
    final response = await _client.put(Uri.parse('$_serviceUrl/$id/confirm'), headers: _headers(token));
    return _reservationWithPaymentFrom(response);
  }

  /// Change the name and tariff of a participant, as long as the reservation is not paid
  Future<Reservation> updateParticipant(int id, int participantId, {required String firstName, required String lastName, required String priceLabel, required String token}) async {
    final response = await _client.put(
      Uri.parse('$_serviceUrl/$id/participants/$participantId'),
      headers: _headers(token),
      body: jsonEncode({'first_name': firstName, 'last_name': lastName, 'price_label': priceLabel}),
    );
    return _reservationFrom(response);
  }

  /// Remove a participant; removing the last one cancels the reservation
  Future<Reservation> removeParticipant(int id, int participantId, {required String token}) async {
    final response = await _client.delete(Uri.parse('$_serviceUrl/$id/participants/$participantId'), headers: _headers(token));
    return _reservationFrom(response);
  }

  /// Cancel the whole reservation
  Future<Reservation> cancelReservation(int id, {required String token}) async {
    final response = await _client.put(Uri.parse('$_serviceUrl/$id/cancel'), headers: _headers(token));
    return _reservationFrom(response);
  }

  // ===============================
  // ADMIN METHODS
  // ===============================

  /// List the reservations with their participants, for admins and guides: the API filters, sorts and
  /// paginates, and limits a guide to the rambles they guide.
  Future<AdminReservationList> fetchAdminReservations({
    required String token,
    AdminReservationFilter filter = const AdminReservationFilter(),
    int page = 1,
    int perPage = 50,
    String sortBy = 'created_at',
    bool sortAscending = false,
  }) async {
    String day(DateTime date) => date.toIso8601String().split('T')[0];

    final query = <String, Object>{
      if (filter.rambleId != null) 'ramble_id': '${filter.rambleId}',
      if (filter.userId != null) 'user_id': '${filter.userId}',
      if (filter.email?.isNotEmpty ?? false) 'email': filter.email!,
      if (filter.statuses?.isNotEmpty ?? false) 'statuses': filter.statuses!,
      if (filter.dateFrom != null) 'date_from': day(filter.dateFrom!),
      if (filter.dateTo != null) 'date_to': day(filter.dateTo!),
      if (filter.search?.isNotEmpty ?? false) 'search': filter.search!,
      if (filter.rambleTitle?.isNotEmpty ?? false) 'ramble_title': filter.rambleTitle!,
      'page': '$page',
      'per_page': '$perPage',
      'sort_by': sortBy,
      'sort_order': sortAscending ? 'asc' : 'desc',
    };

    final response = await _client.get(Uri.parse('$_serviceUrl/admin').replace(queryParameters: query), headers: _headers(token));

    if (response.statusCode == 200) {
      return AdminReservationList.fromJson(jsonDecode(response.body) as Map<String, Object?>);
    }
    throw _exceptionFrom(response);
  }

  /// Set the status of a reservation, as a whole. The API refuses with `not_enough_places` a reservation
  /// brought back to pending or confirmed that does not fit in the places left, and gives the places released
  /// to the waiting list. [sendEmail] tells the booker.
  Future<Reservation> updateReservationStatus(int id, {required String status, String? reason, bool sendEmail = false, required String token}) async {
    final response = await _client.put(
      Uri.parse('$_serviceUrl/admin/$id/status'),
      headers: _headers(token),
      body: jsonEncode({'status': status, if (reason != null) 'reason': reason, 'send_email': sendEmail}),
    );
    return _reservationFrom(response);
  }

  /// Delete a reservation; the places it held go to the waiting list
  Future<void> deleteReservation(int id, {required String token}) async {
    final response = await _client.delete(Uri.parse('$_serviceUrl/admin/$id'), headers: _headers(token));

    if (response.statusCode != 204) {
      throw _exceptionFrom(response);
    }
  }

  /// Apply an action (`confirm`, `cancel`, `move_to_waiting` or `delete`) to several reservations. Each one
  /// follows the rules of the single action and fails separately: see [BulkReservationActionResult.errors].
  Future<BulkReservationActionResult> performBulkAction(List<int> reservationIds, {required String action, String? reason, bool sendEmail = false, required String token}) async {
    final response = await _client.post(
      Uri.parse('$_serviceUrl/admin/bulk-action'),
      headers: _headers(token),
      body: jsonEncode({'reservation_ids': reservationIds, 'action': action, if (reason != null) 'reason': reason, 'send_email': sendEmail}),
    );

    if (response.statusCode == 200) {
      return BulkReservationActionResult.fromJson(jsonDecode(response.body) as Map<String, Object?>);
    }
    throw _exceptionFrom(response);
  }

  /// Correct the name or the tariff of a participant, the omitted fields being kept. Once the reservation
  /// is paid, the tariff is frozen (`reservation_paid`) but the name can still be corrected.
  Future<Reservation> updateParticipantAsAdmin(int id, int participantId, {String? firstName, String? lastName, String? priceLabel, required String token}) async {
    final response = await _client.put(
      Uri.parse('$_serviceUrl/admin/$id/participants/$participantId'),
      headers: _headers(token),
      body: jsonEncode({if (firstName != null) 'first_name': firstName, if (lastName != null) 'last_name': lastName, if (priceLabel != null) 'price_label': priceLabel}),
    );
    return _reservationFrom(response);
  }

  Reservation _reservationFrom(http.Response response) {
    if (response.statusCode == 200) {
      return Reservation.fromJson(jsonDecode(response.body) as Map<String, Object?>);
    }
    throw _exceptionFrom(response);
  }

  ReservationWithPayment _reservationWithPaymentFrom(http.Response response) {
    if (response.statusCode == 200) {
      return ReservationWithPayment.fromJson(jsonDecode(response.body) as Map<String, Object?>);
    }
    throw _exceptionFrom(response);
  }

  ReservationException _exceptionFrom(http.Response response) {
    Map<String, Object?> body = const {};
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, Object?>) body = decoded;
    } catch (_) {
      // Not a JSON error body: fall back to the status code below.
    }

    final message = (body['error'] as String?) ?? 'Reservation failed (${response.statusCode})';
    final reason = body['reason'] as String?;
    final reservationId = body['reservation_id'];
    if (reason == 'reservation_already_exists' && reservationId is int) {
      return ReservationAlreadyExistsException(message, reservationId: reservationId);
    }
    return ReservationException(message, reason: reason);
  }

  Map<String, String> _headers(String? token) => {'Content-Type': 'application/json', if (token != null) 'Authorization': 'Bearer $token'};
}
