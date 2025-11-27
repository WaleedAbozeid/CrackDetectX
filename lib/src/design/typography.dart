import 'package:flutter/material.dart';
import 'colors.dart';

/// Typography design tokens for CrackDetectX
/// Based on COMPLETE_PROMPT.md specifications
/// Font Family: Cairo (via Google Fonts)
class AppTypography {
  static const String fontFamily = 'Cairo';

  // ==================== HEADINGS ====================
  /// H1 (Page Titles): 28px Bold, -2% letter-spacing
  static const TextStyle h1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28.0,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.56, // -2% of 28px
    height: 1.2,
    color: AppColors.primary900,
  );

  /// H2 (Section Titles): 24px Bold, -1% letter-spacing
  static const TextStyle h2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.24, // -1% of 24px
    height: 1.25,
    color: AppColors.grey900,
  );

  /// H3 (Card Titles): 20px Semibold
  static const TextStyle h3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    color: AppColors.grey900,
    height: 1.3,
  );

  /// H4 (Small Headings): 16px Semibold
  static const TextStyle h4 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: AppColors.grey900,
    height: 1.4,
  );

  // ==================== BODY TEXT ====================
  /// Body: 14px Regular
  static const TextStyle bodyText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  /// Body Small: 13px Regular
  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13.0,
    fontWeight: FontWeight.normal,
    color: AppColors.grey500,
    height: 1.5,
  );

  // ==================== CAPTION ====================
  /// Caption: 12px Regular
  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
    color: AppColors.grey400,
    height: 1.4,
  );

  // ==================== BUTTON TEXT ====================
  /// Button Text: 14px Semibold
  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    height: 1.4,
  );

  // ==================== DEPRECATED ALIASES (for backwards compatibility) ====================
  static const TextStyle headline1 = h1;
  static const TextStyle headline2 = h2;
  static const TextStyle headline3 = h3;
  static const TextStyle bodyText1 = bodyText;
  static const TextStyle bodyText2 = bodySmall;
}
