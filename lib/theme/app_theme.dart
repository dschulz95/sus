import 'package:flutter/material.dart';

/// Central theme for the app.
///
/// A dark, "late-night party game" look with a violet seed and a cyan accent.
class AppTheme {
  AppTheme._();

  static const Color seed = Color(0xFF8B5CF6);
  static const Color background = Color(0xFF121019);
  static const Color card = Color(0xFF1E1B2A);
  static const Color cardSelected = Color(0xFF35294F);
  static const Color accent = Color(0xFF22D3EE);
  static const Color imposter = Color(0xFFFB7185);

  static ThemeData get dark {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.dark,
    ).copyWith(
      surface: background,
      onSurface: Colors.white,
      secondary: accent,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
