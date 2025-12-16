import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/welcome_screen.dart';

/// Widget that protects routes requiring authentication
/// 
/// If user is not logged in, redirects to WelcomeScreen
/// If user is logged in, shows the protected child widget
class AuthGuard extends StatelessWidget {
  final Widget child;

  const AuthGuard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // If user is not logged in, redirect to WelcomeScreen
    if (user == null) {
      // Use Future.microtask to avoid build-time navigation
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const WelcomeScreen()),
          (route) => false,
        );
      });
      // Show loading while redirecting
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // User is logged in, show protected content
    return child;
  }
}

