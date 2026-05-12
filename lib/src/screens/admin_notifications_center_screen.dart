import 'package:flutter/material.dart';
import '../core/api_client.dart';
import '../core/api_exception.dart';
import '../store/app_state.dart';
import '../design/colors.dart';
import '../design/spacing.dart';
import '../design/typography.dart';
import '../design/radius.dart';

/// Admin Notifications Center — broadcast a system notification to all users
/// or a specific role. Fetches existing notifications from GET /notifications.
class AdminNotificationsCenterScreen extends StatefulWidget {
  const AdminNotificationsCenterScreen({super.key});

  @override
  State<AdminNotificationsCenterScreen> createState() =>
      _AdminNotificationsCenterScreenState();
}

class _AdminNotificationsCenterScreenState
    extends State<AdminNotificationsCenterScreen> {
  // ── Compose form ─────────────────────────────────────────────────────────
  final _titleCtrl   = TextEditingController();
  final _messageCtrl = TextEditingController();
  String _targetRole = 'all'; // all | engineer | client | admin
  bool _isSending    = false;
  String? _sendError;
  String? _sendSuccess;

  // ── History list ─────────────────────────────────────────────────────────
  bool _isLoading = false;
  List<Map<String, dynamic>> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    try {
      final response = await ApiClient.instance.get('/admin/notifications');
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
        _history = list.cast<Map<String, dynamic>>();
      });
    } on ApiException {
      // silently keep empty
    } catch (_) {
      // fallback
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _broadcast() async {
    if (_titleCtrl.text.trim().isEmpty || _messageCtrl.text.trim().isEmpty) {
      setState(() => _sendError = 'يرجى ملء العنوان والرسالة');
      return;
    }

    setState(() { _isSending = true; _sendError = null; _sendSuccess = null; });
    try {
      if (!AppState.useMockData) {
        await ApiClient.instance.post('/admin/notifications', data: {
          'title':       _titleCtrl.text.trim(),
          'body':        _messageCtrl.text.trim(),
          'target_role': _targetRole,
        });
      }
      _titleCtrl.clear();
      _messageCtrl.clear();
      setState(() => _sendSuccess = 'تم إرسال الإشعار بنجاح ✓');
      _loadHistory();
    } on ApiException catch (e) {
      if (mounted) setState(() => _sendError = e.message);
    } catch (_) {
      if (mounted) setState(() => _sendError = 'حدث خطأ، حاول مرة أخرى');
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: AppBar(
        backgroundColor: AppColors.primary900,
        title: const Text('مركز الإشعارات'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.white),
            onPressed: _loadHistory,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Compose Section ────────────────────────────────────────────
            _SectionCard(
              title: 'إرسال إشعار جديد',
              icon: Icons.send_outlined,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Success/Error banners
                  if (_sendSuccess != null)
                    _Banner(
                      message: _sendSuccess!,
                      color: AppColors.successGreen,
                      icon: Icons.check_circle_outline,
                    ),
                  if (_sendError != null)
                    _Banner(
                      message: _sendError!,
                      color: AppColors.dangerRed,
                      icon: Icons.error_outline,
                    ),
                  const SizedBox(height: AppSpacing.sm),

                  // Title field
                  Text('العنوان', style: AppTypography.h5),
                  const SizedBox(height: AppSpacing.xs),
                  TextField(
                    controller: _titleCtrl,
                    decoration: InputDecoration(
                      hintText: 'عنوان الإشعار...',
                      filled: true,
                      fillColor: AppColors.grey50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.r8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Message field
                  Text('الرسالة', style: AppTypography.h5),
                  const SizedBox(height: AppSpacing.xs),
                  TextField(
                    controller: _messageCtrl,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'نص الإشعار...',
                      filled: true,
                      fillColor: AppColors.grey50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.r8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Target role
                  Text('المستهدفون', style: AppTypography.h5),
                  const SizedBox(height: AppSpacing.xs),
                  Wrap(
                    spacing: AppSpacing.xs,
                    children: [
                      for (final (String label, String val) in [
                        ('الكل', 'all'),
                        ('المهندسون', 'engineer'),
                        ('العملاء', 'client'),
                        ('المشرفون', 'admin'),
                      ])
                        FilterChip(
                          label: Text(label),
                          selected: _targetRole == val,
                          onSelected: (_) => setState(() => _targetRole = val),
                          selectedColor:
                              AppColors.primary500.withValues(alpha: 0.15),
                          checkmarkColor: AppColors.primary500,
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Send button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isSending ? null : _broadcast,
                      icon: _isSending
                          ? const SizedBox(
                              width: 16, height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2, color: AppColors.white),
                            )
                          : const Icon(Icons.send),
                      label: Text(_isSending ? 'جاري الإرسال...' : 'إرسال الإشعار'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary900,
                        padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.md),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // ── History Section ────────────────────────────────────────────
            _SectionCard(
              title: 'الإشعارات المرسلة',
              icon: Icons.history,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _history.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            child: Text(
                              'لا توجد إشعارات مرسلة بعد',
                              style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.textSecondary),
                            ),
                          ),
                        )
                      : Column(
                          children: _history
                              .take(10)
                              .map((n) => _HistoryItem(data: n))
                              .toList(),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Sub-Widgets ─────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  const _SectionCard({required this.title, required this.icon, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.r12),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Icon(icon, color: AppColors.primary900, size: 20),
                const SizedBox(width: AppSpacing.sm),
                Text(title,
                    style: AppTypography.h4
                        .copyWith(color: AppColors.primary900)),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  final String message;
  final Color color;
  final IconData icon;
  const _Banner({required this.message, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.r8),
        border: Border.all(color: color),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(message,
                style: AppTypography.bodySmall.copyWith(color: color)),
          ),
        ],
      ),
    );
  }
}

class _HistoryItem extends StatelessWidget {
  final Map<String, dynamic> data;
  const _HistoryItem({required this.data});

  @override
  Widget build(BuildContext context) {
    final title   = (data['title'] ?? 'إشعار').toString();
    final body    = (data['body'] ?? data['message'] ?? '').toString();
    final target  = (data['target_role'] ?? 'all').toString();
    final sentAt  = data['created_at'] != null
        ? DateTime.tryParse(data['created_at'].toString())
        : null;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(AppRadius.r8),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.notifications_outlined,
              color: AppColors.primary500, size: 18),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.h5),
                if (body.isNotEmpty)
                  Text(body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.caption
                          .copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color:
                            AppColors.primary500.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(target,
                          style: AppTypography.caption
                              .copyWith(color: AppColors.primary500, fontSize: 9)),
                    ),
                    const Spacer(),
                    if (sentAt != null)
                      Text(
                        '${sentAt.day}/${sentAt.month}/${sentAt.year}',
                        style: AppTypography.caption
                            .copyWith(color: AppColors.grey400),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
