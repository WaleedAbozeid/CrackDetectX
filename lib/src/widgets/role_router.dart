import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../store/app_state.dart';
import '../models/marketplace_full_models.dart';
import '../screens/home_screen.dart';
import '../screens/admin_dashboard_screen.dart';

/// Routes the user to the correct home screen based on their role.
///
/// Called after successful login/signup so each user type
/// lands on the experience designed for them.
///
/// Role → Screen:
/// - admin          → AdminDashboardScreen
/// - engineer       → HomeScreen  (Scan + Reports tabs)
/// - owner          → HomeScreen  (My Requests tab visible)
/// - companyAdmin   → HomeScreen  (Marketplace tab visible)
/// - companyAccountant → HomeScreen (Marketplace tab visible)
class RoleRouter extends StatelessWidget {
  const RoleRouter({super.key});

  @override
  Widget build(BuildContext context) {
    final role = context.read<AppState>().currentUserRole;

    return switch (role) {
      UserRole.admin => const AdminDashboardScreen(),
      _ => const HomeScreen(),
    };
  }
}
