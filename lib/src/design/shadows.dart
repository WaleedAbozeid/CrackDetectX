import 'package:flutter/material.dart';

class AppShadows {
  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x1F000000),
      blurRadius: 8.0,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> modal = [
    BoxShadow(
      color: Color(0x26000000),
      blurRadius: 16.0,
      offset: Offset(0, 6),
    ),
  ];

  static const List<BoxShadow> floating = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 12.0,
      offset: Offset(0, 4),
    ),
  ];
}
