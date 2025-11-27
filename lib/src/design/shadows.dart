import 'package:flutter/material.dart';

/// Shadow design tokens for CrackDetectX
/// Based on COMPLETE_PROMPT.md specifications
class AppShadows {
  /// Card Shadow: 0 4px 6px -1px rgba(0,0,0,0.1)
  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x1A000000), // 10% opacity
      blurRadius: 6.0,
      offset: Offset(0, 4),
      spreadRadius: -1.0,
    ),
  ];

  /// Elevated Shadow: 0 10px 15px -3px rgba(0,0,0,0.1)
  static const List<BoxShadow> elevated = [
    BoxShadow(
      color: Color(0x1A000000), // 10% opacity
      blurRadius: 15.0,
      offset: Offset(0, 10),
      spreadRadius: -3.0,
    ),
  ];

  /// Button Hover Shadow: 0 4px 6px -1px rgba(0,0,0,0.15)
  static const List<BoxShadow> buttonHover = [
    BoxShadow(
      color: Color(0x26000000), // 15% opacity
      blurRadius: 6.0,
      offset: Offset(0, 4),
      spreadRadius: -1.0,
    ),
  ];

  /// Modal Shadow: 0 25px 50px -12px rgba(0,0,0,0.25)
  static const List<BoxShadow> modal = [
    BoxShadow(
      color: Color(0x40000000), // 25% opacity
      blurRadius: 50.0,
      offset: Offset(0, 25),
      spreadRadius: -12.0,
    ),
  ];

  /// Floating Shadow (for floating action buttons, etc.)
  static const List<BoxShadow> floating = [
    BoxShadow(
      color: Color(0x26000000), // 15% opacity
      blurRadius: 12.0,
      offset: Offset(0, 4),
    ),
  ];
}
