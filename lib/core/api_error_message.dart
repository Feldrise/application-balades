/// Extracts a user-friendly message from API error responses.
String parseApiErrorMessage(Object error) {
  final message = error.toString();

  if (message.contains('403')) {
    if (message.contains('ramble_id is required')) {
      return 'Vous devez sélectionner une balade pour afficher les inscriptions.';
    }
    if (message.contains('guide profile not linked')) {
      return 'Votre compte n\'est pas lié à un profil guide.';
    }
    if (message.contains('insufficient permissions')) {
      return 'Permissions insuffisantes pour cette action.';
    }
    return 'Accès refusé.';
  }

  if (message.contains('401')) {
    return 'Session expirée. Veuillez vous reconnecter.';
  }

  if (message.contains('404')) {
    return 'Ressource introuvable.';
  }

  return message.replaceFirst('Exception: ', '');
}
