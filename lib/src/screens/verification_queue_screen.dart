import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../store/app_state.dart';
import '../models/admin_models.dart';
import '../design/colors.dart';
import '../design/spacing.dart';
import '../design/typography.dart';
import '../design/radius.dart';

class VerificationQueueScreen extends StatelessWidget {
  const VerificationQueueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final pendingRequests = appState.getPendingVerifications();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification Queue'),
        backgroundColor: AppColors.primary900,
      ),
      body: pendingRequests.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: pendingRequests.length,
              itemBuilder: (context, index) {
                return _buildVerificationCard(
                  context,
                  pendingRequests[index],
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
          Icon(Icons.verified_user, size: 80, color: AppColors.neutral400),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No Pending Verifications',
            style: AppTypography.h3.copyWith(color: AppColors.neutral600),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'All verification requests have been processed',
            style: AppTypography.body.copyWith(color: AppColors.neutral500),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationCard(
    BuildContext context,
    VerificationRequest request,
    AppState appState,
  ) {
    final isEngineer = request.userRole == 'engineer';

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
                CircleAvatar(
                  backgroundColor: isEngineer
                      ? AppColors.primary900
                      : AppColors.infoBlue,
                  child: Icon(
                    isEngineer ? Icons.engineering : Icons.business,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isEngineer
                            ? 'Engineer Verification'
                            : 'Company Verification',
                        style: AppTypography.h4,
                      ),
                      Text(
                        'User ID: ${request.userId}',
                        style: AppTypography.caption,
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(request.status),
              ],
            ),

            const SizedBox(height: AppSpacing.md),
            const Divider(),
            const SizedBox(height: AppSpacing.md),

            // Engineer Details
            if (isEngineer) ...[
              _buildDetailRow(
                'Syndicate Number',
                request.syndicateNumber ?? 'N/A',
              ),
              _buildDetailRow(
                'Years of Experience',
                request.yearsOfExperience?.toString() ?? 'N/A',
              ),
              _buildDetailRow(
                'Certificates',
                '${request.certificateUrls.length} uploaded',
              ),
              _buildDetailRow(
                'Portfolio',
                '${request.portfolioUrls.length} items',
              ),
            ],

            // Company Details
            if (!isEngineer) ...[
              _buildDetailRow('Trade License', request.tradeLicense ?? 'N/A'),
              _buildDetailRow('Tax ID', request.taxId ?? 'N/A'),
            ],

            const SizedBox(height: AppSpacing.md),

            // Submission Date
            _buildDetailRow('Submitted', _formatDate(request.submittedAt)),

            const SizedBox(height: AppSpacing.md),
            const Divider(),
            const SizedBox(height: AppSpacing.md),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        _showRejectDialog(context, request, appState),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.errorRed,
                      side: BorderSide(color: AppColors.errorRed),
                      minimumSize: const Size(0, 44),
                    ),
                    icon: const Icon(Icons.cancel),
                    label: const Text('Reject'),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        _showApproveDialog(context, request, appState),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.successGreen,
                      minimumSize: const Size(0, 44),
                    ),
                    icon: const Icon(Icons.check_circle),
                    label: const Text('Approve'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: AppTypography.body.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.neutral600,
              ),
            ),
          ),
          Expanded(child: Text(value, style: AppTypography.body)),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(VerificationRequestStatus status) {
    Color color;
    String text;

    switch (status) {
      case VerificationRequestStatus.pending:
        color = AppColors.warningYellow;
        text = 'Pending';
        break;
      case VerificationRequestStatus.underReview:
        color = AppColors.infoBlue;
        text = 'Under Review';
        break;
      case VerificationRequestStatus.approved:
        color = AppColors.successGreen;
        text = 'Approved';
        break;
      case VerificationRequestStatus.rejected:
        color = AppColors.errorRed;
        text = 'Rejected';
        break;
      case VerificationRequestStatus.revoked:
        color = AppColors.neutral600;
        text = 'Revoked';
        break;
      case VerificationRequestStatus.documentsRequested:
        color = AppColors.warningOrange;
        text = 'Docs Requested';
        break;
    }

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
        text,
        style: AppTypography.caption.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showApproveDialog(
    BuildContext context,
    VerificationRequest request,
    AppState appState,
  ) {
    TrustLevel selectedTrustLevel = TrustLevel.junior;
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Approve Verification'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Select Trust Level:', style: AppTypography.h5),
                    const SizedBox(height: AppSpacing.sm),
                    DropdownButton<TrustLevel>(
                      value: selectedTrustLevel,
                      isExpanded: true,
                      items: TrustLevel.values
                          .where((level) => level != TrustLevel.none)
                          .map((level) {
                            return DropdownMenuItem(
                              value: level,
                              child: Text(_getTrustLevelName(level)),
                            );
                          })
                          .toList(),
                      onChanged: (TrustLevel? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedTrustLevel = newValue;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text('Review Notes (Optional):', style: AppTypography.h5),
                    const SizedBox(height: AppSpacing.sm),
                    TextField(
                      controller: notesController,
                      decoration: const InputDecoration(
                        hintText: 'Add any notes about this approval...',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Mock admin user
                    appState.approveVerification(
                      requestId: request.id,
                      adminId: 'admin_1',
                      adminName: 'System Admin',
                      trustLevel: selectedTrustLevel,
                      reviewNotes: notesController.text.trim().isEmpty
                          ? null
                          : notesController.text.trim(),
                    );

                    Navigator.pop(dialogContext);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Verification approved successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.successGreen,
                  ),
                  child: const Text('Approve'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showRejectDialog(
    BuildContext context,
    VerificationRequest request,
    AppState appState,
  ) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Reject Verification'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Rejection Reason:', style: AppTypography.h5),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: reasonController,
                decoration: const InputDecoration(
                  hintText: 'Provide a clear reason for rejection...',
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
                if (reasonController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please provide a rejection reason'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                // Mock admin user
                appState.rejectVerification(
                  requestId: request.id,
                  adminId: 'admin_1',
                  adminName: 'System Admin',
                  rejectionReason: reasonController.text.trim(),
                );

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Verification rejected'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.errorRed,
              ),
              child: const Text('Reject'),
            ),
          ],
        );
      },
    );
  }

  String _getTrustLevelName(TrustLevel level) {
    switch (level) {
      case TrustLevel.none:
        return 'None';
      case TrustLevel.junior:
        return 'Junior (<2 years)';
      case TrustLevel.mid:
        return 'Mid (2-5 years)';
      case TrustLevel.senior:
        return 'Senior (5-10 years)';
      case TrustLevel.expert:
        return 'Expert (10+ years)';
    }
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
