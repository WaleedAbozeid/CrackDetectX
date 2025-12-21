import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../design/colors.dart';
import '../design/typography.dart';
import '../design/spacing.dart';
import '../design/radius.dart';
import '../store/app_state.dart';
import '../models/marketplace_models.dart';

class MyBidsScreen extends StatelessWidget {
  const MyBidsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Bids')),
        body: const Center(child: Text('Please log in to view your bids')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary900),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'My Bids',
          style: AppTypography.h3.copyWith(color: AppColors.primary900),
        ),
      ),
      body: Consumer<AppState>(
        builder: (context, appState, _) {
          final allBids = appState.bids
              .where((bid) => bid.engineerId == user.uid)
              .toList();

          if (allBids.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 80,
                    color: AppColors.grey400,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'No bids yet',
                    style: AppTypography.h4.copyWith(color: AppColors.grey600),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Start bidding on projects to see them here',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.grey500,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: allBids.length,
            itemBuilder: (context, index) {
              final bid = allBids[index];
              final request = appState.marketRequests
                  .where((r) => r.id == bid.requestId)
                  .firstOrNull;

              return _BidCard(bid: bid, request: request);
            },
          );
        },
      ),
    );
  }
}

class _BidCard extends StatelessWidget {
  final Bid bid;
  final RepairRequest? request;

  const _BidCard({required this.bid, required this.request});

  @override
  Widget build(BuildContext context) {
    final isAccepted = bid.status == BidStatus.accepted;
    final isRejected = bid.status == BidStatus.rejected;
    final isPending = bid.status == BidStatus.pending;

    Color statusColor;
    String statusLabel;
    IconData statusIcon;

    if (isAccepted) {
      statusColor = Colors.green.shade700;
      statusLabel = 'Accepted';
      statusIcon = Icons.check_circle;
    } else if (isRejected) {
      statusColor = AppColors.dangerRed;
      statusLabel = 'Rejected';
      statusIcon = Icons.cancel;
    } else {
      statusColor = Colors.orange.shade700;
      statusLabel = 'Pending';
      statusIcon = Icons.schedule;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.r12),
        side: BorderSide(
          color: isAccepted
              ? Colors.green.shade300
              : isRejected
              ? AppColors.grey300
              : AppColors.grey200,
          width: isAccepted ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    request?.title ?? 'Request not found',
                    style: AppTypography.h4,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.r8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 14, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        statusLabel,
                        style: AppTypography.caption.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Bid Details
            Row(
              children: [
                _InfoChip(
                  icon: Icons.attach_money,
                  label: 'EGP ${bid.price.toStringAsFixed(0)}',
                ),
                const SizedBox(width: AppSpacing.sm),
                _InfoChip(
                  icon: Icons.schedule,
                  label: '${bid.durationDays} days',
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),

            Text(
              bid.proposal,
              style: AppTypography.bodySmall.copyWith(color: AppColors.grey700),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(AppRadius.r8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.grey600),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTypography.caption.copyWith(color: AppColors.grey700),
          ),
        ],
      ),
    );
  }
}
