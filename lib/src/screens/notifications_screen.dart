import 'package:flutter/material.dart';
import '../core/api_client.dart';
import '../core/api_exception.dart';
import '../store/app_state.dart';
import '../design/colors.dart';
import '../design/spacing.dart';
import '../design/typography.dart';
import '../design/radius.dart';
import '../widgets/app_top_bar.dart';

/// Notification model from backend
class _Notification {
  final String id;
  final String title;
  final String body;
  final bool isRead;
  final DateTime createdAt;
  final String? type; // e.g. 'scan_completed', 'dispute', 'marketplace'

  const _Notification({
    required this.id,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdAt,
    this.type,
  });

  factory _Notification.fromJson(Map<String, dynamic> json) {
    return _Notification(
      id:        (json['id'] ?? '').toString(),
      title:     (json['title'] ?? 'إشعار').toString(),
      body:      (json['body'] ?? json['message'] ?? '').toString(),
      isRead:    (json['is_read'] ?? json['isRead'] ?? false) as bool,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      type:      json['type']?.toString(),
    );
  }
}

/// Notifications screen — fetches from GET /notifications.
/// Supports mark-as-read via PATCH /notifications/read.
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _isLoading = false;
  String? _errorMsg;
  List<_Notification> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    // In mock mode, show empty state (no local notification store in AppState)
    if (AppState.useMockData) {
      setState(() { _isLoading = false; });
      return;
    }

    setState(() { _isLoading = true; _errorMsg = null; });
    try {
      final response = await ApiClient.instance.get('/notifications');
      final raw = response.data;
      List<dynamic> list;
      if (raw is Map && raw['data'] is List) {
        list = raw['data'] as List;
      } else if (raw is List) {
        list = raw;
      } else {
        list = [];
      }
      setState(() {
        _notifications = list
            .map((e) => _Notification.fromJson(e as Map<String, dynamic>))
            .toList();
      });
    } on ApiException catch (e) {
      if (mounted) setState(() => _errorMsg = e.message);
    } catch (_) {
      // silently keep empty list
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _markAllRead() async {
    try {
      await ApiClient.instance.post('/notifications/read', data: {'all': true});
      setState(() {
        _notifications = _notifications
            .map((n) => _Notification(
                  id: n.id, title: n.title, body: n.body,
                  isRead: true, createdAt: n.createdAt, type: n.type))
            .toList();
      });
    } catch (_) {
      // ignore — best-effort
    }
  }

  Future<void> _markRead(String id) async {
    try {
      await ApiClient.instance.post('/notifications/read', data: {'id': id});
      setState(() {
        _notifications = _notifications.map((n) {
          if (n.id == id) {
            return _Notification(
                id: n.id, title: n.title, body: n.body,
                isRead: true, createdAt: n.createdAt, type: n.type);
          }
          return n;
        }).toList();
      });
    } catch (_) {
      // ignore
    }
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications.where((n) => !n.isRead).length;

    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: AppTopBar(
        title: 'الإشعارات',
        onBack: () => Navigator.pop(context),
        actions: unreadCount > 0
            ? [
                TextButton(
                  onPressed: _markAllRead,
                  child: Text(
                    'قراءة الكل',
                    style: AppTypography.bodySmall
                        .copyWith(color: AppColors.primary500),
                  ),
                )
              ]
            : null,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildBody(),
    );
  }

  Widget _buildBody() {
    final notifications = _notifications;

    if (notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_none, size: 64, color: AppColors.grey300),
            const SizedBox(height: AppSpacing.md),
            Text('لا توجد إشعارات', style: AppTypography.h3),
            const SizedBox(height: AppSpacing.sm),
            Text('ستظهر إشعاراتك هنا',
                style: AppTypography.bodySmall
                    .copyWith(color: AppColors.textSecondary)),
            if (_errorMsg != null) ...[
              const SizedBox(height: AppSpacing.md),
              ElevatedButton.icon(
                onPressed: _loadNotifications,
                icon: const Icon(Icons.refresh),
                label: const Text('إعادة المحاولة'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary500),
              ),
            ],
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadNotifications,
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.lg),
        itemCount: notifications.length,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
        itemBuilder: (context, index) {
          final n = notifications[index];
          return _NotificationCard(
            notification: n,
            onTap: () => _markRead(n.id),
          );
        },
      ),
    );
  }

}

class _NotificationCard extends StatelessWidget {
  final _Notification notification;
  final VoidCallback onTap;

  const _NotificationCard({required this.notification, required this.onTap});

  IconData _iconFor(String? type) {
    switch (type) {
      case 'scan_completed': return Icons.check_circle_outline;
      case 'dispute':        return Icons.gavel_outlined;
      case 'marketplace':    return Icons.storefront_outlined;
      case 'contract':       return Icons.description_outlined;
      default:               return Icons.notifications_outlined;
    }
  }

  Color _colorFor(String? type) {
    switch (type) {
      case 'scan_completed': return AppColors.successGreen;
      case 'dispute':        return AppColors.warningOrange;
      case 'marketplace':    return AppColors.infoBlue;
      default:               return AppColors.primary500;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUnread = !notification.isRead;
    final color = _colorFor(notification.type);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isUnread
              ? color.withValues(alpha: 0.06)
              : AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.r12),
          border: Border.all(
            color: isUnread ? color.withValues(alpha: 0.3) : AppColors.grey200,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppRadius.r8),
              ),
              child: Icon(_iconFor(notification.type), color: color, size: 20),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(notification.title,
                            style: AppTypography.h5.copyWith(
                              color: isUnread
                                  ? AppColors.grey900
                                  : AppColors.textSecondary,
                            )),
                      ),
                      if (isUnread)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodySmall
                        .copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(notification.createdAt),
                    style: AppTypography.caption
                        .copyWith(color: AppColors.grey400),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1)  return 'الآن';
    if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
    if (diff.inHours < 24)   return 'منذ ${diff.inHours} ساعة';
    if (diff.inDays < 7)     return 'منذ ${diff.inDays} يوم';
    return '${date.day}/${date.month}/${date.year}';
  }
}
