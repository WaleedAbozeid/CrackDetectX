import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../store/app_state.dart';
import '../models/marketplace_models.dart';
import '../design/colors.dart';
import '../design/spacing.dart';
import '../design/typography.dart';
import '../design/radius.dart';

class AdminDisputeResolutionScreen extends StatelessWidget {
  const AdminDisputeResolutionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final openDisputes = appState.disputes
        .where(
          (d) =>
              d.status == DisputeStatus.open ||
              d.status == DisputeStatus.underReview,
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dispute Resolution'),
        backgroundColor: AppColors.warningOrange,
      ),
      body: openDisputes.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: openDisputes.length,
              itemBuilder: (context, index) {
                return _buildDisputeCard(
                  context,
                  openDisputes[index],
                  appState,
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.gavel, size: 80, color: AppColors.neutral400),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No Active Disputes',
            style: AppTypography.h3.copyWith(color: AppColors.neutral600),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'All disputes have been resolved',
            style: AppTypography.body.copyWith(color: AppColors.neutral500),
          ),
        ],
      ),
    );
  }

  Widget _buildDisputeCard(
    BuildContext context,
    Dispute dispute,
    AppState appState,
  ) {
    // Get status color
    Color statusColor;
    switch (dispute.status) {
      case DisputeStatus.open:
        statusColor = AppColors.warningOrange;
        break;
      case DisputeStatus.underReview:
        statusColor = AppColors.infoBlue;
        break;
      default:
        statusColor = AppColors.neutral600;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.r12),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.warning, color: statusColor, size: 28),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(dispute.reason, style: AppTypography.h4),
                      Text(
                        'Raised by: ${dispute.raisedByName}',
                        style: AppTypography.caption,
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(dispute.status, statusColor),
              ],
            ),

            const SizedBox(height: AppSpacing.md),
            const Divider(),
            const SizedBox(height: AppSpacing.md),

            // Dispute Details
            Text('Contract ID:', style: AppTypography.caption),
            Text(dispute.contractId, style: AppTypography.body),

            const SizedBox(height: AppSpacing.sm),

            Text('Description:', style: AppTypography.caption),
            Text(dispute.description, style: AppTypography.body),

            const SizedBox(height: AppSpacing.sm),

            Text('Created:', style: AppTypography.caption),
            Text(_formatDate(dispute.createdAt), style: AppTypography.body),

            const SizedBox(height: AppSpacing.md),
            const Divider(),
            const SizedBox(height: AppSpacing.md),

            // Admin Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showResolutionDialog(
                      context,
                      dispute,
                      'favor_engineer',
                      appState,
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary900,
                      minimumSize: const Size(0, 44),
                    ),
                    icon: const Icon(Icons.engineering),
                    label: const Text('Favor Engineer'),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showResolutionDialog(
                      context,
                      dispute,
                      'favor_owner',
                      appState,
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.infoBlue,
                      minimumSize: const Size(0, 44),
                    ),
                    icon: const Icon(Icons.person),
                    label: const Text('Favor Owner'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showResolutionDialog(
                  context,
                  dispute,
                  'partial_resolution',
                  appState,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.successGreen,
                  minimumSize: const Size(0, 44),
                ),
                icon: const Icon(Icons.balance),
                label: const Text('Partial Resolution'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(dynamic status, Color color) {
    String text = status.toString().split('.').last;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppRadius.r4),
        border: Border.all(color: color),
      ),
      child: Text(
        text.toUpperCase(),
        style: AppTypography.caption.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showResolutionDialog(
    BuildContext context,
    Dispute dispute,
    String resolutionType,
    AppState appState,
  ) {
    final resolutionNoteController = TextEditingController();

    String dialogTitle;
    String dialogMessage;
    Icon dialogIcon;

    switch (resolutionType) {
      case 'favor_engineer':
        dialogTitle = 'Resolve in Favor of Engineer';
        dialogMessage =
            'Funds will be released to the engineer. Provide reasoning:';
        dialogIcon = Icon(
          Icons.engineering,
          color: AppColors.primary900,
          size: 48,
        );
        break;
      case 'favor_owner':
        dialogTitle = 'Resolve in Favor of Owner';
        dialogMessage =
            'Funds will be refunded to the owner. Provide reasoning:';
        dialogIcon = Icon(Icons.person, color: AppColors.infoBlue, size: 48);
        break;
      case 'partial_resolution':
        dialogTitle = 'Partial Resolution';
        dialogMessage = 'Funds will be split. Provide split details:';
        dialogIcon = Icon(
          Icons.balance,
          color: AppColors.successGreen,
          size: 48,
        );
        break;
      default:
        return;
    }

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Column(
            children: [
              dialogIcon,
              const SizedBox(height: AppSpacing.sm),
              Text(dialogTitle, textAlign: TextAlign.center),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(dialogMessage, style: AppTypography.body),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: resolutionNoteController,
                decoration: const InputDecoration(
                  hintText: 'Explain your decision...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (resolutionNoteController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please provide resolution notes'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                final notes = resolutionNoteController.text.trim();
                appState.resolveDispute(
                  disputeId: dispute.id,
                  resolutionType: resolutionType,
                  notes: notes,
                );

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Dispute resolved: $dialogTitle'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.successGreen,
              ),
              child: const Text('Confirm Resolution'),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
