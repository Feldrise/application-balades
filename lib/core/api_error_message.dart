import 'dart:convert';

/// Extracts a user-friendly message from API error responses.
String parseApiErrorMessage(Object error) {
  final message = error.toString();

  final jsonError = _extractJsonErrorField(message);
  if (jsonError != null) {
    return _translateApiError(jsonError);
  }

  if (message.contains('403')) {
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

String? _extractJsonErrorField(String message) {
  final jsonStart = message.indexOf('{');
  if (jsonStart == -1) return null;

  try {
    final decoded = jsonDecode(message.substring(jsonStart));
    if (decoded is Map) {
      final error = decoded['error'] ?? decoded['message'];
      if (error is String && error.isNotEmpty) return error;
    }
  } catch (_) {
    return null;
  }
  return null;
}

String _translateApiError(String error) {
  if (error.contains('cannot register for an unpublished ramble')) {
    return 'Les inscriptions ne sont pas ouvertes pour cette balade (brouillon ou publication planifiée).';
  }
  if (error.contains('failed to save cover image')) {
    return 'Impossible d\'enregistrer l\'image de couverture. Vérifiez le format et la taille du fichier.';
  }
  if (error.contains('failed to save avatar') || error.contains('avatar')) {
    return 'Impossible d\'enregistrer la photo de profil. Vérifiez le format et la taille du fichier.';
  }
  return error;
}
