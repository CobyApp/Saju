import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // 메인 컬러: 선명한 보라색
  static const Color primaryColor = Color(0xFF6B4EFF);
  // 배경색: 은은한 라벤더 그라데이션을 위한 밝은 보라색
  static const Color backgroundColor = Color(0xFFF5F0FF);
  // 보조 배경색: 반투명한 흰색
  static const Color secondaryBackgroundColor = Color(0xFFFFFFFF);
  // 텍스트 컬러: 진한 보라색
  static const Color textColor = Color(0xFF2D1B4E);
  // 보조 텍스트 컬러: 연한 보라색
  static const Color secondaryTextColor = Color(0xFF6B4EFF);
  // 메시지 배경색: 연한 보라색
  static const Color messageBackgroundColor = Color(0xFFFFFFFF);
  // 사용자 메시지 배경색: 진한 보라색
  static const Color userMessageBackgroundColor = Color(0xFF6B4EFF);
  // 사용자 메시지 텍스트 컬러: 흰색
  static const Color userMessageTextColor = Color(0xFFFFFFFF);
  // 앱바 배경색: 반투명한 보라색
  static const Color appBarBackgroundColor = Color(0xFFFFFFFF);
  // 앱바 그림자 색상
  static const Color appBarShadowColor = Color(0x1A6B4EFF);
  // 메시지 그림자 색상
  static const Color messageShadowColor = Color(0x1A6B4EFF);
  // 메시지 테두리 색상
  static const Color messageBorderColor = Color(0xFFE8E0FF);

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
        backgroundColor: appBarBackgroundColor,
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
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
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