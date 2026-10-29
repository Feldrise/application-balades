enum PaymentStatus {
  pending,
  succeeded,
  failed,
  cancelled,
  refunded;

  /// The status the API gives to a payment, null when it is not one we know.
  static PaymentStatus? tryParse(String value) {
    for (final status in values) {
      if (status.name == value) return status;
    }
    return null;
  }

  String get label {
    switch (this) {
      case PaymentStatus.pending:
        return 'En attente';
      case PaymentStatus.succeeded:
        return 'Payé';
      case PaymentStatus.failed:
        return 'Échec';
      case PaymentStatus.cancelled:
        return 'Annulé';
      case PaymentStatus.refunded:
        return 'Remboursé';
    }
  }
}
