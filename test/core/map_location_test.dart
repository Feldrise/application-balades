import 'package:balade/core/map_location.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('a Google Maps link whose coordinates are encoded in the query is read', () {
    expect(parseMapLocation('https://maps.google.com/?q=48.8566%2C%202.3522'), (latitude: 48.8566, longitude: 2.3522));
  });

  test('a link whose percent-encoding is broken is not a place, without failing', () {
    expect(parseMapLocation('https://maps.google.com/?q=48%'), isNull);
  });
}
