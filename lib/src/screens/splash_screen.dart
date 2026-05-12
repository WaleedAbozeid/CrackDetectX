import 'dart:async';
import 'package:flutter/material.dart';
import '../design/colors.dart';
import '../design/typography.dart';
import '../design/spacing.dart';
import '../core/constants.dart';
import '../services/auth_service.dart';
import '../store/app_state.dart';
import 'package:provider/provider.dart';

/// Splash screen — also handles session restoration from saved JWT tokens.
///
/// Flow:
/// 1. Show logo + loading indicator
/// 2. Try to restore session via [AuthService.restoreSession]
///    - Success → navigate to /home (role-based redirect via RoleRouter)
///    - Failure → navigate to onboarding (first time) or /welcome
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    // Minimum splash display time
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    try {
      // Try to restore saved JWT session
      final user = await AuthService.instance.restoreSession();

      if (!mounted) return;

      if (user != null) {
        // Session restored — set user in AppState and go home
        context.read<AppState>().setCurrentUser(user);
        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed(AppConstants.routeHome);
      } else {
        // No saved session → go to onboarding
        Navigator.of(context).pushReplacementNamed(AppConstants.routeOnboarding);
      }
    } catch (_) {
      // Any error → fall back to onboarding
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(AppConstants.routeOnboarding);
      }
    }
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

              // App name
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [AppColors.white, Color(0xB3FFFFFF)],
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
                  color: const Color(0xB3FFFFFF),
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
