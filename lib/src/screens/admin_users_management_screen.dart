import 'package:flutter/material.dart';

/// Placeholder screen for users management.
/// The full users management flow will be implemented once backend RBAC APIs are wired.
class AdminUsersManagementScreen extends StatelessWidget {
  const AdminUsersManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users Management'),
      ),
      body: const Center(
        child: Text('Users management is not implemented yet'),
      ),
    );
  }
}

