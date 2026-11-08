import 'dart:async';
import 'dart:convert';

import 'package:balade/features/reservations/models/reservation/reservation.dart';
import 'package:balade/features/reservations/presence.dart';
import 'package:balade/features/reservations/reservations_service.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The roll call of a balade, usable with a poor network. Each change is recorded on the phone first, with its time,
/// then sent with the others in one batch as soon as possible: right after it, when the feuille de balade opens, and
/// again every [retryDelay] while the network is missing. Nothing is lost if the app restarts.
class PresenceSync extends ChangeNotifier {
  PresenceSync({required this.rambleId, required ReservationsService service, required String token, DateTime Function()? clock, this.retryDelay = const Duration(seconds: 20)})
    : _service = service,
      _token = token,
      _clock = clock ?? DateTime.now;

  final int rambleId;

  /// The wait before sending again the changes the network refused.
  final Duration retryDelay;

  final ReservationsService _service;
  final String _token;
  final DateTime Function() _clock;

  /// The changes not sent yet, by participant: only the latest one counts.
  final Map<int, PresenceChange> _pending = {};

  /// The presence recorded by the API in answer to the changes sent, newer than the one of the loaded participants.
  final Map<int, bool?> _recorded = {};

  Future<void>? _sending;
  bool _sendAgain = false;
  Timer? _retry;
  bool _disposed = false;

  String get _key => 'presence_changes_$rambleId';

  /// Reads the changes left on the phone, e.g. before the app restarted.
  Future<void> load() async {
    final preferences = await SharedPreferences.getInstance();
    final saved = preferences.getString(_key);
    if (saved == null) return;
    for (final json in jsonDecode(saved) as List) {
      final change = PresenceChange.fromJson(json as Map<String, Object?>);
      final current = _pending[change.participantId];
      if (current == null || current.markedAt.isBefore(change.markedAt)) _pending[change.participantId] = change;
    }
    _notify();
  }

  /// The presence shown for [participant]: the change waiting to be sent, else the latest one recorded by the API.
  bool? presenceOf(Participant participant) {
    final pending = _pending[participant.id];
    if (pending != null) return pending.present;
    if (_recorded.containsKey(participant.id)) return _recorded[participant.id];
    return participant.present;
  }

  /// The participants were loaded again from the API: for the changes already sent, they now tell the latest presence,
  /// maybe changed from another device since. The changes waiting still win.
  void participantsReloaded() {
    _recorded.clear();
    _notify();
  }

  /// The number of changes not sent yet.
  int get pendingCount => _pending.length;

  /// Marks [participant] present (true), absent (false) or unmarked (null): recorded on the phone, then sent.
  Future<void> mark(Participant participant, bool? present) async {
    _pending[participant.id] = PresenceChange(participantId: participant.id, present: present, markedAt: _clock().toUtc());
    _notify();
    await _save();
    await send();
  }

  /// Sends the changes waiting, in one batch. Without network they stay on the phone and are sent again later.
  Future<void> send() {
    if (_sending != null) {
      _sendAgain = true;
      return _sending!;
    }
    return _sending = _sendUntilDone().whenComplete(() => _sending = null);
  }

  Future<void> _sendUntilDone() async {
    _retry?.cancel();
    bool sent;
    do {
      _sendAgain = false;
      sent = await _sendBatch();
    } while (sent && _sendAgain && !_disposed);
    if (!sent && !_disposed) _retry = Timer(retryDelay, send);
  }

  /// Sends the changes waiting; false when they could not reach the API.
  Future<bool> _sendBatch() async {
    if (_pending.isEmpty) return true;
    final sent = _pending.values.toList();
    final List<PresenceOutcome> outcomes;
    try {
      outcomes = await _service.markPresence(rambleId, sent, token: _token);
    } catch (_) {
      return false;
    }

    // The feuille was closed meanwhile: another roll call may own the phone's queue now. Only the changes the API
    // answered leave it.
    if (_disposed) {
      await _forget([for (final outcome in outcomes) ...sent.where((c) => c.participantId == outcome.participantId)]);
      return true;
    }

    for (final outcome in outcomes) {
      final change = sent.where((c) => c.participantId == outcome.participantId).firstOrNull;
      // A change made while this batch was on its way is newer: it stays to be sent.
      if (change == null || _pending[outcome.participantId] != change) continue;
      // Every outcome takes the change out of the queue: applied, unchanged, outdated (a later change wins),
      // reservation_cancelled and unknown_participant (it can never be applied). The presence recorded by the API is shown.
      _pending.remove(outcome.participantId);
      _recorded[outcome.participantId] = outcome.present;
    }
    _notify();
    await _save();
    return true;
  }

  Future<void> _save() async {
    final preferences = await SharedPreferences.getInstance();
    if (_pending.isEmpty) {
      await preferences.remove(_key);
    } else {
      await preferences.setString(_key, jsonEncode([for (final change in _pending.values) change.toJson()]));
    }
  }

  /// Takes [answered] out of the changes left on the phone, keeping any other.
  Future<void> _forget(List<PresenceChange> answered) async {
    final preferences = await SharedPreferences.getInstance();
    final saved = preferences.getString(_key);
    if (saved == null) return;
    bool isAnswered(PresenceChange change) => answered.any((a) => a.participantId == change.participantId && a.markedAt == change.markedAt);
    final left = [
      for (final json in jsonDecode(saved) as List)
        if (!isAnswered(PresenceChange.fromJson(json as Map<String, Object?>))) json,
    ];
    if (left.isEmpty) {
      await preferences.remove(_key);
    } else {
      await preferences.setString(_key, jsonEncode(left));
    }
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _retry?.cancel();
    super.dispose();
  }
}
