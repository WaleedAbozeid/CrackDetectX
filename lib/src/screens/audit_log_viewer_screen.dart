import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../store/app_state.dart';
import '../models/admin_models.dart';
import '../design/colors.dart';
import '../design/spacing.dart';
import '../design/typography.dart';
import '../design/radius.dart';

class AuditLogViewerScreen extends StatefulWidget {
  const AuditLogViewerScreen({super.key});

  @override
  State<AuditLogViewerScreen> createState() => _AuditLogViewerScreenState();
}

class _AuditLogViewerScreenState extends State<AuditLogViewerScreen> {
  String? _selectedActionType;
  String? _selectedAdmin;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    var logs = appState.auditLogs.toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    // Apply filters
    if (_selectedActionType != null) {
      logs = logs
          .where((log) => log.action.toString() == _selectedActionType)
          .toList();
    }
    if (_selectedAdmin != null) {
      logs = logs.where((log) => log.adminId == _selectedAdmin).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Audit Logs'),
        backgroundColor: AppColors.neutral800,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
            tooltip: 'Filter',
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          if (_selectedActionType != null || _selectedAdmin != null)
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              color: AppColors.neutral100,
              child: Wrap(
                spacing: AppSpacing.sm,
                children: [
                  if (_selectedActionType != null)
                    Chip(
                      label: Text(
                        'Action: ${_selectedActionType!.split('.').last}',
                      ),
                      onDeleted: () =>
                          setState(() => _selectedActionType = null),
                    ),
                  if (_selectedAdmin != null)
                    Chip(
                      label: Text('Admin: $_selectedAdmin'),
                      onDeleted: () => setState(() => _selectedAdmin = null),
                    ),
                ],
              ),
            ),

          // Logs list
          Expanded(
            child: logs.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    itemCount: logs.length,
                    itemBuilder: (context, index) {
                      return _buildLogCard(context, logs[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long, size: 80, color: AppColors.neutral400),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No Audit Logs',
            style: AppTypography.h3.copyWith(color: AppColors.neutral600),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Admin actions will be logged here',
            style: AppTypography.body.copyWith(color: AppColors.neutral500),
          ),
        ],
      ),
    );
  }

  Widget _buildLogCard(BuildContext context, AuditLog log) {
    IconData icon;
    Color color;

    // Determine icon and color based on action type
    switch (log.action) {
      case AdminActionType.verificationApproved:
        icon = Icons.check_circle;
        color = AppColors.successGreen;
        break;
      case AdminActionType.verificationRejected:
        icon = Icons.cancel;
        color = AppColors.errorRed;
        break;
      case AdminActionType.disputeResolved:
        icon = Icons.gavel;
        color = AppColors.primary900;
        break;
      case AdminActionType.userBanned:
        icon = Icons.block;
        color = AppColors.errorRed;
        break;
      case AdminActionType.configChanged:
        icon = Icons.settings;
        color = AppColors.neutral600;
        break;
      case AdminActionType.escrowReleased:
      case AdminActionType.escrowRefunded:
        icon = Icons.attach_money;
        color = AppColors.warningYellow;
        break;
      default:
        icon = Icons.info;
        color = AppColors.infoBlue;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.r8),
      ),
      child: ExpansionTile(
        leading: Icon(icon, color: color, size: 28),
        title: Text(_getActionTitle(log.action), style: AppTypography.h5),
        subtitle: Text(
          '${log.adminName} • ${_formatDate(log.timestamp)}',
          style: AppTypography.caption,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                const SizedBox(height: AppSpacing.sm),

                // Log Details
                _buildDetailRow('Log ID', log.id),
                _buildDetailRow('Admin', '${log.adminName} (${log.adminId})'),
                _buildDetailRow('Target Type', log.targetType),
                _buildDetailRow('Target ID', log.targetId),
                _buildDetailRow('IP Address', log.ipAddress),
                _buildDetailRow('Timestamp', _formatDateFull(log.timestamp)),
                _buildDetailRow('Reversible', log.reversible ? 'Yes' : 'No'),

                const SizedBox(height: AppSpacing.sm),

                // Reason
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.neutral100,
                    borderRadius: BorderRadius.circular(AppRadius.r8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Reason:', style: AppTypography.h5),
                      const SizedBox(height: 4),
                      Text(log.reason, style: AppTypography.body),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.sm),

                // Old/New Values
                if (log.oldValue.isNotEmpty) ...[
                  Text('Old Value:', style: AppTypography.h5),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.errorRed.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppRadius.r4),
                    ),
                    child: Text(
                      log.oldValue.toString(),
                      style: AppTypography.caption,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],

                if (log.newValue.isNotEmpty) ...[
                  Text('New Value:', style: AppTypography.h5),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.successGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppRadius.r4),
                    ),
                    child: Text(
                      log.newValue.toString(),
                      style: AppTypography.caption,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
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
            width: 120,
            child: Text(
              label,
              style: AppTypography.caption.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.neutral600,
              ),
            ),
          ),
          Expanded(child: Text(value, style: AppTypography.caption)),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Filter Logs'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Filter by Action Type'),
              const SizedBox(height: 8),
              DropdownButton<String>(
                value: _selectedActionType,
                hint: const Text('All Actions'),
                isExpanded: true,
                items: [
                  const DropdownMenuItem(value: null, child: Text('All')),
                  ...AdminActionType.values.map((type) {
                    return DropdownMenuItem(
                      value: type.toString(),
                      child: Text(_getActionTitle(type)),
                    );
                  }),
                ],
                onChanged: (value) {
                  setState(() => _selectedActionType = value);
                  Navigator.pop(dialogContext);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedActionType = null;
                  _selectedAdmin = null;
                });
                Navigator.pop(dialogContext);
              },
              child: const Text('Clear Filters'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  String _getActionTitle(AdminActionType action) {
    switch (action) {
      case AdminActionType.verificationApproved:
        return 'Verification Approved';
      case AdminActionType.verificationRejected:
        return 'Verification Rejected';
      case AdminActionType.disputeResolved:
        return 'Dispute Resolved';
      case AdminActionType.userBanned:
        return 'User Banned';
      case AdminActionType.userUnbanned:
        return 'User Unbanned';
      case AdminActionType.configChanged:
        return 'Config Changed';
      case AdminActionType.escrowReleased:
        return 'Escrow Released';
      case AdminActionType.escrowRefunded:
        return 'Escrow Refunded';
      default:
        return action.toString().split('.').last;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }

  String _formatDateFull(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}';
  }
}
