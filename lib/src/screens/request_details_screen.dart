import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../design/colors.dart';
import '../design/typography.dart';
import '../design/spacing.dart';
import '../design/radius.dart';
import '../store/app_state.dart';
import '../models/marketplace_models.dart';

class RequestDetailsScreen extends StatelessWidget {
  final String requestId;

  const RequestDetailsScreen({super.key, required this.requestId});

  @override
  Widget build(BuildContext context) {
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
          'Project Details',
          style: AppTypography.h3.copyWith(color: AppColors.primary900),
        ),
      ),
      body: Consumer<AppState>(
        builder: (context, appState, _) {
          final request = appState.marketRequests
              .where((r) => r.id == requestId)
              .firstOrNull;

          if (request == null) {
            return const Center(child: Text('Request not found'));
          }

          final bids = appState.getBidsForRequest(requestId);

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Request Info Card
                Container(
                  width: double.infinity,
                  color: AppColors.white,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(request.title, style: AppTypography.h3),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        request.description,
                        style: AppTypography.bodyText.copyWith(
                          color: AppColors.grey700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: AppColors.grey500,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            request.location,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.grey600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // Bids Section
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('Received Bids', style: AppTypography.h4),
                          const SizedBox(width: AppSpacing.sm),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary500,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${bids.length}',
                              style: AppTypography.caption.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),

                      if (bids.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.xl),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(AppRadius.r12),
                            border: Border.all(color: AppColors.grey200),
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.inbox_outlined,
                                  size: 48,
                                  color: AppColors.grey400,
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  'No bids yet',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.grey500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        ...bids.map(
                          (bid) => _BidCard(
                            bid: bid,
                            canAccept:
                                request.status == RequestStatus.posted ||
                                request.status == RequestStatus.bidding,
                            onAccept: () =>
                                _acceptBid(context, appState, bid.id),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _acceptBid(BuildContext context, AppState appState, String bidId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Accept Bid'),
        content: const Text(
          'Are you sure you want to accept this bid? All other bids will be rejected.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              appState.acceptBid(bidId);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Bid accepted successfully!')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary500,
            ),
            child: const Text('Accept'),
          ),
        ],
      ),
    );
  }
}

class _BidCard extends StatelessWidget {
  final Bid bid;
  final bool canAccept;
  final VoidCallback onAccept;

  const _BidCard({
    required this.bid,
    required this.canAccept,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    final isAccepted = bid.status == BidStatus.accepted;
    final isRejected = bid.status == BidStatus.rejected;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.r12),
        border: Border.all(
          color: isAccepted
              ? Colors.green.shade300
              : isRejected
              ? AppColors.grey300
              : AppColors.grey200,
          width: isAccepted ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primary100,
                child: Text(
                  bid.engineerName[0].toUpperCase(),
                  style: AppTypography.h4.copyWith(color: AppColors.primary500),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(bid.engineerName, style: AppTypography.h4),
                    Text(
                      '${bid.durationDays} days',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.grey600,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'EGP ${bid.price.toStringAsFixed(0)}',
                style: AppTypography.h3.copyWith(color: AppColors.primary500),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            bid.proposal,
            style: AppTypography.bodySmall.copyWith(color: AppColors.grey700),
          ),
          if (canAccept && !isAccepted && !isRejected) ...[
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onAccept,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary500,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.r8),
                  ),
                ),
                child: const Text('Accept Bid'),
              ),
            ),
          ],
          if (isAccepted)
            Container(
              margin: const EdgeInsets.only(top: AppSpacing.md),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(AppRadius.r8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 16,
                    color: Colors.green.shade700,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Accepted',
                    style: AppTypography.caption.copyWith(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
