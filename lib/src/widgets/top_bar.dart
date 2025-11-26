import 'package:flutter/material.dart';
import '../design/colors.dart';
import '../design/typography.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const AppTopBar({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary500,
      title: Text(title, style: AppTypography.headline3.copyWith(color: AppColors.white)),
      centerTitle: true,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
