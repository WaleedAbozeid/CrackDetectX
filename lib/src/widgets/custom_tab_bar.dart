import 'package:flutter/material.dart';
import '../design/colors.dart';
import '../design/typography.dart';
import '../design/radius.dart';
import '../design/spacing.dart';
import '../design/shadows.dart';

/// Custom tab bar widget with pill-style tabs
/// Based on design specifications
class CustomTabBar extends StatelessWidget {
  final List<String> tabs;
  final String currentTab;
  final Function(String) onTabChanged;

  const CustomTabBar({
    required this.tabs,
    required this.currentTab,
    required this.onTabChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(AppRadius.r12),
      ),
      child: Row(
        children: tabs.map((tab) {
          final isSelected = currentTab == tab;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(tab),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.space12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadius.r6),
                  boxShadow: isSelected ? AppShadows.small : [],
                ),
                child: Center(
                  child: Text(
                    tab,
                    style: AppTypography.bodyMedium.copyWith(
                      color: isSelected ? AppColors.primaryDark : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

