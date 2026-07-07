import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.height = 40, this.width});

  final double height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/logo.png',
      height: height,
      width: width,
      fit: BoxFit.contain,
      semanticLabel: 'Balade EcoLogique',
    );
  }
}
