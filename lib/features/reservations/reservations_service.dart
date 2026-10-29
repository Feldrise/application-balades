import 'dart:convert';

import 'package:balade/core/constants.dart';
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
