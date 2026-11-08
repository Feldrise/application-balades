import 'dart:convert';

import 'package:balade/features/authentication/data/models/authed_user/authed_user.dart';
import 'package:balade/features/guides/models/guide/guide.dart';
import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:balade/features/users/models/user/user.dart';
import 'package:http/http.dart' as http;

import '../management/management_app.dart';

/// The booker signed in during the booker tests.
final booker = AuthedUser(
  user: const User(40, email: 'claire@example.com', roles: ['user'], permissions: []),
  token: 'booker-token',
);

/// The guide of the balade, with the phone they gave.
const guideWithPhone = Guide(7, firstName: 'Vera', lastName: 'Lemoine', email: 'vera@example.com', phone: '+33612345678', isActive: true);

/// The balade of the reservations, as the public API gives it.
Ramble publicBalade({
  int id = 3,
  List<Guide> guides = const [guideWithPhone],
  String? meetingPoint = 'Parking de l\'étang, Paimpont',
  double? latitude = 48.0156,
  double? longitude = -2.1696,
  String? equipment = 'Chaussures de marche et une gourde',
  String? prerequisites = 'Savoir marcher deux heures',
  DateTime? date,
}) => Ramble(
  id,
  title: 'Sortie champignons',
  type: 'champignons',
  difficulty: 'facile',
  date: date ?? DateTime.utc(2026, 12, 1, 9),
  location: 'Forêt de Paimpont',
  meetingPoint: meetingPoint,
  meetingLatitude: latitude,
  meetingLongitude: longitude,
  equipmentNeeded: equipment,
  prerequisites: prerequisites,
  guides: guides,
  paymentEnabled: true,
  publishedAt: DateTime.utc(2026, 10, 1),
);

/// A reservation of the booker for the balade 3, as the API gives it.
Map<String, Object?> bookerReservation({
  int id = 12,
  String status = 'pending',
  String? confirmationDeadline,
  int estimatedAmount = 1850,
  int amountPaid = 0,
  List<Map<String, Object?>>? participants,
}) => {
  'id': id,
  'created_at': '2026-11-02T10:00:00Z',
  'updated_at': '2026-11-02T10:00:00Z',
  'ramble_id': 3,
  'user_id': 40,
  'contact_email': 'claire@example.com',
  'status': status,
  'confirmation_deadline': confirmationDeadline,
  'participants':
      participants ??
      [
        {'id': 1, 'first_name': 'Claire', 'last_name': 'Martin', 'price_label': 'Adulte', 'price_amount': 12.5, 'is_booker': true},
        {'id': 2, 'first_name': 'Léo', 'last_name': 'Martin', 'price_label': 'Enfant', 'price_amount': 6.0, 'is_booker': false},
      ],
  'estimated_amount': estimatedAmount,
  'has_missing_prices': false,
  'has_successful_payment': amountPaid > 0,
  'payments': amountPaid > 0
      ? [
          {'id': 5, 'created_at': '2026-11-02T10:00:00Z', 'amount': amountPaid, 'currency': 'eur', 'status': 'succeeded', 'paid_at': '2026-11-03T10:00:00Z'},
        ]
      : [],
  'amount_paid': amountPaid,
  'amount_due': estimatedAmount - amountPaid,
  'ramble': {'title': 'Sortie champignons', 'date': '2026-12-01T09:00:00Z', 'location': 'Forêt de Paimpont'},
};

/// The fake API of a booker: their reservations, and the balade they are for.
class BookerApi extends FakeApi {
  BookerApi({required Ramble ramble, required List<Map<String, Object?>> bookings}) : bookings = [...bookings], super(rambles: [ramble]);

  final List<Map<String, Object?>> bookings;

  @override
  Future<http.Response> handle(http.Request request) async {
    final path = request.url.path;
    if (request.method == 'GET' && path.endsWith('/reservations')) return _ok(bookings);
    final id = RegExp(r'/reservations/(\d+)$').firstMatch(path)?.group(1);
    if (request.method == 'GET' && id != null) {
      final found = bookings.where((r) => '${r['id']}' == id).firstOrNull;
      return found == null ? http.Response('{"error":"not found"}', 404) : _ok(found);
    }
    final participantRemoved = RegExp(r'/reservations/(\d+)/participants/(\d+)$').firstMatch(path);
    if (request.method == 'DELETE' && participantRemoved != null) {
      requests.add(request);
      final index = bookings.indexWhere((r) => '${r['id']}' == participantRemoved.group(1));
      final participants = [
        for (final p in bookings[index]['participants'] as List)
          if ('${(p as Map)['id']}' != participantRemoved.group(2)) p,
      ];
      bookings[index] = {...bookings[index], 'participants': participants};
      return _ok(bookings[index]);
    }
    final cancelled = RegExp(r'/reservations/(\d+)/cancel$').firstMatch(path)?.group(1);
    if (request.method == 'PUT' && cancelled != null) {
      requests.add(request);
      final index = bookings.indexWhere((r) => '${r['id']}' == cancelled);
      bookings[index] = {...bookings[index], 'status': 'cancelled'};
      return _ok(bookings[index]);
    }
    return super.handle(request);
  }

  static http.Response _ok(Object body) => http.Response.bytes(utf8.encode(jsonEncode(body)), 200, headers: {'content-type': 'application/json; charset=utf-8'});
}
