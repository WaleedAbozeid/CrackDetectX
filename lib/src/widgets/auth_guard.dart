import 'package:flutter/material.dart';
import '../services/token_storage_service.dart';
import '../screens/welcome_screen.dart';

/// Guards routes that require authentication.
///
/// Checks for a valid access token in [TokenStorageService].
/// If no token is found, redirects to [WelcomeScreen].
///
/// Note: Token validity is enforced at the API layer via
/// [RefreshInterceptor] — this guard only checks presence.
class AuthGuard extends StatelessWidget {
  final Widget child;

  const AuthGuard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: TokenStorageService.instance.accessToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final token = snapshot.data;
        if (token == null || token.isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const WelcomeScreen()),
              (route) => false,
            );
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return child;
      },
    );
  }
}
