import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/admin_guard.dart';
import '../store/app_state.dart';
import '../screens/welcome_screen.dart';

/// Guards admin routes.
/// Currently uses a demo baseline from [AdminGuard] until backend RBAC is wired.
class AdminAuthGuard extends StatelessWidget {
  final Widget child;

  const AdminAuthGuard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    if (!AdminGuard.isAdmin(appState)) {
      // Redirect to welcome/login flow when admin access is denied.
      return const WelcomeScreen();
    }

    return child;
  }
}

