import 'package:flutter/material.dart';
import '../design/colors.dart';
import '../design/typography.dart';
import '../design/radius.dart';
import '../design/spacing.dart';

class AppButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final double? height;
  final double? width;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? prefixIcon;
  final IconData? suffixIcon;

  const AppButton({
    required this.title,
    this.onPressed,
    this.height,
    this.width,
    this.backgroundColor,
    this.textColor,
    this.prefixIcon,
    this.suffixIcon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 48,
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md,
            horizontal: AppSpacing.lg,
          ),
          backgroundColor: backgroundColor ?? AppColors.primary500,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.r12),
          ),
          elevation: 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (prefixIcon != null) ...[
              Icon(
                prefixIcon,
                color: textColor ?? AppColors.white,
                size: 18,
              ),
              const SizedBox(width: AppSpacing.md),
            ],
            Expanded(
              child: Text(
                title,
                style: AppTypography.button.copyWith(
                  color: textColor ?? AppColors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            if (suffixIcon != null) ...[
              const SizedBox(width: AppSpacing.md),
              Icon(
                suffixIcon,
                color: textColor ?? AppColors.white,
                size: 18,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
