import 'package:flutter/material.dart';
import '../design/colors.dart';
import '../design/typography.dart';
import '../design/radius.dart';

class AppButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;

  const AppButton({required this.title, this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        backgroundColor: AppColors.primary500,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.r10)),
        elevation: 2,
      ),
      child: Text(title, style: AppTypography.button),
    );
  }
}
