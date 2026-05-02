import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../design/colors.dart';
import '../design/spacing.dart';
import '../design/typography.dart';
import '../design/radius.dart';
import '../models/communication_models.dart';
import '../store/app_state.dart';

class AdminSupportTicketsScreen extends StatelessWidget {
  const AdminSupportTicketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary900,
        title: const Text('Support Tickets'),
      ),
      body: Consumer<AppState>(
        builder: (context, appState, _) {
          final openTickets = appState.supportTickets
              .where((t) => t.status == SupportTicketStatus.open)
              .toList()
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

          if (openTickets.isEmpty) {
            return const Center(child: Text('No open tickets'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: openTickets.length,
            itemBuilder: (context, index) {
              final t = openTickets[index];
              return Card(
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.r12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.subject,
                        style: AppTypography.h4,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        t.description,
                        style: AppTypography.bodySmall,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _showResolveDialog(
                                context,
                                appState,
                                t,
                              ),
                              icon: const Icon(Icons.check_circle_outline),
                              label: const Text('Resolve'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showResolveDialog(
    BuildContext context,
    AppState appState,
    SupportTicket ticket,
  ) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Resolve Ticket'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Resolution note',
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final note = controller.text.trim();
                if (note.isEmpty) return;
                appState.resolveSupportTicket(
                  ticket.id,
                  adminName: 'System Admin',
                  resolutionNote: note,
                );
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Ticket resolved successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}

