import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../design/colors.dart';
import '../design/typography.dart';
import '../design/spacing.dart';
import '../design/radius.dart';
import '../store/app_state.dart';
import '../models/marketplace_models.dart';
import '../repositories/marketplace_repository.dart';
import '../core/api_exception.dart';
import 'request_details_screen.dart';

class MyRequestsScreen extends StatefulWidget {
  const MyRequestsScreen({super.key});

  @override
  State<MyRequestsScreen> createState() => _MyRequestsScreenState();
}

class _MyRequestsScreenState extends State<MyRequestsScreen> {
  bool _isLoading = false;
  String? _errorMsg;

  @override
  void initState() {
    super.initState();
    _loadMyRequests();
  }

  Future<void> _loadMyRequests() async {
    setState(() { _isLoading = true; _errorMsg = null; });
    try {
      final requests = await MarketplaceRepository.instance.getMyRequests();
      if (!mounted) return;
      final appState = context.read<AppState>();
      for (final r in requests) {
        if (!appState.marketRequests.any((e) => e.id == r.id)) {
          appState.createRepairRequest(r);
        }
      }
    } on ApiException catch (e) {
      if (mounted) setState(() => _errorMsg = e.message);
    } catch (_) {
      // fall back to local cache silently
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final currentUser = appState.currentUser;

    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Requests')),
        body: const Center(child: Text('Please log in to view your requests')),
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
          'My Projects',
          style: AppTypography.h3.copyWith(color: AppColors.primary900),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Consumer<AppState>(
              builder: (context, appState, _) {
                final myRequests = appState.getRequestsForOwner(currentUser.id);

                if (myRequests.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.folder_open, size: 80, color: AppColors.grey400),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          'No projects yet',
                          style: AppTypography.h4.copyWith(color: AppColors.grey600),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Create your first repair request',
                          style: AppTypography.bodySmall.copyWith(color: AppColors.grey500),
                        ),
                        if (_errorMsg != null) ...[
                          const SizedBox(height: AppSpacing.md),
                          Text(_errorMsg!,
                              style: AppTypography.caption.copyWith(color: AppColors.dangerRed)),
                          TextButton(
                            onPressed: _loadMyRequests,
                            child: const Text('إعادة المحاولة'),
                          ),
                        ],
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _loadMyRequests,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    itemCount: myRequests.length,
                    itemBuilder: (context, index) {
                      final request = myRequests[index];
                      final bidsCount = appState.getBidsForRequest(request.id).length;

                      return _RequestCard(
                        request: request,
                        bidsCount: bidsCount,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RequestDetailsScreen(requestId: request.id),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}


class _RequestCard extends StatelessWidget {
  final RepairRequest request;
  final int bidsCount;
  final VoidCallback onTap;

  const _RequestCard({
    required this.request,
    required this.bidsCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.r12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.r12),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      request.title,
                      style: AppTypography.h4,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _StatusBadge(status: request.status),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                request.description,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.grey600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: AppColors.grey500,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    request.location,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.grey600,
                    ),
                  ),
                  const Spacer(),
                  if (bidsCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary50,
                        borderRadius: BorderRadius.circular(AppRadius.r8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.local_offer,
                            size: 14,
                            color: AppColors.primary500,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$bidsCount ${bidsCount == 1 ? 'bid' : 'bids'}',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.primary500,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final RequestStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    String label;

    switch (status) {
      case RequestStatus.posted:
        bgColor = AppColors.primary50;
        textColor = AppColors.primary500;
        label = 'Open';
        break;
      case RequestStatus.bidding:
        bgColor = Colors.blue.shade50;
        textColor = Colors.blue.shade700;
        label = 'Bidding';
        break;
      case RequestStatus.awarded:
        bgColor = Colors.green.shade50;
        textColor = Colors.green.shade700;
        label = 'Awarded';
        break;
      case RequestStatus.inProgress:
        bgColor = Colors.orange.shade50;
        textColor = Colors.orange.shade700;
        label = 'In Progress';
        break;
      case RequestStatus.completed:
        bgColor = Colors.teal.shade50;
        textColor = Colors.teal.shade700;
        label = 'Completed';
        break;
      default:
        bgColor = AppColors.grey200;
        textColor = AppColors.grey700;
        label = status.name;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.r8),
      ),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
