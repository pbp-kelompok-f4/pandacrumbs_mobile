import 'package:flutter/material.dart';

abstract final class PandaColors {
  static const cream = Color(0xFFFAF6EE);
  static const paper = Color(0xFFFFFEFB);
  static const ink = Color(0xFF2D1F1F);
  static const terracotta = Color(0xFFD97450);
  static const terracottaDark = Color(0xFFC75E3D);
  static const olive = Color(0xFF6E7E55);
  static const oliveDark = Color(0xFF38432D);
  static const sage = Color(0xFFDCE6C9);
  static const sagePale = Color(0xFFEEF1E6);
  static const dustyPink = Color(0xFFDFB2BC);
  static const warmCard = Color(0xFFFFF7F2);
  static const muted = Color(0xFF81786F);
  static const line = Color(0xFFE4E1D7);
}

ThemeData buildPandaTheme() {
  final colorScheme =
      ColorScheme.fromSeed(
        seedColor: PandaColors.terracotta,
        brightness: Brightness.light,
      ).copyWith(
        primary: PandaColors.terracotta,
        secondary: PandaColors.olive,
        surface: PandaColors.paper,
        onSurface: PandaColors.ink,
      );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: PandaColors.paper,
    fontFamily: 'Inter',
    appBarTheme: const AppBarTheme(
      backgroundColor: PandaColors.paper,
      foregroundColor: PandaColors.ink,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontFamily: 'Inter', color: PandaColors.ink),
      bodyMedium: TextStyle(fontFamily: 'Inter', color: PandaColors.ink),
      bodySmall: TextStyle(fontFamily: 'Inter', color: PandaColors.muted),
      labelLarge: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600),
    ),
  );
}
