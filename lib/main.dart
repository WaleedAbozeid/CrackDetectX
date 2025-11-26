import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'src/store/app_state.dart';
import 'src/screens/welcome_screen.dart';
import 'src/design/colors.dart';
// typography token is applied via GoogleFonts in ThemeData

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
            textTheme: GoogleFonts.cairoTextTheme(base.textTheme),
            appBarTheme: AppBarTheme(backgroundColor: AppColors.primary500, elevation: 0),
            colorScheme: base.colorScheme.copyWith(primary: AppColors.primary500),
          ),
          home: const Directionality(
            textDirection: TextDirection.rtl,
            child: WelcomeScreen(),
          ),
        );
      }),
    );
  }
}
