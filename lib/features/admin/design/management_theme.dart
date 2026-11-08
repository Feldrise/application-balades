import 'package:flutter/material.dart';

/// Colours of the management area, direction D « Clair & vert ».
/// The identity green stays #006d41; the deep green carries the navigation and the page headers.
abstract final class ManagementColors {
  static const green = Color(0xff006d41);
  static const deepGreen = Color(0xff00341d);
  static const mint = Color(0xffdff2e7);
  static const lightGreen = Color(0xff9fe3bd);

  static const background = Color(0xfff4f7f5);
  static const surface = Colors.white;
  static const subtleSurface = Color(0xfff8faf9);
  static const border = Color(0xffe0e6e2);
  static const text = Color(0xff17201b);
  static const muted = Color(0xff637068);

  static const confirmed = Color(0xff0b6b3a);
  static const pending = Color(0xff8a5a00);
  static const waitingList = Color(0xff34557a);
  static const cancelled = Color(0xff9d2b1d);
  static const draft = Color(0xff6b6b6b);
}

/// Screen sizes of the management area: bottom bar on a phone, icon rail on a tablet, full sidebar on desktop.
abstract final class ManagementBreakpoints {
  static const double tablet = 600;
  static const double desktop = 1024;

  static bool isPhone(BuildContext context) => MediaQuery.sizeOf(context).width < tablet;

  static bool isDesktop(BuildContext context) => MediaQuery.sizeOf(context).width >= desktop;

  /// Horizontal padding of the page content.
  static double gutter(BuildContext context) => isDesktop(context) ? 28 : 16;
}

/// The theme of the management area, derived from the app theme: sober type scale (no huge section titles),
/// Lora for page titles only, Lato everywhere else, white panels on a light green-grey background.
ThemeData managementTheme(ThemeData base) {
  final text = base.textTheme;
  final body = text.bodyMedium ?? const TextStyle();
  final display = text.headlineSmall ?? const TextStyle();

  TextStyle lato(double size, FontWeight weight) => body.copyWith(fontSize: size, fontWeight: weight, height: 1.3, color: ManagementColors.text);
  TextStyle lora(double size) => display.copyWith(fontSize: size, fontWeight: FontWeight.w700, height: 1.25, color: ManagementColors.text);

  return base.copyWith(
    scaffoldBackgroundColor: ManagementColors.background,
    dividerColor: ManagementColors.border,
    dividerTheme: const DividerThemeData(color: ManagementColors.border, thickness: 1, space: 1),
    textTheme: text.copyWith(
      headlineLarge: lora(26),
      headlineMedium: lora(24),
      headlineSmall: lora(22),
      titleLarge: lato(18, FontWeight.w800),
      titleMedium: lato(15, FontWeight.w800),
      titleSmall: lato(14, FontWeight.w700),
      bodyLarge: lato(15, FontWeight.w400),
      bodyMedium: lato(14, FontWeight.w400),
      bodySmall: lato(12.5, FontWeight.w400).copyWith(color: ManagementColors.muted),
      labelLarge: lato(14, FontWeight.w700),
      labelMedium: lato(12.5, FontWeight.w700),
      labelSmall: lato(11, FontWeight.w800).copyWith(letterSpacing: 0.4, color: ManagementColors.muted),
    ),
    cardTheme: base.cardTheme.copyWith(
      color: ManagementColors.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: ManagementColors.border),
      ),
    ),
    chipTheme: base.chipTheme.copyWith(
      backgroundColor: ManagementColors.surface,
      selectedColor: ManagementColors.mint,
      side: const BorderSide(color: ManagementColors.border),
      labelStyle: lato(12.5, FontWeight.w400),
      secondaryLabelStyle: lato(12.5, FontWeight.w800).copyWith(color: ManagementColors.deepGreen),
      showCheckmark: false,
    ),
    bottomSheetTheme: base.bottomSheetTheme.copyWith(
      backgroundColor: ManagementColors.surface,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
    ),
  );
}
