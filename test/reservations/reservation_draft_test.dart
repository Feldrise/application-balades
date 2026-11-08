import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:balade/features/reservations/reservation_draft.dart';
import 'package:flutter_test/flutter_test.dart';

const _adult = RamblePrice(label: 'Adulte', amount: 12.5);
const _child = RamblePrice(label: 'Enfant', amount: 6);

ReservationDraft _draft({List<RamblePrice> prices = const [_adult, _child], int? placesLeft, int maxParticipants = 10}) =>
    ReservationDraft(prices: prices, placesLeft: placesLeft, maxParticipants: maxParticipants);

void main() {
  group('counters', () {
    test('starts with one participant on the first tariff', () {
      final draft = _draft();

      expect(draft.total, 1);
      expect(draft.countFor('Adulte'), 1);
      expect(draft.countFor('Enfant'), 0);
    });

    test('creates one line per participant with its tariff, from the counters', () {
      final draft = _draft().increment('Adulte').increment('Enfant');

      expect(draft.participants.map((p) => p.priceLabel), ['Adulte', 'Adulte', 'Enfant']);
      expect(draft.countFor('Adulte'), 2);
      expect(draft.countFor('Enfant'), 1);
    });

    test('a ramble without price has a single counter of people without tariff', () {
      final draft = _draft(prices: const []).increment('');

      expect(draft.hasTariffChoice, isFalse);
      expect(draft.countFor(''), 2);
      expect(draft.participants.map((p) => p.priceLabel), ['', '']);
    });

    test('a ramble with a single price has a single counter too', () {
      final draft = _draft(prices: const [_adult]);

      expect(draft.hasTariffChoice, isFalse);
      expect(draft.participants.single.priceLabel, 'Adulte');
    });

    test('cannot go beyond the places the API allows per reservation', () {
      final draft = _draft(maxParticipants: 2).increment('Adulte');

      expect(draft.total, 2);
      expect(draft.canIncrement, isFalse);
      expect(draft.increment('Adulte').total, 2);
    });

    test('cannot go below one participant', () {
      final draft = _draft().decrement('Adulte');

      expect(draft.total, 1);
      expect(draft.canDecrement('Adulte'), isFalse);
    });

    test('cannot decrement a tariff that has no participant', () {
      final draft = _draft().increment('Adulte');

      expect(draft.canDecrement('Enfant'), isFalse);
      expect(draft.decrement('Enfant').total, 2);
    });

    test('decrementing drops an empty line rather than a named one', () {
      final draft = _draft().increment('Adulte').withParticipant(1, firstName: 'Paul', lastName: 'Durand').withParticipant(0, firstName: '', lastName: '').decrement('Adulte');

      expect(draft.participants.single.firstName, 'Paul');
    });
  });

  group('lines', () {
    test('removes a line, whoever it is', () {
      final draft = _draft().increment('Enfant').removeParticipant(0);

      expect(draft.participants.map((p) => p.priceLabel), ['Enfant']);
    });

    test('keeps at least one line', () {
      final draft = _draft().removeParticipant(0);

      expect(draft.total, 1);
    });

    test('changing the tariff of a line moves the counters', () {
      final draft = _draft().increment('Adulte').withParticipant(1, priceLabel: 'Enfant');

      expect(draft.countFor('Adulte'), 1);
      expect(draft.countFor('Enfant'), 1);
    });

    test('prefills the first line with the connected user, marked as the booker', () {
      final draft = _draft().prefilledWith(firstName: 'Claire', lastName: 'Martin');

      expect(draft.participants.first.firstName, 'Claire');
      expect(draft.participants.first.lastName, 'Martin');
      expect(draft.participants.first.isBooker, isTrue);
    });

    test('does not overwrite a line the user already typed in', () {
      final draft = _draft().withParticipant(0, firstName: 'Paul', lastName: 'Durand').prefilledWith(firstName: 'Claire', lastName: 'Martin');

      expect(draft.participants.first.firstName, 'Paul');
      expect(draft.participants.first.isBooker, isFalse);
    });

    test('only one line can be the booker', () {
      final draft = _draft().increment('Adulte').withParticipant(0, isBooker: true).withParticipant(1, isBooker: true);

      expect(draft.participants.map((p) => p.isBooker), [false, true]);
    });
  });

  group('estimated amount', () {
    test('sums the tariffs of the participants, in cents', () {
      final draft = _draft().increment('Adulte').increment('Enfant');

      expect(draft.estimatedAmountCents, 3100);
    });

    test('is zero for a free ramble', () {
      expect(_draft(prices: const []).increment('').estimatedAmountCents, 0);
    });

    test('does not lose cents on prices like 9.90', () {
      final draft = _draft(prices: const [RamblePrice(label: 'Adulte', amount: 9.9)]).increment('Adulte').increment('Adulte');

      expect(draft.estimatedAmountCents, 2970);
    });
  });

  group('waiting list', () {
    test('warns when the participants exceed the places left', () {
      final draft = _draft(placesLeft: 2).increment('Adulte').increment('Adulte');

      expect(draft.total, 3);
      expect(draft.goesToWaitingList, isTrue);
    });

    test('does not warn when everybody fits', () {
      expect(_draft(placesLeft: 2).increment('Adulte').goesToWaitingList, isFalse);
    });

    test('warns on a full ramble', () {
      expect(_draft(placesLeft: 0).goesToWaitingList, isTrue);
    });

    test('never warns on an unlimited ramble', () {
      expect(_draft(maxParticipants: 20).increment('Adulte').goesToWaitingList, isFalse);
    });
  });

  group('request', () {
    test('builds the API payload with trimmed names and the booker flag', () {
      final request = _draft()
          .increment('Enfant')
          .prefilledWith(firstName: 'Claire', lastName: 'Martin')
          .withParticipant(1, firstName: ' Léo ', lastName: 'Martin ')
          .toRequest(rambleId: 3, contactEmail: ' claire@example.com ', contactPhone: '');

      expect(request.rambleId, 3);
      expect(request.contactEmail, 'claire@example.com');
      expect(request.contactPhone, isNull);
      expect(request.participants.map((p) => (p.firstName, p.lastName, p.priceLabel, p.isBooker)), [('Claire', 'Martin', 'Adulte', true), ('Léo', 'Martin', 'Enfant', false)]);
    });
  });
}
