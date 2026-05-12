import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/api_client.dart';
import '../core/api_exception.dart';
import '../store/app_state.dart';
import '../design/colors.dart';
import '../design/spacing.dart';
import '../design/typography.dart';
import '../design/radius.dart';

// ─── User model for admin list ────────────────────────────────────────────────

class _AdminUser {
  final String id;
  final String name;
  final String email;
  final String role;     // 'engineer' | 'client' | 'admin'
  final bool isVerified;
  final bool isActive;
  final DateTime createdAt;

  const _AdminUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.isVerified,
    required this.isActive,
    required this.createdAt,
  });

  factory _AdminUser.fromJson(Map<String, dynamic> json) {
    return _AdminUser(
      id:         (json['id'] ?? '').toString(),
      name:       (json['name'] ?? json['full_name'] ?? 'مجهول').toString(),
      email:      (json['email'] ?? '').toString(),
      role:       (json['user_type'] ?? json['role'] ?? 'client').toString(),
      isVerified: (json['is_verified'] ?? false) as bool,
      isActive:   (json['is_active'] ?? true) as bool,
      createdAt:  json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

// ─── Screen ──────────────────────────────────────────────────────────────────

/// Admin Users Management Screen
/// Fetches from GET /admin/users — lists all users with role badges,
/// verification status and activation toggle.
class AdminUsersManagementScreen extends StatefulWidget {
  const AdminUsersManagementScreen({super.key});

  @override
  State<AdminUsersManagementScreen> createState() =>
      _AdminUsersManagementScreenState();
}

class _AdminUsersManagementScreenState
    extends State<AdminUsersManagementScreen> {
  bool _isLoading = false;
  String? _errorMsg;
  List<_AdminUser> _users = [];
  String _search = '';
  String _filterRole = 'all'; // all | engineer | client | admin

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() { _isLoading = true; _errorMsg = null; });
    try {
      final response = await ApiClient.instance.get('/admin/users');
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
        _users = list
            .map((e) => _AdminUser.fromJson(e as Map<String, dynamic>))
            .toList();
      });
    } on ApiException catch (e) {
      if (mounted) setState(() => _errorMsg = e.message);
    } catch (e) {
      if (mounted) setState(() => _errorMsg = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleActive(String userId, bool currentActive) async {
    try {
      await ApiClient.instance.put(
        '/admin/users/$userId',
        data: {'is_active': !currentActive},
      );
      setState(() {
        _users = _users.map((u) {
          if (u.id == userId) {
            return _AdminUser(
              id: u.id, name: u.name, email: u.email,
              role: u.role, isVerified: u.isVerified,
              isActive: !currentActive, createdAt: u.createdAt,
            );
          }
          return u;
        }).toList();
      });
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: AppColors.dangerRed),
        );
      }
    }
  }

  List<_AdminUser> get _filtered {
    return _users.where((u) {
      final matchRole = _filterRole == 'all' || u.role == _filterRole;
      final matchSearch = _search.isEmpty ||
          u.name.toLowerCase().contains(_search.toLowerCase()) ||
          u.email.toLowerCase().contains(_search.toLowerCase());
      return matchRole && matchSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Check if current user is admin
    final appState = context.read<AppState>();
    if (!appState.isAdmin) {
      return Scaffold(
        appBar: AppBar(title: const Text('إدارة المستخدمين')),
        body: const Center(child: Text('غير مصرح لك بالوصول')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: AppBar(
        title: const Text('إدارة المستخدمين'),
        backgroundColor: AppColors.primary900,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.white),
            onPressed: _loadUsers,
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Search + Filter bar ──────────────────────────────────────
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                TextField(
                  onChanged: (v) => setState(() => _search = v),
                  decoration: InputDecoration(
                    hintText: 'بحث بالاسم أو الإيميل...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: AppColors.grey50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.r12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final (String label, String value) in [
                        ('الكل', 'all'),
                        ('مهندسون', 'engineer'),
                        ('عملاء', 'client'),
                        ('مشرفون', 'admin'),
                      ])
                        Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.xs),
                          child: FilterChip(
                            label: Text(label),
                            selected: _filterRole == value,
                            onSelected: (_) =>
                                setState(() => _filterRole = value),
                            selectedColor: AppColors.primary500.withValues(alpha: 0.15),
                            checkmarkColor: AppColors.primary500,
                            labelStyle: AppTypography.bodySmall.copyWith(
                              color: _filterRole == value
                                  ? AppColors.primary500
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Content ──────────────────────────────────────────────────
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMsg != null && _users.isEmpty
                    ? _ErrorView(message: _errorMsg!, onRetry: _loadUsers)
                    : _filtered.isEmpty
                        ? Center(
                            child: Text('لا توجد نتائج',
                                style: AppTypography.h3))
                        : RefreshIndicator(
                            onRefresh: _loadUsers,
                            child: ListView.separated(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              itemCount: _filtered.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(height: AppSpacing.sm),
                              itemBuilder: (_, i) => _UserCard(
                                user: _filtered[i],
                                onToggleActive: () => _toggleActive(
                                    _filtered[i].id, _filtered[i].isActive),
                              ),
                            ),
                          ),
          ),
        ],
      ),

      // ── Stats FAB ─────────────────────────────────────────────────────
      floatingActionButton: _users.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: null,
              backgroundColor: AppColors.primary900,
              icon: const Icon(Icons.people_outline, color: AppColors.white),
              label: Text(
                '${_users.length} مستخدم',
                style: AppTypography.button.copyWith(color: AppColors.white),
              ),
            )
          : null,
    );
  }
}

