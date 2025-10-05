import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/features/authentication/data/models/authed_user/authed_user.dart';
import 'package:balade/features/ramble/models/ramble/ramble.dart';
import 'package:balade/features/ramble/rambles_service.dart';
import 'package:balade/features/registrations/models/registration/registration.dart';
import 'package:balade/features/registrations/registrations_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider pour le service de registrations
final registrationsServiceProvider = Provider<RegistrationsService>((ref) {
  return RegistrationsService.instance;
});

// Provider pour le service de rambles
final ramblesServiceProvider = Provider<RamblesService>((ref) {
  return RamblesService.instance;
});

// Provider pour récupérer les détails complets d'une ramble
final rambleDetailsProvider = FutureProvider.autoDispose.family<Ramble, int>((ref, rambleId) async {
  final authed = ref.watch(authenticationProvider);
  final service = ref.read(ramblesServiceProvider);

  return await service.fetchRamble(rambleId, authorization: authed?.token);
});

// Provider pour créer une inscription
final createRegistrationProvider = FutureProvider.autoDispose.family<Registration, CreateRegistrationRequest>((ref, request) async {
  final service = ref.read(registrationsServiceProvider);
  return await service.createRegistration(request);
});

// Provider pour récupérer une inscription par ID
final registrationProvider = FutureProvider.autoDispose.family<Registration, int>((ref, id) async {
  final service = ref.read(registrationsServiceProvider);
  return await service.fetchRegistration(id);
});

// Provider pour récupérer les inscriptions de l'utilisateur
final userRegistrationsProvider = FutureProvider.autoDispose<List<Registration>>((ref) async {
  final authed = ref.watch(authenticationProvider);
  final service = ref.read(registrationsServiceProvider);

  if (authed == null) {
    throw Exception('NOT_AUTHENTICATED');
  }

  return await service.fetchUserRegistrations(authorization: authed.token);
});

// Provider pour confirmer une inscription
final confirmRegistrationProvider = FutureProvider.autoDispose.family<Registration, int>((ref, registrationId) async {
  final authed = ref.watch(authenticationProvider);
  final service = ref.read(registrationsServiceProvider);

  if (authed == null) {
    throw Exception('NOT_AUTHENTICATED');
  }

  return await service.confirmRegistration(registrationId, true, authorization: 'Bearer ${authed.token}');
});

// Provider pour annuler une inscription
final cancelRegistrationProvider = FutureProvider.autoDispose.family<Registration, CancelRegistrationParams>((ref, params) async {
  final service = ref.read(registrationsServiceProvider);
  return await service.cancelRegistration(params.id, reason: params.reason);
});

// Classe pour les paramètres d'annulation
class CancelRegistrationParams {
  final int id;
  final String? reason;

  const CancelRegistrationParams({required this.id, this.reason});
}

// Provider pour gérer les actions sur les inscriptions
final registrationActionsProvider = StateNotifierProvider.autoDispose<RegistrationActionsNotifier, RegistrationActionsState>((ref) {
  return RegistrationActionsNotifier(ref.read(registrationsServiceProvider), ref.read(authenticationProvider));
});

// État des actions d'inscription
class RegistrationActionsState {
  final bool isLoading;
  final String? error;
  final String? successMessage;

  const RegistrationActionsState({this.isLoading = false, this.error, this.successMessage});

  RegistrationActionsState copyWith({bool? isLoading, String? error, String? successMessage}) {
    return RegistrationActionsState(isLoading: isLoading ?? this.isLoading, error: error, successMessage: successMessage);
  }
}

// Notifier pour les actions d'inscription
class RegistrationActionsNotifier extends StateNotifier<RegistrationActionsState> {
  final RegistrationsService _service;
  final AuthedUser? _auth;

  RegistrationActionsNotifier(this._service, this._auth) : super(const RegistrationActionsState());

  Future<bool> confirmRegistration(int registrationId) async {
    if (_auth == null) {
      state = state.copyWith(error: 'Vous devez être connecté pour confirmer votre inscription');
      return false;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      await _service.confirmRegistration(registrationId, true, authorization: 'Bearer ${_auth.token}');

      state = state.copyWith(isLoading: false, successMessage: 'Votre participation a été confirmée !');
      return true;
    } catch (error) {
      state = state.copyWith(isLoading: false, error: 'Erreur lors de la confirmation: ${error.toString()}');
      return false;
    }
  }

  Future<bool> cancelRegistration(int registrationId, {String? reason}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _service.cancelRegistration(registrationId, reason: reason);

      state = state.copyWith(isLoading: false, successMessage: 'Votre inscription a été annulée.');
      return true;
    } catch (error) {
      state = state.copyWith(isLoading: false, error: 'Erreur lors de l\'annulation: ${error.toString()}');
      return false;
    }
  }

  void clearMessages() {
    state = state.copyWith(error: null, successMessage: null);
  }
}

// Provider pour gérer l'état du formulaire d'inscription
final registrationFormProvider = StateNotifierProvider.autoDispose<RegistrationFormNotifier, RegistrationFormState>((ref) {
  return RegistrationFormNotifier(ref.read(registrationsServiceProvider));
});

// État du formulaire d'inscription
class RegistrationFormState {
  final List<RegistrationParticipant> participants;
  final bool isLoading;
  final String? error;
  final Registration? result;

  const RegistrationFormState({this.participants = const [], this.isLoading = false, this.error, this.result});

  RegistrationFormState copyWith({List<RegistrationParticipant>? participants, bool? isLoading, String? error, Registration? result}) {
    return RegistrationFormState(participants: participants ?? this.participants, isLoading: isLoading ?? this.isLoading, error: error, result: result ?? this.result);
  }
}

class RegistrationFormNotifier extends StateNotifier<RegistrationFormState> {
  final RegistrationsService _service;

  RegistrationFormNotifier(this._service) : super(const RegistrationFormState());

  void addParticipant(RegistrationParticipant participant) {
    if (state.participants.length < 10) {
      state = state.copyWith(participants: [...state.participants, participant], error: null);
    }
  }

  void removeParticipant(int index) {
    if (index >= 0 && index < state.participants.length) {
      final updatedParticipants = List<RegistrationParticipant>.from(state.participants);
      updatedParticipants.removeAt(index);
      state = state.copyWith(participants: updatedParticipants, error: null);
    }
  }

  void updateParticipant(int index, RegistrationParticipant participant) {
    if (index >= 0 && index < state.participants.length) {
      final updatedParticipants = List<RegistrationParticipant>.from(state.participants);
      updatedParticipants[index] = participant;
      state = state.copyWith(participants: updatedParticipants, error: null);
    }
  }

  void clearParticipants() {
    state = state.copyWith(participants: [], error: null, result: null);
  }

  Future<void> submitRegistration(int rambleId) async {
    if (state.participants.isEmpty) {
      state = state.copyWith(error: 'Au moins un participant est requis');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final request = CreateRegistrationRequest(
        rambleId: rambleId,
        participants: state.participants,
        primaryEmail: state.participants.isNotEmpty ? state.participants.first.email : null,
      );

      final result = await _service.createRegistration(request);
      state = state.copyWith(isLoading: false, result: result);
    } catch (error) {
      state = state.copyWith(isLoading: false, error: error.toString());
    }
  }

  void reset() {
    state = const RegistrationFormState();
  }
}
