import 'package:flutter/material.dart';

/// Warna & tipografi diambil dari file Figma "Reepo".
class AppColors {
  static const red = Color(0xFFFF0202);
  static const redGradientTop = Color(0xFFFB2222);
  static const offWhite = Color(0xFFFFFCFC);
  static const borderWhite = Color(0xFFFFF5F5);
  static const textBrown = Color(0xFF574646);
  static const textDark = Color(0xFF111111);
  static const countryCode = Color(0xFF544D4D);
  static const placeholder = Color(0xFFB7AFAF);
  static const sheetHeader = Color(0xFFF1E8E8);
  static const facebook = Color(0xFF3B5998);
  static const muted = Color(0xFF9F9999);
}

class AppFonts {
  static const sans = 'SourceSans';
  static const brand = 'Audiowide';
}

ThemeData buildTheme() {
  return ThemeData(
    useMaterial3: true,
    fontFamily: AppFonts.sans,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.red, primary: AppColors.red),
    scaffoldBackgroundColor: Colors.white,
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
  );
}
