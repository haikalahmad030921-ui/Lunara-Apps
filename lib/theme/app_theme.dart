import 'package:flutter/material.dart';

class AppColors {
  static const Color surface = Color(0xFFFBF9F5);
  static const Color surfaceDim = Color(0xFFDBDAD6);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF5F3EF);
  static const Color surfaceContainer = Color(0xFFEFEEEA);
  static const Color surfaceContainerHigh = Color(0xFFEAE8E4);
  static const Color surfaceContainerHighest = Color(0xFFE4E2DE);
  static const Color surfaceCard = Color(0xFFF4EFE6);

  static const Color primary = Color(0xFF012532);
  static const Color primaryContainer = Color(0xFF1B3B48);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFF85A5B4);
  static const Color primaryFixed = Color(0xFFC7E7F8);

  static const Color secondary = Color(0xFF9A442D);
  static const Color coralSunset = Color(0xFFE07A5F);
  static const Color secondaryContainer = Color(0xFFFC9174);
  static const Color secondaryFixed = Color(0xFFFFDBD2);
  static const Color onSecondary = Color(0xFFFFFFFF);

  static const Color tertiary = Color(0xFF262214);
  static const Color tertiaryFixed = Color(0xFFECE2CC);
  static const Color warmSand = Color(0xFFE8DEC8);

  static const Color onSurface = Color(0xFF1B1C1A);
  static const Color onSurfaceVariant = Color(0xFF42484B);
  static const Color outline = Color(0xFF72787B);
  static const Color outlineVariant = Color(0xFFC2C7CB);
  static const Color error = Color(0xFFBA1A1A);
}

class AppTextStyles {
  static const String _serifFont = 'Playfair Display';
  static const String _sansFont = 'Plus Jakarta Sans';

  static TextStyle displayLg({Color color = AppColors.onSurface}) => TextStyle(
        fontFamily: _serifFont,
        fontFamilyFallback: const ['Georgia', 'serif'],
        fontSize: 36,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: -0.5,
        color: color,
      );

  static TextStyle headlineLg({Color color = AppColors.onSurface}) => TextStyle(
        fontFamily: _serifFont,
        fontFamilyFallback: const ['Georgia', 'serif'],
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.25,
        color: color,
      );

  static TextStyle headlineMd({Color color = AppColors.onSurface}) => TextStyle(
        fontFamily: _serifFont,
        fontFamilyFallback: const ['Georgia', 'serif'],
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.28,
        color: color,
      );

  static TextStyle headlineSm({Color color = AppColors.onSurface}) => TextStyle(
        fontFamily: _serifFont,
        fontFamilyFallback: const ['Georgia', 'serif'],
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: color,
      );

  static TextStyle titleLg({Color color = AppColors.onSurface}) => TextStyle(
        fontFamily: _sansFont,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: color,
      );

  static TextStyle titleMd({Color color = AppColors.onSurface}) => TextStyle(
        fontFamily: _sansFont,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.35,
        color: color,
      );

  static TextStyle titleSm({Color color = AppColors.onSurface}) => TextStyle(
        fontFamily: _sansFont,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: color,
      );

  static TextStyle bodyLg({Color color = AppColors.onSurfaceVariant}) =>
      TextStyle(
        fontFamily: _sansFont,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.55,
        color: color,
      );

  static TextStyle bodyMd({Color color = AppColors.onSurfaceVariant}) =>
      TextStyle(
        fontFamily: _sansFont,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: color,
      );

  static TextStyle bodySm({Color color = AppColors.onSurfaceVariant}) =>
      TextStyle(
        fontFamily: _sansFont,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.45,
        color: color,
      );

  static TextStyle labelLg({Color color = AppColors.onSurface}) => TextStyle(
        fontFamily: _sansFont,
        fontSize: 13,
        fontWeight: FontWeight.w600,
        height: 1.35,
        letterSpacing: 0.4,
        color: color,
      );

  static TextStyle labelMd({Color color = AppColors.onSurfaceVariant}) =>
      TextStyle(
        fontFamily: _sansFont,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        height: 1.35,
        letterSpacing: 0.7,
        color: color,
      );

  static TextStyle labelSm({Color color = AppColors.onSurfaceVariant}) =>
      TextStyle(
        fontFamily: _sansFont,
        fontSize: 10,
        fontWeight: FontWeight.w700,
        height: 1.3,
        letterSpacing: 0.9,
        color: color,
      );
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.surface,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondaryContainer,
        tertiary: AppColors.tertiary,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        outline: AppColors.outline,
        outlineVariant: AppColors.outlineVariant,
        error: AppColors.error,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.primary,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
