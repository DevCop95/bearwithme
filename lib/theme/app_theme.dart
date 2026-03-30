import 'package:flutter/material.dart';

class AppTheme {
  // Colores más vibrantes pero aún suaves (estilo premium)
  static const Color primaryBlue = Color(0xFF00B4D8); // Cyan vibrante
  static const Color primaryGreen = Color(0xFF48CAE4); // Azul aqua
  static const Color accentPurple = Color(0xFF9D4EDD); // Púrpura para introspección
  static const Color backgroundGray = Color(0xFFF8F9FA);
  static const Color textDark = Color(0xFF1B263B);
  static const Color textLight = Color(0xFF778DA9);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        primary: primaryBlue,
        secondary: accentPurple,
        surface: Colors.white,
        onSurface: textDark,
      ),
      scaffoldBackgroundColor: Colors.transparent,
      textTheme: const TextTheme(
        displayMedium: TextStyle(color: textDark, fontWeight: FontWeight.w900, letterSpacing: -1.0),
        headlineLarge: TextStyle(color: textDark, fontWeight: FontWeight.bold, letterSpacing: -0.5),
        titleLarge: TextStyle(color: textDark, fontWeight: FontWeight.w700),
        bodyLarge: TextStyle(color: textDark, fontSize: 16, height: 1.5),
        bodyMedium: TextStyle(color: textLight, fontSize: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: primaryBlue.withOpacity(0.4),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white.withOpacity(0.8),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: Colors.white.withOpacity(0.5), width: 1.5),
        ),
      ),
    );
  }
}
