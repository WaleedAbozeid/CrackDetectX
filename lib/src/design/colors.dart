import 'package:flutter/material.dart';

/// Official design color tokens for CrackDetectX
/// Based on COMPLETE_PROMPT.md specifications
class AppColors {
  // ==================== PRIMARY BRAND COLORS ====================
  /// Navy Blue (Primary) - #1E3A8A
  static const Color primary900 = Color(0xFF1E3A8A);
  static const Color primary700 = Color(0xFF1D4ED8);
  static const Color primary500 = Color(0xFF3B82F6);
  static const Color primary300 = Color(0xFF93C5FD);
  static const Color primary100 = Color(0xFFDBEAFE);

  /// Light Blue (Secondary) - #3B82F6
  static const Color secondary500 = Color(0xFF3B82F6);
  static const Color secondaryLight = Color(0xFF60A5FA);

  // ==================== GREYSCALE ====================
  static const Color grey50 = Color(0xFFF9FAFB);
  static const Color grey100 = Color(0xFFF3F4F6);
  static const Color grey200 = Color(0xFFE5E7EB);
  static const Color grey300 = Color(0xFFD1D5DB);
  static const Color grey400 = Color(0xFF9CA3AF);
  static const Color grey500 = Color(0xFF6B7280);
  static const Color grey600 = Color(0xFF4B5563);
  static const Color grey700 = Color(0xFF374151);
  static const Color grey800 = Color(0xFF1F2937);
  static const Color grey900 = Color(0xFF111827);

  /// White (Background)
  static const Color white = Color(0xFFFFFFFF);

  // ==================== SEMANTIC COLORS ====================
  /// Success Green (Low Risk) - #10B981
  static const Color successGreen = Color(0xFF10B981);
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color successDark = Color(0xFF047857);

  /// Warning Orange (Medium Risk) - #F59E0B
  static const Color warningOrange = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color warningDark = Color(0xFFD97706);

  /// Danger Red (High Risk) - #EF4444
  static const Color dangerRed = Color(0xFFEF4444);
  static const Color dangerLight = Color(0xFFFEE2E2);
  static const Color dangerDark = Color(0xFFDC2626);

  /// Info Blue - #3B82F6
  static const Color infoBlue = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFDBEAFE);
  static const Color infoDark = Color(0xFF1D4ED8);

  // ==================== SEMANTIC ALIASES ====================
  static const Color background = white;
  static const Color textPrimary = grey900;
  static const Color textSecondary = grey600;
  static const Color textTertiary = grey500;
  static const Color border = grey200;
  static const Color divider = grey200;
  static const Color placeholder = grey300;
  static const Color disabled = grey400;

  // ==================== RISK LEVEL COLORS ====================
  static const Color highRisk = dangerRed;
  static const Color highRiskBackground = dangerLight;
  static const Color mediumRisk = warningOrange;
  static const Color mediumRiskBackground = warningLight;
  static const Color lowRisk = successGreen;
  static const Color lowRiskBackground = successLight;
}
