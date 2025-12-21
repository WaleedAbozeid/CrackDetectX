import 'package:flutter/material.dart';
import '../design/colors.dart';
import '../design/typography.dart';
import '../design/radius.dart';
import '../design/spacing.dart';
import '../design/shadows.dart';

/// Primary button with gradient background
/// Based on design specifications
class AppButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final double? height;
  final double? width;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool useGradient;

  const AppButton({
    required this.title,
    this.onPressed,
    this.height,
    this.width,
    this.backgroundColor,
    this.textColor,
    this.prefixIcon,
    this.suffixIcon,
    this.useGradient = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final buttonHeight = height ?? 56.0;
    final bgColor = backgroundColor ?? AppColors.primary500;

    return SizedBox(
      height: buttonHeight,
      width: width ?? double.infinity,
      child: Container(
        decoration: BoxDecoration(
          gradient: useGradient
              ? LinearGradient(
                  colors: [AppColors.primaryDark, AppColors.primaryLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: useGradient ? null : bgColor,
          borderRadius: BorderRadius.circular(AppRadius.r12),
          boxShadow: AppShadows.buttonHover,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadius.r12),
            onTap: onPressed,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (prefixIcon != null) ...[
                    Icon(
                      prefixIcon,
                      color: textColor ?? AppColors.white,
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  Text(
                    title,
                    style: AppTypography.button.copyWith(
                      color: textColor ?? AppColors.white,
                      fontSize: 16,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (suffixIcon != null) ...[
                    const SizedBox(width: AppSpacing.sm),
                    Icon(
                      suffixIcon,
                      color: textColor ?? AppColors.white,
                      size: 20,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Secondary button with outlined border
class SecondaryButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final double? height;
  final double? width;
  final Color? borderColor;
  final Color? textColor;
  final IconData? prefixIcon;
  final IconData? suffixIcon;

  const SecondaryButton({
    required this.title,
    this.onPressed,
    this.height,
    this.width,
    this.borderColor,
    this.textColor,
    this.prefixIcon,
    this.suffixIcon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final buttonHeight = height ?? 56.0;
    final border = borderColor ?? AppColors.primaryLight;

    return SizedBox(
      height: buttonHeight,
      width: width ?? double.infinity,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: border, width: 2),
          borderRadius: BorderRadius.circular(AppRadius.r12),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadius.r12),
            onTap: onPressed,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (prefixIcon != null) ...[
                    Icon(
                      prefixIcon,
                      color: textColor ?? border,
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  Text(
                    title,
                    style: AppTypography.button.copyWith(
                      color: textColor ?? border,
                      fontSize: 16,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (suffixIcon != null) ...[
                    const SizedBox(width: AppSpacing.sm),
                    Icon(
                      suffixIcon,
                      color: textColor ?? border,
                      size: 20,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
