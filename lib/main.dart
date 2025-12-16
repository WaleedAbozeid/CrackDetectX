import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'src/core/constants.dart';
import 'src/store/app_state.dart';
import 'src/screens/welcome_screen.dart';
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
      child: Builder(
        builder: (context) {
          final baseTheme = ThemeData.light(useMaterial3: true);
          
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: AppConstants.appName,
            theme: _buildTheme(baseTheme),
            home: const _RTLWrapper(child: _AuthWrapper()),
            routes: _buildRoutes(),
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
      colorScheme: baseTheme.colorScheme.copyWith(
        primary: AppColors.primary500,
        secondary: AppColors.secondary500,
      ),
    );
  }

  /// Builds the application routes with RTL support
  /// Protected routes (Home, Scan, Result, Reports) require authentication
  Map<String, WidgetBuilder> _buildRoutes() {
    return {
      AppConstants.routeWelcome: (_) => const _RTLWrapper(
        child: WelcomeScreen(),
      ),
      AppConstants.routeLogin: (_) => const _RTLWrapper(
        child: LoginScreen(),
      ),
      AppConstants.routeSignup: (_) => const _RTLWrapper(
        child: SignupScreen(),
      ),
      // Protected routes - require authentication
      AppConstants.routeHome: (_) => const _RTLWrapper(
        child: AuthGuard(child: HomeScreen()),
      ),
      AppConstants.routeScan: (_) => const _RTLWrapper(
        child: AuthGuard(child: ScanScreen()),
      ),
      AppConstants.routeResult: (_) => const _RTLWrapper(
        child: AuthGuard(child: ResultScreen()),
      ),
      AppConstants.routeReports: (_) => const _RTLWrapper(
        child: AuthGuard(child: ReportsListScreen()),
      ),
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: child,
    );
  }
}

/// Auth wrapper that checks if user is logged in
/// - If logged in → shows HomeScreen
/// - If not logged in → shows WelcomeScreen
class _AuthWrapper extends StatelessWidget {
  const _AuthWrapper();

  @override
  Widget build(BuildContext context) {
    // Check current user immediately (before StreamBuilder)
    final currentUser = FirebaseAuth.instance.currentUser;
    
    // If user is already logged in, show HomeScreen immediately
    if (currentUser != null) {
      return const HomeScreen();
    }

    // If no user, listen to auth state changes
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final user = snapshot.data;

        // If user logged in, go to HomeScreen
        if (user != null) {
          return const HomeScreen();
        }

        // If user is not logged in, go to WelcomeScreen
        return const WelcomeScreen();
      },
    );
  }
}
