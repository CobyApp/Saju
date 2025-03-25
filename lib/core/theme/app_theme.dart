import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF007AFF); // iOS blue
  static const Color backgroundColor = Color(0xFFF2F2F7); // iOS background gray
  static const Color secondaryBackgroundColor = Color(0xFFFFFFFF);
  static const Color textColor = Color(0xFF000000);
  static const Color secondaryTextColor = Color(0xFF8E8E93);

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: primaryColor,
        surface: secondaryBackgroundColor,
        background: backgroundColor,
        onBackground: textColor,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: textColor,
          fontSize: 34,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.37,
          fontFamily: '.SF Pro Display',
        ),
        bodyLarge: TextStyle(
          color: textColor,
          fontSize: 17,
          letterSpacing: -0.41,
          fontFamily: '.SF Pro Text',
        ),
        bodyMedium: TextStyle(
          color: textColor,
          fontSize: 15,
          letterSpacing: -0.24,
          fontFamily: '.SF Pro Text',
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: secondaryBackgroundColor,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: IconThemeData(color: primaryColor),
        titleTextStyle: TextStyle(
          color: textColor,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.41,
          fontFamily: '.SF Pro Text',
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: backgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        hintStyle: const TextStyle(
          color: secondaryTextColor,
          fontSize: 17,
          letterSpacing: -0.41,
          fontFamily: '.SF Pro Text',
        ),
      ),
    );
  }
} 