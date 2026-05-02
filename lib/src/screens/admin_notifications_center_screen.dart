import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../design/colors.dart';
import '../design/spacing.dart';
import '../design/typography.dart';
import '../store/app_state.dart';

class AdminNotificationsCenterScreen extends StatelessWidget {
  const AdminNotificationsCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.neutral800,
        title: const Text('Notifications Center'),
      ),
      body: Consumer<AppState>(
        builder: (context, appState, _) {
          final notifications = appState.allNotifications
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

          if (notifications.isEmpty) {
            return const Center(child: Text('No notifications found'));
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
                  trailing: _NotificationBadge(isRead: n.isRead),
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

class _NotificationBadge extends StatelessWidget {
  final bool isRead;

  const _NotificationBadge({required this.isRead});

  @override
  Widget build(BuildContext context) {
    return isRead
        ? const Icon(Icons.check_circle_outline)
        : const Icon(Icons.circle, size: 12);
  }
}

