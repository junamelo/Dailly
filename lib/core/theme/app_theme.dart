import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF7357E8),
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color(0xFFF8F7FC),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFF8F7FC),
        elevation: 0,
      ),
      cardTheme: const CardThemeData(elevation: 0, margin: EdgeInsets.zero),
    );
  }
}
