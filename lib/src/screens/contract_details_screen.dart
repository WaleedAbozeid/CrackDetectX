import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../store/app_state.dart';
import '../models/marketplace_models.dart';
import '../design/colors.dart';
import '../design/spacing.dart';
import '../design/radius.dart';
import '../design/typography.dart';

class ContractDetailsScreen extends StatelessWidget {
  final String contractId;

  const ContractDetailsScreen({super.key, required this.contractId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contract Details'),
        backgroundColor: AppColors.primary900,
      ),
      body: Consumer<AppState>(
        builder: (context, appState, _) {
          final contract = appState.getContractById(contractId);

          if (contract == null) {
            return const Center(child: Text('Contract not found'));
          }

          final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
          final isOwner = contract.ownerId == currentUserId;
          final isEngineer = contract.engineerId == currentUserId;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatusCard(contract),
                const SizedBox(height: AppSpacing.lg),
                _buildContractInfo(contract),
                const SizedBox(height: AppSpacing.lg),
                _buildPaymentInfo(contract),
                const SizedBox(height: AppSpacing.lg),

                // Engineer Actions
                if (isEngineer &&
                    contract.status == ContractStatus.inProgress) ...[
                  _buildMarkCompleteButton(context, appState, contract),
                  const SizedBox(height: AppSpacing.md),
                ],

                // Owner Actions
                if (isOwner &&
                    contract.status == ContractStatus.pendingCompletion) ...[
                  _buildOwnerApprovalSection(context, appState, contract),
                  const SizedBox(height: AppSpacing.md),
                ],

                // Completion Notes
                if (contract.completionNotes != null) ...[
                  _buildCompletionNotes(contract),
                  const SizedBox(height: AppSpacing.md),
                ],

                // Owner Feedback
                if (contract.ownerFeedback != null) ...[
                  _buildOwnerFeedback(contract),
                  const SizedBox(height: AppSpacing.md),
                ],

                // Dispute Button (for active/inProgress contracts)
                if ((isOwner || isEngineer) &&
                    (contract.status == ContractStatus.active ||
                        contract.status == ContractStatus.inProgress)) ...[
                  _buildDisputeButton(
                    context,
                    appState,
                    contract,
                    currentUserId,
                    isOwner,
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],

                // Review Section (for completed contracts)
                if (contract.status == ContractStatus.completed) ...[
                  _buildReviewSection(
                    context,
                    appState,
                    contract,
                    currentUserId,
                    isOwner,
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusCard(Contract contract) {
    Color statusColor;
    String statusText;

    switch (contract.status) {
      case ContractStatus.draft:
        statusColor = Colors.grey;
        statusText = 'Draft';
        break;
      case ContractStatus.active:
        statusColor = Colors.blue;
        statusText = 'Active';
        break;
      case ContractStatus.inProgress:
        statusColor = Colors.orange;
        statusText = 'In Progress';
        break;
      case ContractStatus.pendingCompletion:
        statusColor = Colors.purple;
        statusText = 'Pending Approval';
        break;
      case ContractStatus.completed:
        statusColor = Colors.green;
        statusText = 'Completed';
        break;
      case ContractStatus.disputed:
        statusColor = Colors.red;
        statusText = 'Disputed';
        break;
      case ContractStatus.cancelled:
        statusColor = Colors.black54;
        statusText = 'Cancelled';
        break;
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.r8),
        border: Border.all(color: statusColor, width: 2),
      ),
      child: Row(
        children: [
          Icon(Icons.assignment, color: statusColor, size: 32),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contract Status',
                  style: AppTypography.caption.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  statusText,
                  style: AppTypography.h3.copyWith(color: statusColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContractInfo(Contract contract) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Contract Information', style: AppTypography.h3),
            const Divider(),
            _infoRow('Engineer', contract.engineerName),
            _infoRow('Duration', '${contract.agreedDuration} days'),
            _infoRow('Warranty', '${contract.warrantyMonths} months'),
            if (contract.methodology != null)
              _infoRow('Methodology', contract.methodology!),
            _infoRow(
              'Created At',
              '${contract.createdAt.day}/${contract.createdAt.month}/${contract.createdAt.year}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentInfo(Contract contract) {
    return Card(
      color: AppColors.successLight.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.account_balance_wallet,
                  color: AppColors.successGreen,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text('Payment Details', style: AppTypography.h3),
              ],
            ),
            const Divider(),
            _infoRow(
              'Agreed Price',
              'EGP ${contract.agreedPrice.toStringAsFixed(2)}',
            ),
            if (contract.status == ContractStatus.active ||
                contract.status == ContractStatus.inProgress) ...[
              const SizedBox(height: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lock, color: Colors.blue, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Funds held in Escrow',
                      style: AppTypography.caption.copyWith(color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ],
            if (contract.status == ContractStatus.completed) ...[
              const SizedBox(height: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Payment Released',
                      style: AppTypography.caption.copyWith(
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: AppTypography.bodyText.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(child: Text(value, style: AppTypography.bodyText)),
        ],
      ),
    );
  }

  Widget _buildMarkCompleteButton(
    BuildContext context,
    AppState appState,
    Contract contract,
  ) {
    return ElevatedButton.icon(
      onPressed: () => _showMarkCompleteDialog(context, appState, contract.id),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.successGreen,
        minimumSize: const Size(double.infinity, 48),
      ),
      icon: const Icon(Icons.check_circle_outline),
      label: const Text('Mark Project as Complete'),
    );
  }

  Widget _buildOwnerApprovalSection(
    BuildContext context,
    AppState appState,
    Contract contract,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            appState.approveCompletion(contract.id);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Project approved! Payment released.'),
                backgroundColor: Colors.green,
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.successGreen,
            minimumSize: const Size(double.infinity, 48),
          ),
          icon: const Icon(Icons.done_all),
          label: const Text('Approve Completion'),
        ),
        const SizedBox(height: AppSpacing.sm),
        OutlinedButton.icon(
          onPressed: () => _showRevisionsDialog(context, appState, contract.id),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.orange,
            minimumSize: const Size(double.infinity, 48),
          ),
          icon: const Icon(Icons.edit),
          label: const Text('Request Revisions'),
        ),
      ],
    );
  }

  Widget _buildCompletionNotes(Contract contract) {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.note, color: Colors.blue),
                const SizedBox(width: 8),
                Text('Completion Notes', style: AppTypography.h4),
              ],
            ),
            const SizedBox(height: 8),
            Text(contract.completionNotes!, style: AppTypography.bodyText),
          ],
        ),
      ),
    );
  }

  Widget _buildOwnerFeedback(Contract contract) {
    return Card(
      color: Colors.orange.shade50,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.feedback, color: Colors.orange),
                const SizedBox(width: 8),
                Text('Owner Feedback', style: AppTypography.h4),
              ],
            ),
            const SizedBox(height: 8),
            Text(contract.ownerFeedback!, style: AppTypography.bodyText),
          ],
        ),
      ),
    );
  }

  Widget _buildDisputeButton(
    BuildContext context,
    AppState appState,
    Contract contract,
    String currentUserId,
    bool isOwner,
  ) {
    return OutlinedButton.icon(
      onPressed: () {
        // Navigate to Create Dispute Screen
        Navigator.pushNamed(
          context,
          '/create_dispute',
          arguments: {
            'contractId': contract.id,
            'raisedBy': currentUserId,
            'raisedByName': isOwner ? 'Owner' : contract.engineerName,
          },
        );
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.red,
        minimumSize: const Size(double.infinity, 48),
      ),
      icon: const Icon(Icons.report_problem),
      label: const Text('Raise a Dispute'),
    );
  }

  Widget _buildReviewSection(
    BuildContext context,
    AppState appState,
    Contract contract,
    String currentUserId,
    bool isOwner,
  ) {
    final revieweeId = isOwner ? contract.engineerId : contract.ownerId;
    final revieweeName = isOwner ? contract.engineerName : 'Owner';

    // Check if review already exists
    final existingReview = appState.reviews.any(
      (r) => r.contractId == contract.id && r.reviewerId == currentUserId,
    );

    if (existingReview) {
      return Card(
        color: Colors.green.shade50,
        child: const Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text('You have already submitted a review for this project.'),
            ],
          ),
        ),
      );
    }

    return ElevatedButton.icon(
      onPressed: () => _showReviewDialog(
        context,
        appState,
        contract.id,
        currentUserId,
        isOwner ? 'You' : contract.engineerName,
        revieweeId,
        revieweeName,
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black87,
        minimumSize: const Size(double.infinity, 48),
      ),
      icon: const Icon(Icons.star),
      label: const Text('Submit Review'),
    );
  }

  void _showMarkCompleteDialog(
    BuildContext context,
    AppState appState,
    String contractId,
  ) {
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mark as Complete'),
        content: TextField(
          controller: notesController,
          decoration: const InputDecoration(
            labelText: 'Completion Notes',
            hintText: 'Describe what was completed...',
            border: OutlineInputBorder(),
          ),
          maxLines: 4,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              appState.markProjectComplete(contractId, notesController.text);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Marked as complete! Awaiting owner approval.'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _showRevisionsDialog(
    BuildContext context,
    AppState appState,
    String contractId,
  ) {
    final feedbackController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Request Revisions'),
        content: TextField(
          controller: feedbackController,
          decoration: const InputDecoration(
            labelText: 'Revision Feedback',
            hintText: 'What needs to be fixed or improved?',
            border: OutlineInputBorder(),
          ),
          maxLines: 4,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              appState.requestRevisions(contractId, feedbackController.text);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Revision request sent to engineer.'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _showReviewDialog(
    BuildContext context,
    AppState appState,
    String contractId,
    String reviewerId,
    String reviewerName,
    String revieweeId,
    String revieweeName,
  ) {
    double rating = 5.0;
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Review $revieweeName'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Rating: ${rating.toStringAsFixed(1)}',
                style: AppTypography.h4,
              ),
              Slider(
                value: rating,
                min: 1,
                max: 5,
                divisions: 8,
                label: rating.toStringAsFixed(1),
                onChanged: (value) => setState(() => rating = value),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: commentController,
                decoration: const InputDecoration(
                  labelText: 'Comment',
                  hintText: 'Share your experience...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                appState.submitReview(
                  contractId: contractId,
                  reviewerId: reviewerId,
                  reviewerName: reviewerName,
                  revieweeId: revieweeId,
                  revieweeName: revieweeName,
                  rating: rating,
                  comment: commentController.text,
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Review submitted successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Submit Review'),
            ),
          ],
        ),
      ),
    );
  }
}
