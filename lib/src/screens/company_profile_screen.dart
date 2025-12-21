import 'package:flutter/material.dart';
import '../design/colors.dart';
import '../design/typography.dart';
import '../design/spacing.dart';
import '../design/radius.dart';
import '../design/shadows.dart';

class CompanyProfileScreen extends StatelessWidget {
  final Map<String, dynamic> companyData;

  const CompanyProfileScreen({super.key, required this.companyData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey50,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 280,
            backgroundColor: AppColors.primary900,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary900, AppColors.primary500],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40), // status bar buffer
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.white,
                      // backgroundImage: NetworkImage(companyData['logo']), // TODO
                      child: const Icon(
                        Icons.business,
                        size: 50,
                        color: AppColors.grey500,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      companyData['name'],
                      style: AppTypography.h2.copyWith(color: AppColors.white),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.star,
                          color: AppColors.warningOrange,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${companyData['rating']} (${companyData['reviews']} reviews)',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Verification Badge if verified
                  if (companyData['verified'])
                    Container(
                      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: AppColors.successGreen.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppRadius.r8),
                        border: Border.all(color: AppColors.successGreen),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.verified,
                            color: AppColors.successGreen,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'Verified Company',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.successGreen,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Quick Stats
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          Icons.check_circle_outline,
                          '${companyData['projects']}',
                          'Projects',
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _buildStatCard(
                          Icons.access_time,
                          '24h', // Dummy data
                          'Response',
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _buildStatCard(
                          Icons.thumb_up_outlined,
                          '98%', // Dummy data
                          'Success',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // About
                  Text('About', style: AppTypography.h3),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    companyData['description'],
                    style: AppTypography.bodyText.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Specializations
                  Text('Specializations', style: AppTypography.h3),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (companyData['specializations'] as List<String>)
                        .map((spec) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary100,
                              borderRadius: BorderRadius.circular(
                                AppRadius.full,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.check,
                                  size: 16,
                                  color: AppColors.primary900,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  spec,
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.primary900,
                                  ),
                                ),
                              ],
                            ),
                          );
                        })
                        .toList(),
                  ),

                  const SizedBox(height: AppSpacing.xxl),

                  // Contact Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Contact Logic
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary500,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.r12),
                        ),
                      ),
                      child: Text(
                        'Contact Company',
                        style: AppTypography.button,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40), // Bottom padding
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.md,
        horizontal: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.r12),
        boxShadow: AppShadows.small,
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary500),
          const SizedBox(height: 8),
          Text(value, style: AppTypography.h4),
          Text(label, style: AppTypography.caption),
        ],
      ),
    );
  }
}
