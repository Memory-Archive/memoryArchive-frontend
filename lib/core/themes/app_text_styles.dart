import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Fonts from the designs, loaded with `google_fonts`:
/// * Fraunces: headings
/// * Bricolage Grotesque: the green accent word in headings
/// * DM Sans: body text
/// * Caveat: handwritten captions
///
/// `google_fonts` downloads each font once and caches it. Without internet on
/// the first run, the platform font is used instead.
abstract final class AppTextStyles {
  static TextStyle display({double size = 32, Color color = AppColors.ink}) =>
      GoogleFonts.fraunces(
        fontSize: size,
        fontWeight: FontWeight.w700,
        height: 1.05,
        color: color,
      );

  static TextStyle accent({double size = 32, Color color = AppColors.green}) {
    try {
      return GoogleFonts.getFont(
        'Bricolage Grotesque',
        fontSize: size,
        fontWeight: FontWeight.w800,
        height: 1.05,
        letterSpacing: size * -0.03,
        color: color,
      );
    } catch (_) {
      // Older google_fonts versions don't list this family: use DM Sans
      // extra bold instead of crashing.
      return GoogleFonts.dmSans(
        fontSize: size,
        fontWeight: FontWeight.w800,
        height: 1.05,
        letterSpacing: size * -0.03,
        color: color,
      );
    }
  }

  static TextStyle body({
    double size = 15,
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.ink,
    double? height,
  }) =>
      GoogleFonts.dmSans(fontSize: size, fontWeight: weight, color: color, height: height);

  static TextStyle label() => body(size: 14, weight: FontWeight.w700);

  static TextStyle button() => body(size: 16, weight: FontWeight.w700);

  static TextStyle eyebrow({Color color = AppColors.muted}) =>
      body(size: 12, weight: FontWeight.w700, color: color).copyWith(letterSpacing: 1.1);

  static TextStyle hand({double size = 22, Color color = AppColors.ink}) =>
      GoogleFonts.caveat(fontSize: size, fontWeight: FontWeight.w500, color: color, height: 1.1);
}
