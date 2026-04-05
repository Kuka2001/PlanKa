import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Настройки темы приложения
class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.primaryLight,
        surface: AppColors.surface,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSurface: AppColors.textPrimary,
        onError: Colors.white,
      ),
      
      // Кросс-платформенная типографика с fallback
      fontFamily: _getSystemFontFamily(),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32, 
          fontWeight: FontWeight.bold, 
          color: AppColors.textPrimary,
          letterSpacing: -0.5,
        ),
        headlineMedium: TextStyle(
          fontSize: 24, 
          fontWeight: FontWeight.w600, 
          color: AppColors.textPrimary,
          letterSpacing: -0.3,
        ),
        titleLarge: TextStyle(
          fontSize: 20, 
          fontWeight: FontWeight.w600, 
          color: AppColors.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 17, 
          fontWeight: FontWeight.normal, 
          color: AppColors.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 15, 
          fontWeight: FontWeight.normal, 
          color: AppColors.textSecondary,
        ),
        labelLarge: TextStyle(
          fontSize: 17, 
          fontWeight: FontWeight.w600, 
          color: AppColors.primary,
        ),
      ),

      // Карточки без стандартных теней (используем glassmorphism вручную)
      cardTheme: CardTheme(
        elevation: 0,
        color: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),

      // Input декорации
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),

      // Elevated Button стиль
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),

      // Floating Action Button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: CircleBorder(),
      ),
    );
  }

  /// Возвращает системный шрифт для платформы
  static String _getSystemFontFamily() {
    // Используем константу для избежания проблем с тестированием
    try {
      if (Platform.isIOS) {
        return '.SF Pro Text';
      } else if (Platform.isAndroid) {
        return 'Roboto';
      }
    } catch (e) {
      // Fallback если Platform недоступен (например в тестах или web)
    }
    // Fallback для других платформ (web, desktop)
    return 'Roboto';
  }

  /// Light theme версия (опционально)
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF5F5F7),
      primaryColor: AppColors.primary,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.primaryLight,
        surface: Colors.white,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSurface: Color(0xFF1C1C1E),
        onError: Colors.white,
      ),
      fontFamily: _getSystemFontFamily(),
    );
  }
}
