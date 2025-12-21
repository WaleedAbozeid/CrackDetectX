import 'package:flutter/material.dart';
import 'package:crackdetectx/l10n/app_localizations.dart';
import '../design/colors.dart';
import '../design/typography.dart';
import '../design/spacing.dart';
import '../design/radius.dart';
import '../core/constants.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    // Re-initializing content locally to access context for localization
    final List<OnboardingContent> contents = [
      OnboardingContent(
        title: AppLocalizations.of(context)!.onboardingTitle1,
        subtitle: AppLocalizations.of(context)!.onboardingSubtitle1,
        icon: Icons.apartment,
      ),
      OnboardingContent(
        title: AppLocalizations.of(context)!.onboardingTitle2,
        subtitle: AppLocalizations.of(context)!.onboardingSubtitle2,
        icon: Icons.psychology, // AI Brain icon
      ),
      OnboardingContent(
        title: AppLocalizations.of(context)!.onboardingTitle3,
        subtitle: AppLocalizations.of(context)!.onboardingSubtitle3,
        icon: Icons.store_mall_directory,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (value) {
                  setState(() {
                    _currentPage = value;
                  });
                },
                itemCount: contents.length,
                itemBuilder: (context, index) =>
                    OnboardingContentCard(content: contents[index]),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: Column(
                  children: [
                    // Dot Indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        contents.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.only(right: 8),
                          height: 8,
                          width: _currentPage == index ? 24 : 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? AppColors.primary500
                                : AppColors.grey300,
                            borderRadius: BorderRadius.circular(AppRadius.full),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),

                    // Main Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_currentPage == contents.length - 1) {
                            Navigator.pushReplacementNamed(
                              context,
                              AppConstants.routeLogin,
                            );
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary500,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.r16),
                          ),
                          elevation: 2,
                        ),
                        child: Text(
                          _currentPage == contents.length - 1
                              ? AppLocalizations.of(
                                  context,
                                )!.onboardingGetStarted
                              : AppLocalizations.of(context)!.onboardingNext,
                          style: AppTypography.button,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Skip button
                    if (_currentPage != contents.length - 1)
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            AppConstants.routeLogin,
                          );
                        },
                        child: Text(
                          AppLocalizations.of(context)!.onboardingSkip,
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.grey500,
                          ),
                        ),
                      )
                    else
                      const SizedBox(
                        height: 48,
                      ), // Placeholder for layout stability

                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingContent {
  final String title;
  final String subtitle;
  final IconData icon;

  OnboardingContent({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

class OnboardingContentCard extends StatelessWidget {
  final OnboardingContent content;

  const OnboardingContentCard({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            decoration: BoxDecoration(
              color: AppColors.primary50.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(content.icon, size: 100, color: AppColors.primary500),
          ),
          const SizedBox(height: AppSpacing.space64),
          Text(
            content.title,
            textAlign: TextAlign.center,
            style: AppTypography.h2.copyWith(color: AppColors.primary900),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            content.subtitle,
            textAlign: TextAlign.center,
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
