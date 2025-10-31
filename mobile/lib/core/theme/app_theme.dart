import 'package:flutter/material.dart';
import 'package:mobile/core/constants/colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppColors.secondary),
    ),
    listTileTheme: ListTileThemeData(iconColor: AppColors.primary),
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    textTheme: const TextTheme(bodyMedium: TextStyle(color: AppColors.text)),
  );
}
