import 'package:flutter/material.dart';

/// The page of a form: centred, about 800 px wide at most, its sections separated by a regular gap.
class FormLayout extends StatelessWidget {
  const FormLayout({super.key, required this.children});

  static const double maxWidth = 800;

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final gutter = MediaQuery.sizeOf(context).width < 600 ? 12.0 : 24.0;
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: EdgeInsets.fromLTRB(gutter, 16, gutter, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < children.length; i++) ...[if (i > 0) const SizedBox(height: 16), children[i]],
            ],
          ),
        ),
      ),
    );
  }
}
