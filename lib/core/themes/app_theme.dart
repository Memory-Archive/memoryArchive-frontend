import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_text_styles.dart';

abstract final class AppTheme {
  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.green,
        primary: AppColors.green,
        onPrimary: AppColors.onGreen,
        surface: AppColors.background,
        onSurface: AppColors.ink,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.background,
    );

    OutlineInputBorder border(Color color, double width) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.field),
          borderSide: BorderSide(color: color, width: width),
        );

    return base.copyWith(
      textTheme: GoogleFonts.dmSansTextTheme(base.textTheme).apply(
        bodyColor: AppColors.ink,
        displayColor: AppColors.ink,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.card,
        hintStyle: AppTextStyles.body(size: 16, color: AppColors.hint),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        border: border(AppColors.line, 1.5),
        enabledBorder: border(AppColors.line, 1.5),
        focusedBorder: border(AppColors.green, 2),
        errorBorder: border(AppColors.error, 1.5),
        focusedErrorBorder: border(AppColors.error, 2),
        disabledBorder: border(AppColors.line, 1.5),
        errorStyle: AppTextStyles.body(size: 13, weight: FontWeight.w500, color: AppColors.error),
        errorMaxLines: 2,
        helperStyle: AppTextStyles.body(size: 12, color: AppColors.muted),
        helperMaxLines: 2,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.green,
        selectionHandleColor: AppColors.green,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: AppColors.green),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.ink,
        contentTextStyle: AppTextStyles.body(color: AppColors.card),
      ),
    );
  }
}
