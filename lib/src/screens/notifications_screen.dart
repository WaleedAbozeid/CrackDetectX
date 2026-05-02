import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../design/colors.dart';
import '../design/spacing.dart';
import '../design/typography.dart';
import '../widgets/app_top_bar.dart';
import '../store/app_state.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        appBar: AppTopBar(
          title: 'Notifications',
          onBack: () => Navigator.pop(context),
        ),
        body: const Center(
          child: Text('Please log in to view notifications'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: AppTopBar(
        title: 'Notifications',
        onBack: () => Navigator.pop(context),
        backgroundColor: AppColors.white,
      ),
      body: Consumer<AppState>(
        builder: (context, appState, _) {
          final notifications = appState.notificationsForUser(user.uid);

          if (notifications.isEmpty) {
            return const Center(
              child: Text('No notifications yet'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final n = notifications[index];

              return Card(
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                child: ListTile(
                  title: Text(
                    n.title,
                    style: AppTypography.h4,
                  ),
                  subtitle: Text(
                    n.body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: n.isRead
                      ? const Icon(Icons.check_circle_outline)
                      : const Icon(Icons.circle, size: 12),
                  onTap: () {
                    if (!n.isRead) {
                      appState.markNotificationRead(n.id);
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

