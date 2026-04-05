import 'package:flutter/material.dart';

/// Основная цветовая палитра приложения
class AppColors {
  AppColors._();

  // Основные цвета (Dark Mode First для премиум ощущения)
  static const Color background = Color(0xFF0F0F13);
  static const Color surface = Color(0xFF1C1C2E);
  static const Color surfaceLight = Color(0xFF2A2A40);
  
  // Акцентные цвета
  static const Color primary = Color(0xFF5E5CE6); // iOS Purple
  static const Color primaryLight = Color(0xFF8E8BF9);
  static const Color success = Color(0xFF30D158); // iOS Green
  static const Color warning = Color(0xFFFFD60A); // iOS Yellow
  static const Color error = Color(0xFFFF453A);   // iOS Red
  static const Color info = Color(0xFF0A84FF);    // iOS Blue

  // Текст
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8E8E93);
  static const Color textTertiary = Color(0xFF48484A);

  // Glassmorphism эффекты
  static const Color glassBackground = Color(0x33FFFFFF); // 20% opacity white
  static const Color glassBorder = Color(0x1AFFFFFF);     // 10% opacity white
  
  // Градиенты для карт
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF5E5CE6), Color(0xFF8E8BF9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF30D158), Color(0xFF34C759)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warningGradient = LinearGradient(
    colors: [Color(0xFFFFD60A), Color(0xFFFF9F0A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient errorGradient = LinearGradient(
    colors: [Color(0xFFFF453A), Color(0xFFFF3B30)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
