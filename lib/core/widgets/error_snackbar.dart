import 'package:flutter/material.dart';

class ErrorSnackbar {
  const ErrorSnackbar({required this.message});

  final String message;

  static show(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.error,
        content: Text(message, style: TextStyle(color: Theme.of(context).colorScheme.onError)),
      ),
    );
  }
}
