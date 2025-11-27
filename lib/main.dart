import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/store/app_state.dart';
import 'src/screens/welcome_screen.dart';
import 'src/screens/login_screen.dart';
import 'src/screens/signup_screen.dart';
import 'src/screens/home_screen.dart';
import 'src/design/colors.dart';
import 'src/design/typography.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: Builder(builder: (context) {
        final base = ThemeData.light();
        return MaterialApp(
          title: 'CrackDetectX',
          theme: base.copyWith(
            primaryColor: AppColors.primary500,
            scaffoldBackgroundColor: AppColors.background,
            // Use local Cairo font instead of google_fonts to avoid loading issues
            textTheme: base.textTheme.apply(
              fontFamily: AppTypography.fontFamily,
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: AppColors.primary500,
              elevation: 0,
            ),
            colorScheme: base.colorScheme.copyWith(
              primary: AppColors.primary500,
            ),
          ),
          home: const Directionality(
            textDirection: TextDirection.rtl,
            child: WelcomeScreen(),
          ),
          routes: {
            '/welcome': (_) => const Directionality(
              textDirection: TextDirection.rtl,
              child: WelcomeScreen(),
            ),
            '/login': (_) => const Directionality(
              textDirection: TextDirection.rtl,
              child: LoginScreen(),
            ),
            '/signup': (_) => const Directionality(
              textDirection: TextDirection.rtl,
              child: SignupScreen(),
            ),
            '/home': (_) => const Directionality(
              textDirection: TextDirection.rtl,
              child: HomeScreen(),
            ),
          },
        );
      }),
    );
  }
}
