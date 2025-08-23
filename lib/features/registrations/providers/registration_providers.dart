import 'package:balade/features/registrations/models/registration/registration.dart';
import 'package:balade/features/registrations/registrations_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider pour le service de registrations
final registrationsServiceProvider = Provider<RegistrationsService>((ref) {
  return RegistrationsService.instance;
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
  final service = ref.read(registrationsServiceProvider);
  // TODO: Get authorization token from auth provider
  const authorization = ''; // This should come from auth state
  return await service.fetchUserRegistrations(authorization: authorization);
});

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
