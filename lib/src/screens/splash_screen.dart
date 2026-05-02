import 'dart:async';

import 'package:flutter/material.dart';
import '../design/colors.dart';
import '../design/typography.dart';
import '../design/spacing.dart';
import '../core/constants.dart';

/// Splash screen shown on app launch
/// Duration: 2-3 seconds
/// Based on design specifications
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _navTimer;

  @override
  void dispose() {
    _navTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Navigate to next screen after 2-3 seconds
    _navTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      // Per design prompt: Splash -> Onboarding -> Login
      Navigator.of(context).pushReplacementNamed(
        AppConstants.routeOnboarding,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primaryDark, AppColors.primaryLight],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App icon/logo
              const Icon(
                Icons.construction,
                size: 120,
                color: AppColors.white,
              ),
              const SizedBox(height: AppSpacing.lg),
              
              // App name with gradient text effect
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [AppColors.white, Color(0xB3FFFFFF)], // white to white70
                ).createShader(bounds),
                child: Text(
                  AppConstants.appName,
                  style: AppTypography.h1.copyWith(
                    fontSize: 36,
                    color: AppColors.white,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              
              // Tagline
              Text(
                AppConstants.appTagline,
                style: AppTypography.bodyMedium.copyWith(
                  color: const Color(0xB3FFFFFF), // white70
                ),
              ),
              const SizedBox(height: AppSpacing.space64),
              
              // Loading indicator
              const CircularProgressIndicator(
                color: AppColors.white,
                strokeWidth: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

