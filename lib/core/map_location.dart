/// A point on the map, as a latitude and a longitude in degrees.
typedef MapLocation = ({double latitude, double longitude});

const _number = r'[-+]?\d{1,3}(?:[.,]\d+)?';

/// The exact pin of a Google Maps place link: `!3d<lat>!4d<lng>`.
final _pin = RegExp('!3d($_number)!4d($_number)');

/// A viewport or a coordinates pair, in a path (`/@lat,lng,15z`) or in a query (`?q=lat,lng`, `ll=`, `query=`, `destination=`).
final _viewport = RegExp('@($_number),($_number)');
final _queryPair = RegExp('(?:[?&](?:q|ll|query|destination|daddr|center)=)($_number)(?:,|%2C)\\s*($_number)', caseSensitive: false);

/// Plain coordinates: `48.8566, 2.3522`, `48.8566 2.3522`, or `48,8566; 2,3522` with decimal commas.
final _plain = RegExp('^($_number)\\s*(?:[;,\\s])\\s*($_number)\$');

/// Reads a Google Maps link or a pair of coordinates, and returns the point it designates,
/// or null when the text is neither or when the point does not exist (latitude beyond 90°, longitude beyond 180°).
///
/// Shortened links (maps.app.goo.gl) carry no coordinates and cannot be read without a network call.
MapLocation? parseMapLocation(String input) {
  final text = input.trim();
  if (text.isEmpty) return null;

  final decoded = _decode(text);
  final match = _pin.firstMatch(decoded) ?? _viewport.firstMatch(decoded) ?? _queryPair.firstMatch(decoded) ?? _plain.firstMatch(text);
  if (match == null) return null;

  final latitude = _toDouble(match.group(1)!);
  final longitude = _toDouble(match.group(2)!);
  if (latitude.abs() > 90 || longitude.abs() > 180) return null;
  return (latitude: latitude, longitude: longitude);
}

/// The link with its percent-encoding decoded (`%2C%20` → `, `), or as typed when that encoding is broken (`?q=48%`).
String _decode(String text) {
  try {
    return Uri.decodeFull(text);
  } on ArgumentError {
    return text;
  } on FormatException {
    return text;
  }
}

double _toDouble(String value) => double.parse(value.replaceAll(',', '.'));
