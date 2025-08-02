import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff076e00),
      surfaceTint: Color(0xff076e00),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff12bc00),
      onPrimaryContainer: Color(0xff034300),
      secondary: Color(0xff1f6d14),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffa4f78d),
      onSecondaryContainer: Color(0xff27731b),
      tertiary: Color(0xff00687a),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff00b1cf),
      onTertiaryContainer: Color(0xff003e4a),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfff3fde9),
      onSurface: Color(0xff161e12),
      onSurfaceVariant: Color(0xff3d4a38),
      outline: Color(0xff6d7b66),
      outlineVariant: Color(0xffbccbb2),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2a3326),
      inversePrimary: Color(0xff4ce337),
      primaryFixed: Color(0xff78ff5f),
      onPrimaryFixed: Color(0xff012200),
      primaryFixedDim: Color(0xff4ce337),
      onPrimaryFixedVariant: Color(0xff045300),
      secondaryFixed: Color(0xffa4f78d),
      onSecondaryFixed: Color(0xff012200),
      secondaryFixedDim: Color(0xff89da74),
      onSecondaryFixedVariant: Color(0xff045300),
      tertiaryFixed: Color(0xffacecff),
      onTertiaryFixed: Color(0xff001f26),
      tertiaryFixedDim: Color(0xff50d7f6),
      onTertiaryFixedVariant: Color(0xff004e5c),
      surfaceDim: Color(0xffd3ddcb),
      surfaceBright: Color(0xfff3fde9),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffedf7e4),
      surfaceContainer: Color(0xffe7f1de),
      surfaceContainerHigh: Color(0xffe2ebd9),
      surfaceContainerHighest: Color(0xffdce6d3),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff034000),
      surfaceTint: Color(0xff076e00),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff0a7f00),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff034000),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff307c23),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff003c48),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff00788d),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff3fde9),
      onSurface: Color(0xff0b1309),
      onSurfaceVariant: Color(0xff2d3a28),
      outline: Color(0xff495643),
      outlineVariant: Color(0xff63715c),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2a3326),
      inversePrimary: Color(0xff4ce337),
      primaryFixed: Color(0xff0a7f00),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff066300),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff307c23),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff136309),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff00788d),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff005d6e),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc0cab8),
      surfaceBright: Color(0xfff3fde9),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffedf7e4),
      surfaceContainer: Color(0xffe2ebd9),
      surfaceContainerHigh: Color(0xffd6e0ce),
      surfaceContainerHighest: Color(0xffcbd5c3),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff023500),
      surfaceTint: Color(0xff076e00),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff045600),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff023500),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff045600),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff00313b),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff00515f),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff3fde9),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff232f1e),
      outlineVariant: Color(0xff404d3a),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2a3326),
      inversePrimary: Color(0xff4ce337),
      primaryFixed: Color(0xff045600),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff023c00),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff045600),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff023c00),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff00515f),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff003843),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffb2bcaa),
      surfaceBright: Color(0xfff3fde9),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffeaf4e1),
      surfaceContainer: Color(0xffdce6d3),
      surfaceContainerHigh: Color(0xffced8c5),
      surfaceContainerHighest: Color(0xffc0cab8),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff4ce337),
      surfaceTint: Color(0xff4ce337),
      onPrimary: Color(0xff023900),
      primaryContainer: Color(0xff12bc00),
      onPrimaryContainer: Color(0xff034300),
      secondary: Color(0xff89da74),
      onSecondary: Color(0xff023900),
      secondaryContainer: Color(0xff065b00),
      onSecondaryContainer: Color(0xff82d26e),
      tertiary: Color(0xff50d7f6),
      onTertiary: Color(0xff003640),
      tertiaryContainer: Color(0xff00b1cf),
      onTertiaryContainer: Color(0xff003e4a),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff0d150b),
      onSurface: Color(0xffdce6d3),
      onSurfaceVariant: Color(0xffbccbb2),
      outline: Color(0xff86957f),
      outlineVariant: Color(0xff3d4a38),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdce6d3),
      inversePrimary: Color(0xff076e00),
      primaryFixed: Color(0xff78ff5f),
      onPrimaryFixed: Color(0xff012200),
      primaryFixedDim: Color(0xff4ce337),
      onPrimaryFixedVariant: Color(0xff045300),
      secondaryFixed: Color(0xffa4f78d),
      onSecondaryFixed: Color(0xff012200),
      secondaryFixedDim: Color(0xff89da74),
      onSecondaryFixedVariant: Color(0xff045300),
      tertiaryFixed: Color(0xffacecff),
      onTertiaryFixed: Color(0xff001f26),
      tertiaryFixedDim: Color(0xff50d7f6),
      onTertiaryFixedVariant: Color(0xff004e5c),
      surfaceDim: Color(0xff0d150b),
      surfaceBright: Color(0xff333c2f),
      surfaceContainerLowest: Color(0xff081006),
      surfaceContainerLow: Color(0xff161e12),
      surfaceContainer: Color(0xff1a2216),
      surfaceContainerHigh: Color(0xff242c20),
      surfaceContainerHighest: Color(0xff2e372a),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff64fa4c),
      surfaceTint: Color(0xff4ce337),
      onPrimary: Color(0xff012d00),
      primaryContainer: Color(0xff12bc00),
      onPrimaryContainer: Color(0xff011c00),
      secondary: Color(0xff9ef088),
      onSecondary: Color(0xff012d00),
      secondaryContainer: Color(0xff55a244),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xff97e8ff),
      onTertiary: Color(0xff002a33),
      tertiaryContainer: Color(0xff00b1cf),
      onTertiaryContainer: Color(0xff00191f),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff0d150b),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffd2e1c8),
      outline: Color(0xffa7b69f),
      outlineVariant: Color(0xff86957e),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdce6d3),
      inversePrimary: Color(0xff045500),
      primaryFixed: Color(0xff78ff5f),
      onPrimaryFixed: Color(0xff001600),
      primaryFixedDim: Color(0xff4ce337),
      onPrimaryFixedVariant: Color(0xff034000),
      secondaryFixed: Color(0xffa4f78d),
      onSecondaryFixed: Color(0xff001600),
      secondaryFixedDim: Color(0xff89da74),
      onSecondaryFixedVariant: Color(0xff034000),
      tertiaryFixed: Color(0xffacecff),
      onTertiaryFixed: Color(0xff001419),
      tertiaryFixedDim: Color(0xff50d7f6),
      onTertiaryFixedVariant: Color(0xff003c48),
      surfaceDim: Color(0xff0d150b),
      surfaceBright: Color(0xff3e473a),
      surfaceContainerLowest: Color(0xff030902),
      surfaceContainerLow: Color(0xff182014),
      surfaceContainer: Color(0xff222a1e),
      surfaceContainerHigh: Color(0xff2c3528),
      surfaceContainerHighest: Color(0xff374033),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffc7ffb4),
      surfaceTint: Color(0xff4ce337),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xff47df32),
      onPrimaryContainer: Color(0xff000f00),
      secondary: Color(0xffc7ffb4),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xff86d671),
      onSecondaryContainer: Color(0xff000f00),
      tertiary: Color(0xffd6f5ff),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xff4ad3f2),
      onTertiaryContainer: Color(0xff000d12),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff0d150b),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffe5f5db),
      outlineVariant: Color(0xffb8c7af),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdce6d3),
      inversePrimary: Color(0xff045500),
      primaryFixed: Color(0xff78ff5f),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xff4ce337),
      onPrimaryFixedVariant: Color(0xff001600),
      secondaryFixed: Color(0xffa4f78d),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xff89da74),
      onSecondaryFixedVariant: Color(0xff001600),
      tertiaryFixed: Color(0xffacecff),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xff50d7f6),
      onTertiaryFixedVariant: Color(0xff001419),
      surfaceDim: Color(0xff0d150b),
      surfaceBright: Color(0xff4a5345),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff1a2216),
      surfaceContainer: Color(0xff2a3326),
      surfaceContainerHigh: Color(0xff353e31),
      surfaceContainerHighest: Color(0xff40493c),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
     useMaterial3: true,
     brightness: colorScheme.brightness,
     colorScheme: colorScheme,
     textTheme: textTheme.apply(
       bodyColor: colorScheme.onSurface,
       displayColor: colorScheme.onSurface,
     ),
     scaffoldBackgroundColor: colorScheme.background,
     canvasColor: colorScheme.surface,
  );


  List<ExtendedColor> get extendedColors => [
  ];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
