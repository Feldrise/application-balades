import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 300), child: Image.asset("assets/logo.png")),
      ),
    );
  }
}
