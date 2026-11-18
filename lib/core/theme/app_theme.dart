import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static const Color darkBg = Color(0xFF020617);
  static const Color darkSurface = Color(0xFF0F172A);
  static const Color darkCard = Color(0xFF1E293B);
  static const Color darkPrimary = Color(0xFF2DD4BF);
  static const Color darkSecondary = Color(0xFFFBBF24);
  static const Color darkError = Color(0xFFF87171);

  static const Color lightBg = Color(0xFFF1F5F9);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFF8FAFC);
  static const Color lightPrimary = Color(0xFF0F766E);
  static const Color lightSecondary = Color(0xFFD97706);
  static const Color lightError = Color(0xFFDC2626);

  static ThemeData light() {
    const colorScheme = ColorScheme.light(
      primary: lightPrimary,
      onPrimary: Colors.white,
      primaryContainer: Color(0xFFCCFBF1),
      onPrimaryContainer: Color(0xFF042F2E),
      secondary: lightSecondary,
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFFFEF3C7),
      onSecondaryContainer: Color(0xFF78350F),
      surface: lightSurface,
      onSurface: Color(0xFF0F172A),
      error: lightError,
      onError: Colors.white,
      errorContainer: Color(0xFFFEE2E2),
      onErrorContainer: Color(0xFF7F1D1D),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: lightBg,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xFF0F172A),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: lightSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: const Color(0xFF0F172A).withValues(alpha: 0.08),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightSurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: const Color(0xFF0F172A).withValues(alpha: 0.12),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: const Color(0xFF0F172A).withValues(alpha: 0.12),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: lightPrimary,
            width: 2,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: const Color(0xFF0F172A).withValues(alpha: 0.06),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  static ThemeData dark() {
    const colorScheme = ColorScheme.dark(
      primary: darkPrimary,
      onPrimary: Color(0xFF042F2E),
      primaryContainer: Color(0xFF134E4A),
      onPrimaryContainer: Color(0xFFCCFBF1),
      secondary: darkSecondary,
      onSecondary: Color(0xFF1F2937),
      secondaryContainer: Color(0xFF78350F),
      onSecondaryContainer: Color(0xFFFEF3C7),
      surface: darkSurface,
      onSurface: Color(0xFFE2E8F0),
      error: darkError,
      onError: Color(0xFF450A0A),
      errorContainer: Color(0xFF450A0A),
      onErrorContainer: Color(0xFFFECACA),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: darkBg,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xFFE2E8F0),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: darkPrimary.withValues(alpha: 0.16),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF090F20),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.white.withValues(alpha: 0.12),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.white.withValues(alpha: 0.12),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: darkPrimary,
            width: 2,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.white.withValues(alpha: 0.05),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}
