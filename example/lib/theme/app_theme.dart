import 'package:flutter/material.dart';

/// Brand palette + light/dark [ThemeData] builders for the example app.
class AppTheme {
  AppTheme._();

  /// Refined deep crimson used as the Material 3 seed color.
  static const Color seed = Color(0xFFC62828);

  /// Soft crimson surface tint used on the themed-search screen.
  static const Color softCrimsonLight = Color(0xFFFFF5F5);
  static const Color softCrimsonDark = Color(0xFF2A1A1A);

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(seedColor: seed);
    return _build(
      scheme: scheme,
      scaffold: const Color(0xFFFAFAFA),
      surface: Colors.white,
      onSurface: const Color(0xFF1F2937),
    );
  }

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.dark);
    return _build(
      scheme: scheme,
      scaffold: const Color(0xFF0F1115),
      surface: const Color(0xFF1A1D23),
      onSurface: const Color(0xFFE5E7EB),
    );
  }

  static ThemeData _build({
    required ColorScheme scheme,
    required Color scaffold,
    required Color surface,
    required Color onSurface,
  }) {
    final patched = scheme.copyWith(surface: surface, onSurface: onSurface);
    return ThemeData(
      useMaterial3: true,
      colorScheme: patched,
      scaffoldBackgroundColor: scaffold,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: patched.onSurface,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: patched.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: patched.outlineVariant),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        bodySmall: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
      ),
    );
  }
}
