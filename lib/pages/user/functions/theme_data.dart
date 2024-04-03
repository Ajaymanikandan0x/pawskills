import 'package:flutter/material.dart';

class AppTheme {
  // Define colors
  static const Color primaryColor = Colors.blueAccent;
  static const Color accentColor = Colors.lightBlueAccent;
  static const Color textColor = Colors.black87;
  static const Color backgroundColor = Colors.white;

  // Define text styles
  static const TextStyle headingStyle1 = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w600,
    color: textColor,
  );
  static const TextStyle headingStyle2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: textColor,
  );

  static const TextStyle paragraphStyle = TextStyle(
    fontSize: 16,
    color: textColor,
  );

  // Prevent instantiation
  AppTheme._();

  // Define theme data
  static ThemeData get themeData {
    return ThemeData(
      primaryColor: primaryColor,
      hintColor: accentColor,
      textTheme: const TextTheme(
        displayLarge: headingStyle1,
        displayMedium: headingStyle2,
        bodySmall: paragraphStyle,
      ),
    );
  }
}
