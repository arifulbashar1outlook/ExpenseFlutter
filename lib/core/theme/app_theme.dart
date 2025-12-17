
import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        error: errorColor,
      ),
      scaffoldBackgroundColor: lightGreyColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        iconTheme: IconThemeData(color: whiteColor),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: whiteColor,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 30),
        bodyLarge: TextStyle(fontFamily: 'Roboto', fontSize: 16),
        labelLarge: TextStyle(fontFamily: 'Merriweather', fontStyle: FontStyle.italic, fontSize: 14),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: primaryColor,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        error: errorColor,
      ),
      appBarTheme: const AppBarTheme(
        iconTheme: IconThemeData(color: whiteColor),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: whiteColor,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 30, color: whiteColor),
        bodyLarge: TextStyle(fontFamily: 'Roboto', fontSize: 16, color: whiteColor),
        labelLarge: TextStyle(fontFamily: 'Merriweather', fontStyle: FontStyle.italic, fontSize: 14, color: whiteColor),
      ).apply(bodyColor: whiteColor, displayColor: whiteColor),
    );
  }
}
