import 'package:flutter/material.dart';

class DialogHeader extends StatelessWidget {
  const DialogHeader({
    super.key,
    required this.title,
    required this.isClosable,
    this.onClose,
  });

  final String? title;
  final bool isClosable;

  final Function()? onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (title != null) ...[
            // The title
            Expanded(
              child: Text(title!, style: Theme.of(context).textTheme.headlineMedium),
            ),
            const SizedBox(
              width: 8.0,
            ),
          ] else
            const Expanded(
              child: SizedBox(
                width: 8.0,
              ),
            ),

          // The closing button
          if (isClosable)
            IconButton(
              icon: const Icon(Icons.close),
              iconSize: 22,
              color: Theme.of(context).colorScheme.onSurface,
              onPressed: () {
                if (onClose != null) {
                  onClose!();
                } else {
                  Navigator.of(context).pop();
                }
              },
            )
        ],
      ),
    );
  }
}
