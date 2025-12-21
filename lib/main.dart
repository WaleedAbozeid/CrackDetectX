import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:crackdetectx/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'src/core/constants.dart';
import 'src/store/app_state.dart';
import 'src/screens/splash_screen.dart';
import 'src/screens/welcome_screen.dart';
import 'src/screens/onboarding_screen.dart';
import 'src/screens/login_screen.dart';
import 'src/screens/signup_screen.dart';
import 'src/screens/home_screen.dart';
import 'src/screens/scan_screen.dart';
import 'src/screens/result_screen.dart';
import 'src/screens/reports_list_screen.dart';
import 'src/widgets/auth_guard.dart';

import 'src/design/colors.dart';
import 'src/design/typography.dart';

/// Main entry point for CrackDetectX application
Future<void> main() async {
  // Ensure Flutter bindings are initialized before using any plugins
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (uses android/app/google-services.json on Android)
  await Firebase.initializeApp();

  runApp(const MyApp());
}

/// Main application widget for CrackDetectX
///
/// Sets up the app with:
/// - Provider for state management
/// - Material Design 3 theme
/// - RTL (Right-to-Left) support for Arabic
/// - Custom color scheme and typography
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: Consumer<AppState>(
        builder: (context, appState, child) {
          final baseTheme = ThemeData.light(useMaterial3: true);

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: AppConstants.appName,
            theme: _buildTheme(baseTheme),
            darkTheme: _buildDarkTheme(ThemeData.dark(useMaterial3: true)),
            themeMode: appState.themeMode,
            locale: appState.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            // supportedLocales: AppLocalizations.supportedLocales,
            supportedLocales: const [Locale('en'), Locale('ar')],
            initialRoute: AppConstants.routeSplash,
            routes: _buildRoutes(),
            builder: (context, child) {
              return Directionality(
                textDirection: appState.locale.languageCode == 'ar'
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: child!,
              );
            },
          );
        },
      ),
    );
  }

  /// Builds the application theme with custom colors and typography
  ThemeData _buildTheme(ThemeData baseTheme) {
    return baseTheme.copyWith(
      primaryColor: AppColors.primary500,
      scaffoldBackgroundColor: AppColors.background,
      cardColor: AppColors.white,
      textTheme: baseTheme.textTheme.apply(
        fontFamily: AppTypography.fontFamily,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary500,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.white),
        titleTextStyle: TextStyle(
          color: AppColors.white,
          fontFamily: AppTypography.fontFamily,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary500,
        primary: AppColors.primary500,
        surface: AppColors.white,
        onPrimary: AppColors.white,
        onSecondary: AppColors.white,
        onSurface: AppColors.grey900,
      ),
    );
  }

  /// Builds dark theme for the application
  ThemeData _buildDarkTheme(ThemeData baseTheme) {
    return baseTheme.copyWith(
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryLight,
      scaffoldBackgroundColor: AppColors.darkBackground,
      cardColor: AppColors.darkCard,
      dividerColor: AppColors.darkBorder,
      textTheme: baseTheme.textTheme.apply(
        fontFamily: AppTypography.fontFamily,
        bodyColor: AppColors.darkText,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkCard,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.darkText),
        titleTextStyle: TextStyle(
          color: AppColors.darkText,
          fontFamily: AppTypography.fontFamily,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      colorScheme: baseTheme.colorScheme.copyWith(
        brightness: Brightness.dark,
        primary: AppColors.primaryLight,
        secondary: AppColors.secondaryLight,
        surface: AppColors.darkCard,

        error: AppColors.dangerRed,
        onPrimary: AppColors.white,
        onSurface: AppColors.darkText,
      ),
    );
  }

  /// Builds the application routes with RTL support
  /// Protected routes (Home, Scan, Result, Reports) require authentication
  Map<String, WidgetBuilder> _buildRoutes() {
    return {
      AppConstants.routeSplash: (_) => const _RTLWrapper(child: SplashScreen()),
      AppConstants.routeOnboarding: (_) =>
          const _RTLWrapper(child: OnboardingScreen()),
      AppConstants.routeWelcome: (_) =>
          const _RTLWrapper(child: WelcomeScreen()),
      AppConstants.routeLogin: (_) => const _RTLWrapper(child: LoginScreen()),
      AppConstants.routeSignup: (_) => const _RTLWrapper(child: SignupScreen()),
      // Protected routes - require authentication
      AppConstants.routeHome: (_) =>
          const _RTLWrapper(child: AuthGuard(child: HomeScreen())),
      AppConstants.routeScan: (_) =>
          const _RTLWrapper(child: AuthGuard(child: ScanScreen())),
      AppConstants.routeResult: (_) =>
          const _RTLWrapper(child: AuthGuard(child: ResultScreen())),
      AppConstants.routeReports: (_) =>
          const _RTLWrapper(child: AuthGuard(child: ReportsListScreen())),
    };
  }
}

/// Wrapper widget to apply RTL (Right-to-Left) text direction
/// Used for Arabic language support
class _RTLWrapper extends StatelessWidget {
  final Widget child;

  const _RTLWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return Directionality(textDirection: TextDirection.rtl, child: child);
  }
}
