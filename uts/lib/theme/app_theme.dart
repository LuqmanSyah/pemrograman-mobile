import 'package:flutter/material.dart';

abstract final class AppColors {
  static const primary = Color(0xFF2864E8);
  static const primarySoft = Color(0xFFEAF1FF);
  static const navy = Color(0xFF111827);
  static const background = Color(0xFFF6F8FC);
  static const text = Color(0xFF172033);
  static const muted = Color(0xFF71809A);
  static const border = Color(0xFFDCE4F0);
  static const success = Color(0xFF12A653);
  static const warningSoft = Color(0xFFFFF2C9);
  static const warning = Color(0xFFB45309);
}

abstract final class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      surface: Colors.white,
    ),
    fontFamily: 'Roboto',
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    ),
  );
}