// ─── User Card ────────────────────────────────────────────────────────────────

class _UserCard extends StatelessWidget {
  final _AdminUser user;
  final VoidCallback onToggleActive;
  const _UserCard({required this.user, required this.onToggleActive});

  Color _roleColor(String role) {
    switch (role) {
      case 'admin':    return AppColors.dangerRed;
      case 'engineer': return AppColors.primary500;
      default:         return AppColors.successGreen;
    }
  }

  String _roleLabel(String role) {
    switch (role) {
      case 'admin':    return 'مشرف';
      case 'engineer': return 'مهندس';
      default:         return 'عميل';
    }
  }

  @override
  Widget build(BuildContext context) {
    final roleColor = _roleColor(user.role);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
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
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 24,
            backgroundColor: roleColor.withValues(alpha: 0.15),
            child: Text(
              user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
              style: AppTypography.h3.copyWith(color: roleColor),
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(user.name, style: AppTypography.h5),
                    ),
                    // Role badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: roleColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _roleLabel(user.role),
                        style: AppTypography.caption
                            .copyWith(color: roleColor, fontSize: 10),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(user.email,
                    style: AppTypography.bodySmall
                        .copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    // Verified badge
                    Icon(
                      user.isVerified
                          ? Icons.verified_outlined
                          : Icons.pending_outlined,
                      size: 14,
                      color: user.isVerified
                          ? AppColors.successGreen
                          : AppColors.warningOrange,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      user.isVerified ? 'موثّق' : 'غير موثّق',
                      style: AppTypography.caption.copyWith(
                        color: user.isVerified
                            ? AppColors.successGreen
                            : AppColors.warningOrange,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Active toggle
          Switch(
            value: user.isActive,
            onChanged: (_) => onToggleActive(),
            activeThumbColor: AppColors.successGreen,
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cloud_off, size: 64, color: AppColors.grey300),
          const SizedBox(height: AppSpacing.md),
          Text('تعذّر تحميل المستخدمين', style: AppTypography.h3),
          const SizedBox(height: AppSpacing.sm),
          Text(message,
              style: AppTypography.bodySmall
                  .copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.xl),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('إعادة المحاولة'),
            style:
                ElevatedButton.styleFrom(backgroundColor: AppColors.primary500),
          ),
        ],
      ),
    );
  }
}
