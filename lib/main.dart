import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/core/api_client.dart';
import 'src/core/constants.dart';
import 'src/store/app_state.dart';
import 'package:crackdetectx/l10n/app_localizations.dart';
import 'src/screens/splash_screen.dart';
import 'src/screens/welcome_screen.dart';
import 'src/screens/login_screen.dart';
import 'src/screens/signup_screen.dart';
import 'src/screens/home_screen.dart';
import 'src/screens/scan_screen.dart';
import 'src/screens/result_screen.dart';
import 'src/screens/reports_list_screen.dart';
import 'src/screens/onboarding_screen.dart';
import 'src/screens/select_building_screen.dart';
import 'src/screens/add_building_screen.dart';
import 'src/screens/annotate_screen.dart';
import 'src/widgets/auth_guard.dart';
import 'src/design/colors.dart';
import 'src/design/typography.dart';
import 'src/screens/admin_dashboard_screen.dart';
import 'src/screens/admin_dispute_resolution_screen.dart';
import 'src/screens/verification_queue_screen.dart';
import 'src/screens/system_config_screen.dart';
import 'src/screens/admin_users_management_screen.dart';
import 'src/widgets/admin_auth_guard.dart';
import 'src/screens/create_dispute_screen.dart';
import 'src/screens/notifications_screen.dart';
import 'src/screens/admin_support_tickets_screen.dart';
import 'src/screens/admin_notifications_center_screen.dart';

/// Main entry point for CrackDetectX application
Future<void> main() async {
  // Ensure Flutter bindings are initialized before using any plugins
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the HTTP client (Dio + interceptors)
  await ApiClient.instance.init();

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
          final appState = context.watch<AppState>();
          final baseTheme = ThemeData.light(useMaterial3: true);
          
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: AppConstants.appName,
            theme: _buildTheme(baseTheme),
            darkTheme: _buildDarkTheme(ThemeData.dark(useMaterial3: true)),
            themeMode: appState.themeMode,
            locale: appState.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            initialRoute: AppConstants.routeSplash,
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
      colorScheme: baseTheme.colorScheme.copyWith(
        primary: AppColors.primary500,
        secondary: AppColors.secondary500,
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
      AppConstants.routeSplash: (_) => const _RTLWrapper(
        child: SplashScreen(),
      ),
      AppConstants.routeOnboarding: (_) => const _RTLWrapper(
        child: OnboardingScreen(),
      ),
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
      AppConstants.routeSelectBuilding: (_) => const _RTLWrapper(
        child: AuthGuard(child: SelectBuildingScreen()),
      ),
      AppConstants.routeAddBuilding: (_) => const _RTLWrapper(
        child: AuthGuard(child: AddBuildingScreen()),
      ),
      AppConstants.routeAnnotate: (context) {
        final args = ModalRoute.of(context)?.settings.arguments;
        final map = (args is Map<String, dynamic>)
            ? args
            : const <String, dynamic>{};
        return _RTLWrapper(
          child: AuthGuard(
            child: AnnotateScreen(
              reportId: map['reportId']?.toString() ?? '',
              imagePath: map['imagePath']?.toString() ?? '',
            ),
          ),
        );
      },

      // ==================== Admin (Demo) Routes ====================
      // Admin routes are guarded by AdminAuthGuard.
      '/admin/dashboard': (_) => const _RTLWrapper(
            child: AdminAuthGuard(child: AdminDashboardScreen()),
          ),
      '/admin/verification-queue': (_) => const _RTLWrapper(
            child: AdminAuthGuard(child: VerificationQueueScreen()),
          ),
      '/admin/disputes': (_) => const _RTLWrapper(
            child:
                AdminAuthGuard(child: AdminDisputeResolutionScreen()),
          ),
      '/admin/users': (_) => const _RTLWrapper(
            child:
                AdminAuthGuard(child: AdminUsersManagementScreen()),
          ),
      '/admin/system-config': (_) => const _RTLWrapper(
            child: AdminAuthGuard(child: SystemConfigScreen()),
          ),

      '/admin/tickets': (_) => const _RTLWrapper(
            child: AdminAuthGuard(child: AdminSupportTicketsScreen()),
          ),
      '/admin/notifications': (_) => const _RTLWrapper(
            child: AdminAuthGuard(child: AdminNotificationsCenterScreen()),
          ),

      '/notifications': (_) => const _RTLWrapper(
            child: AuthGuard(child: NotificationsScreen()),
          ),

      // ==================== Marketplace Contracts ====================
      // ContractDetailsScreen navigates to this route with arguments.
      '/create_dispute': (context) {
        final args = ModalRoute.of(context)?.settings.arguments;
        final map = (args is Map<String, dynamic>) ? args : const <String, dynamic>{};

        final contractId = map['contractId']?.toString() ?? '';
        final raisedBy = map['raisedBy']?.toString() ?? '';
        final raisedByName = map['raisedByName']?.toString() ?? '';

        return _RTLWrapper(
          child: CreateDisputeScreen(
            contractId: contractId,
            raisedBy: raisedBy,
            raisedByName: raisedByName,
          ),
        );
      },
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
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: child,
    );
  }
}

// NOTE: `_AuthWrapper` was removed because `MaterialApp` now relies on
// `initialRoute` + `routes` (including `/`), and the auth redirect is handled
// by the route widgets themselves.
