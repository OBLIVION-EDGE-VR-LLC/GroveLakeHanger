import 'package:flutter/material.dart';

class OblivionTheme {
  // Oblivion Edge Colors
  static const Color primaryCyan = Color(0xFF00CED1);
  static const Color secondaryGold = Color(0xFFFFD700);
  static const Color darkBackground = Color(0xFF1A1A2E);
  static const Color orangeAccent = Color(0xFFFF6B35);
  static const Color neonGreen = Color(0xFF00FF00);
  static const Color darkGray = Color(0xFF2D2D44);
  static const Color lightGray = Color(0xFFCCCCCC);

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryCyan,
    scaffoldBackgroundColor: darkBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: darkGray,
      foregroundColor: primaryCyan,
      elevation: 2,
      shadowColor: primaryCyan.withOpacity(0.3),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: primaryCyan,
      textTheme: ButtonTextTheme.primary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryCyan,
        foregroundColor: darkBackground,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryCyan,
        side: const BorderSide(color: primaryCyan, width: 2),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: primaryCyan,
        shadows: [
          Shadow(
            offset: const Offset(0, 2),
            blurRadius: 8,
            color: primaryCyan.withOpacity(0.5),
          )
        ],
      ),
      displayMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: secondaryGold,
      ),
      headlineSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: primaryCyan,
      ),
      bodyLarge: const TextStyle(
        fontSize: 16,
        color: lightGray,
      ),
      bodyMedium: const TextStyle(
        fontSize: 14,
        color: lightGray,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: primaryCyan,
      ),
    ),
    cardTheme: CardTheme(
      color: darkGray,
      elevation: 4,
      shadowColor: primaryCyan.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: primaryCyan.withOpacity(0.3), width: 1),
      ),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: primaryCyan,
      inactiveTrackColor: darkGray,
      thumbColor: secondaryGold,
      overlayColor: primaryCyan.withOpacity(0.3),
    ),
  );
}
