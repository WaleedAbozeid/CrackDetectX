import 'package:flutter/material.dart';
import '../design/typography.dart';
import '../design/colors.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final bool showBackButton;
  final Color backgroundColor;
  final Color textColor;

  const AppTopBar({
    required this.title,
    this.onBack,
    this.actions,
    this.showBackButton = true,
    this.backgroundColor = AppColors.white,
    this.textColor = AppColors.primary900,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      leading: showBackButton
          ? IconButton(
              icon: Icon(Icons.arrow_back, color: textColor),
              onPressed: onBack ?? () => Navigator.pop(context),
            )
          : null,
      title: Text(
        title,
        style: AppTypography.h3.copyWith(
          color: textColor,
        ),
      ),
      centerTitle: true,
      actions: actions,
      surfaceTintColor: Colors.transparent,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
