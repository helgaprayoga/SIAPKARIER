import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_spacing.dart';

/// Tema global SIAPKARIER.
class AppTheme {
  AppTheme._();

  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'DM Sans',
      colorScheme: const ColorScheme.light(
        primary: AppColors.teal,
        onPrimary: Colors.white,
        secondary: AppColors.gold,
        onSecondary: AppColors.navyDeep,
        surface: AppColors.surface,
        onSurface: AppColors.ink,
        error: AppColors.danger,
      ),
    );

    final textTheme = base.textTheme
        .apply(
          fontFamily: 'DM Sans',
          bodyColor: AppColors.ink,
          displayColor: AppColors.navyDeep,
        )
        .copyWith(
          displayLarge: const TextStyle(
            fontFamily: 'Manrope',
            fontSize: 29,
            fontWeight: FontWeight.w800,
            color: AppColors.navyDeep,
            letterSpacing: -0.6,
            height: 1.18,
          ),
          headlineLarge: const TextStyle(
            fontFamily: 'Manrope',
            fontSize: 27,
            fontWeight: FontWeight.w800,
            color: AppColors.navyDeep,
            letterSpacing: -0.6,
            height: 1.2,
          ),
          headlineMedium: const TextStyle(
            fontFamily: 'Manrope',
            fontSize: 23,
            fontWeight: FontWeight.w700,
            color: AppColors.navyDeep,
            letterSpacing: -0.4,
            height: 1.3,
          ),
          headlineSmall: const TextStyle(
            fontFamily: 'Manrope',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.navyDeep,
            letterSpacing: -0.3,
            height: 1.3,
          ),
          titleLarge: const TextStyle(
            fontFamily: 'Manrope',
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.navyDeep,
          ),
          titleMedium: const TextStyle(
            fontFamily: 'Manrope',
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.navyDeep,
          ),
          bodyLarge: const TextStyle(
            fontSize: 15,
            height: 1.55,
            color: AppColors.ink,
          ),
          bodyMedium: const TextStyle(
            fontSize: 13,
            height: 1.55,
            color: AppColors.ink,
          ),
          bodySmall: const TextStyle(
            fontSize: 11,
            height: 1.45,
            color: AppColors.muted,
          ),
          labelLarge: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        );

    return base.copyWith(
      textTheme: textTheme,
      dividerColor: AppColors.line,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.navyDeep,
        elevation: 0,
        centerTitle: false,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFFBFCFC),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: AppColors.teal, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: AppColors.danger, width: 1.4),
        ),
        labelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.navy,
        ),
        hintStyle: const TextStyle(
          fontSize: 13,
          color: AppColors.muted,
          fontWeight: FontWeight.w400,
        ),
        errorStyle: const TextStyle(
          fontSize: 11,
          color: AppColors.danger,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.navy,
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusLg),
          ),
        ),
      ),
    );
  }
}
