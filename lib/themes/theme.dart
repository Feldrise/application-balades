import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff006d41),
      surfaceTint: Color(0xff006d41),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff5aba84),
      onPrimaryContainer: Color(0xff004729),
      secondary: Color(0xff436650),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffc2e9cd),
      onSecondaryContainer: Color(0xff476a54),
      tertiary: Color(0xff3f5ba7),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff8aa5f7),
      onTertiaryContainer: Color(0xff173883),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfff6fbf4),
      onSurface: Color(0xff181d19),
      onSurfaceVariant: Color(0xff3e4941),
      outline: Color(0xff6e7a70),
      outlineVariant: Color(0xffbecabf),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2c322d),
      inversePrimary: Color(0xff7adaa1),
      primaryFixed: Color(0xff95f7bc),
      onPrimaryFixed: Color(0xff002110),
      primaryFixedDim: Color(0xff7adaa1),
      onPrimaryFixedVariant: Color(0xff005230),
      secondaryFixed: Color(0xffc5ecd0),
      onSecondaryFixed: Color(0xff002110),
      secondaryFixedDim: Color(0xffa9d0b4),
      onSecondaryFixedVariant: Color(0xff2c4e39),
      tertiaryFixed: Color(0xffdbe1ff),
      onTertiaryFixed: Color(0xff00174a),
      tertiaryFixedDim: Color(0xffb3c5ff),
      onTertiaryFixedVariant: Color(0xff24428e),
      surfaceDim: Color(0xffd6dbd5),
      surfaceBright: Color(0xfff6fbf4),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff0f5ee),
      surfaceContainer: Color(0xffeaefe8),
      surfaceContainerHigh: Color(0xffe5eae3),
      surfaceContainerHighest: Color(0xffdfe4dd),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff003f24),
      surfaceTint: Color(0xff006d41),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff0d7d4d),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff1b3d29),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff52755e),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff0c317c),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff4e6ab7),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff6fbf4),
      onSurface: Color(0xff0d120f),
      onSurfaceVariant: Color(0xff2e3931),
      outline: Color(0xff4a554d),
      outlineVariant: Color(0xff647067),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2c322d),
      inversePrimary: Color(0xff7adaa1),
      primaryFixed: Color(0xff0d7d4d),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff00623a),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff52755e),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff3a5c46),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff4e6ab7),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff34519d),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc3c8c1),
      surfaceBright: Color(0xfff6fbf4),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff0f5ee),
      surfaceContainer: Color(0xffe5eae3),
      surfaceContainerHigh: Color(0xffd9ded8),
      surfaceContainerHighest: Color(0xffced3cc),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff00341d),
      surfaceTint: Color(0xff006d41),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff005532),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff103220),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff2e503b),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff00266e),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff274590),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff6fbf4),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff242f27),
      outlineVariant: Color(0xff414c43),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2c322d),
      inversePrimary: Color(0xff7adaa1),
      primaryFixed: Color(0xff005532),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff003b21),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff2e503b),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff173926),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff274590),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff052d79),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffb5bab4),
      surfaceBright: Color(0xfff6fbf4),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffedf2eb),
      surfaceContainer: Color(0xffdfe4dd),
      surfaceContainerHigh: Color(0xffd1d6cf),
      surfaceContainerHighest: Color(0xffc3c8c1),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff7adaa1),
      surfaceTint: Color(0xff7adaa1),
      onPrimary: Color(0xff003920),
      primaryContainer: Color(0xff5aba84),
      onPrimaryContainer: Color(0xff004729),
      secondary: Color(0xffa9d0b4),
      onSecondary: Color(0xff143724),
      secondaryContainer: Color(0xff2c4e39),
      onSecondaryContainer: Color(0xff98bea3),
      tertiary: Color(0xffb3c5ff),
      onTertiary: Color(0xff012a76),
      tertiaryContainer: Color(0xff8aa5f7),
      onTertiaryContainer: Color(0xff173883),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff0f1511),
      onSurface: Color(0xffdfe4dd),
      onSurfaceVariant: Color(0xffbecabf),
      outline: Color(0xff88948a),
      outlineVariant: Color(0xff3e4941),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdfe4dd),
      inversePrimary: Color(0xff006d41),
      primaryFixed: Color(0xff95f7bc),
      onPrimaryFixed: Color(0xff002110),
      primaryFixedDim: Color(0xff7adaa1),
      onPrimaryFixedVariant: Color(0xff005230),
      secondaryFixed: Color(0xffc5ecd0),
      onSecondaryFixed: Color(0xff002110),
      secondaryFixedDim: Color(0xffa9d0b4),
      onSecondaryFixedVariant: Color(0xff2c4e39),
      tertiaryFixed: Color(0xffdbe1ff),
      onTertiaryFixed: Color(0xff00174a),
      tertiaryFixedDim: Color(0xffb3c5ff),
      onTertiaryFixedVariant: Color(0xff24428e),
      surfaceDim: Color(0xff0f1511),
      surfaceBright: Color(0xff353a36),
      surfaceContainerLowest: Color(0xff0a0f0c),
      surfaceContainerLow: Color(0xff181d19),
      surfaceContainer: Color(0xff1c211d),
      surfaceContainerHigh: Color(0xff262b27),
      surfaceContainerHighest: Color(0xff313632),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff8ff0b6),
      surfaceTint: Color(0xff7adaa1),
      onPrimary: Color(0xff002c18),
      primaryContainer: Color(0xff5aba84),
      onPrimaryContainer: Color(0xff002311),
      secondary: Color(0xffbfe6ca),
      onSecondary: Color(0xff082c19),
      secondaryContainer: Color(0xff759980),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffd2dbff),
      onTertiary: Color(0xff002060),
      tertiaryContainer: Color(0xff8aa5f7),
      onTertiaryContainer: Color(0xff00194e),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff0f1511),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffd3dfd4),
      outline: Color(0xffa9b5aa),
      outlineVariant: Color(0xff889389),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdfe4dd),
      inversePrimary: Color(0xff005331),
      primaryFixed: Color(0xff95f7bc),
      onPrimaryFixed: Color(0xff001509),
      primaryFixedDim: Color(0xff7adaa1),
      onPrimaryFixedVariant: Color(0xff003f24),
      secondaryFixed: Color(0xffc5ecd0),
      onSecondaryFixed: Color(0xff001509),
      secondaryFixedDim: Color(0xffa9d0b4),
      onSecondaryFixedVariant: Color(0xff1b3d29),
      tertiaryFixed: Color(0xffdbe1ff),
      onTertiaryFixed: Color(0xff000e34),
      tertiaryFixedDim: Color(0xffb3c5ff),
      onTertiaryFixedVariant: Color(0xff0c317c),
      surfaceDim: Color(0xff0f1511),
      surfaceBright: Color(0xff404641),
      surfaceContainerLowest: Color(0xff040806),
      surfaceContainerLow: Color(0xff1a1f1b),
      surfaceContainer: Color(0xff242925),
      surfaceContainerHigh: Color(0xff2f342f),
      surfaceContainerHighest: Color(0xff3a3f3a),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffbdffd3),
      surfaceTint: Color(0xff7adaa1),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xff76d69d),
      onPrimaryContainer: Color(0xff000f05),
      secondary: Color(0xffd2fadd),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffa6ccb1),
      onSecondaryContainer: Color(0xff000f05),
      tertiary: Color(0xffedefff),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffaec1ff),
      onTertiaryContainer: Color(0xff000928),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff0f1511),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffe7f3e8),
      outlineVariant: Color(0xffbac6bb),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdfe4dd),
      inversePrimary: Color(0xff005331),
      primaryFixed: Color(0xff95f7bc),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xff7adaa1),
      onPrimaryFixedVariant: Color(0xff001509),
      secondaryFixed: Color(0xffc5ecd0),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffa9d0b4),
      onSecondaryFixedVariant: Color(0xff001509),
      tertiaryFixed: Color(0xffdbe1ff),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffb3c5ff),
      onTertiaryFixedVariant: Color(0xff000e34),
      surfaceDim: Color(0xff0f1511),
      surfaceBright: Color(0xff4c514c),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff1c211d),
      surfaceContainer: Color(0xff2c322d),
      surfaceContainerHigh: Color(0xff373d38),
      surfaceContainerHighest: Color(0xff434843),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(bodyColor: colorScheme.onSurface, displayColor: colorScheme.onSurface),
    scaffoldBackgroundColor: colorScheme.surfaceContainer,
    canvasColor: colorScheme.surface,

    cardTheme: CardThemeData(
      elevation: 30,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
        // side: BorderSide(color: colorScheme.outlineVariant, width: 1),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      fillColor: colorScheme.surface,
      filled: true,
      // floatingLabelBehavior: FloatingLabelBehavior.always,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(64.0),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(64.0),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(64.0)),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(64.0)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(64.0)),
      ),
    ),
  );

  List<ExtendedColor> get extendedColors => [];
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
  const ColorFamily({required this.color, required this.onColor, required this.colorContainer, required this.onColorContainer});

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
