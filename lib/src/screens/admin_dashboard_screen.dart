import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:crackdetectx/l10n/app_localizations.dart';
import '../store/app_state.dart';
import '../models/admin_models.dart';
import '../models/marketplace_models.dart';
import '../design/colors.dart';
import '../design/spacing.dart';
import '../design/typography.dart';
import '../design/radius.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: AppBar(
        title: Text(l10n.adminDashboardTitle),
        backgroundColor: AppColors.primary900,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 980;

          if (!wide) {
            return _AdminDashboardBody(
              appState: appState,
              l10n: l10n,
            );
          }

          return Row(
            children: [
              _AdminSidebar(
                l10n: l10n,
                onNavigate: (route) => Navigator.pushNamed(context, route),
              ),
              const VerticalDivider(width: 1),
              Expanded(
                child: _AdminDashboardBody(
                  appState: appState,
                  l10n: l10n,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AdminSidebar extends StatelessWidget {
  final AppLocalizations l10n;
  final void Function(String route) onNavigate;

  const _AdminSidebar({
    required this.l10n,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      color: AppColors.primary900,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Text(
              l10n.adminDashboardTitle,
              style: AppTypography.h3.copyWith(color: AppColors.white),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _SideItem(
            label: l10n.adminDashboardTitle,
            icon: Icons.dashboard_outlined,
            selected: true,
            onTap: () {},
          ),
          _SideItem(
            label: l10n.adminActionReviewVerifications,
            icon: Icons.verified_user_outlined,
            onTap: () => onNavigate('/admin/verification-queue'),
          ),
          _SideItem(
            label: l10n.adminActionManageDisputes,
            icon: Icons.gavel_outlined,
            onTap: () => onNavigate('/admin/disputes'),
          ),
          _SideItem(
            label: l10n.adminActionSystemConfig,
            icon: Icons.settings_outlined,
            onTap: () => onNavigate('/admin/system-config'),
          ),
          _SideItem(
            label: l10n.adminActionSupportTickets,
            icon: Icons.support_agent,
            onTap: () => onNavigate('/admin/tickets'),
          ),
          _SideItem(
            label: l10n.adminActionNotificationsCenter,
            icon: Icons.notifications_none,
            onTap: () => onNavigate('/admin/notifications'),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Text(
              l10n.adminChartPlaceholder,
              style: AppTypography.caption.copyWith(
                color: AppColors.primary100,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SideItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _SideItem({
    required this.label,
    required this.icon,
    required this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected
        ? AppColors.primary700.withValues(alpha: 0.55)
        : Colors.transparent;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        color: bg,
        child: Row(
          children: [
            Icon(icon, color: AppColors.white.withValues(alpha: 0.9)),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                label,
                style: AppTypography.body.copyWith(
                  color: AppColors.white.withValues(alpha: 0.9),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminDashboardBody extends StatelessWidget {
  final AppState appState;
  final AppLocalizations l10n;

  const _AdminDashboardBody({
    required this.appState,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final pendingVerifications = appState.getPendingVerifications().length;
    final openDisputes =
        appState.disputes.where((d) => d.status == DisputeStatus.open).length;
    final activeContracts = appState.contracts
        .where((c) => c.status == ContractStatus.active)
        .length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // KPI Cards (Figma-like grid)
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            children: [
              _KpiCard(
                title: l10n.adminKpiActiveContracts,
                value: activeContracts.toString(),
                icon: Icons.description_outlined,
                accent: AppColors.infoBlue,
              ),
              _KpiCard(
                title: l10n.adminKpiOpenDisputes,
                value: openDisputes.toString(),
                icon: Icons.gavel_outlined,
                accent: AppColors.warningOrange,
              ),
              _KpiCard(
                title: l10n.adminKpiPendingVerifications,
                value: pendingVerifications.toString(),
                icon: Icons.verified_user_outlined,
                accent: AppColors.warningYellow,
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xl),

          Text(l10n.adminQuickActions, style: AppTypography.h3),
          const SizedBox(height: AppSpacing.md),
          _QuickActionGrid(l10n: l10n),

          const SizedBox(height: AppSpacing.xl),

          // Charts row (placeholders but styled like Figma)
          LayoutBuilder(
            builder: (context, c) {
              final twoCols = c.maxWidth >= 900;
              if (!twoCols) {
                return Column(
                  children: [
                    _ChartCard(
                      title: l10n.adminChartRiskDistribution,
                      child: const _DonutPlaceholder(),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _ChartCard(
                      title: l10n.adminChartWeeklyActivity,
                      child: const _LinePlaceholder(),
                    ),
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(
                    child: _ChartCard(
                      title: l10n.adminChartRiskDistribution,
                      child: const _DonutPlaceholder(),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _ChartCard(
                      title: l10n.adminChartWeeklyActivity,
                      child: const _LinePlaceholder(),
                    ),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: AppSpacing.xl),

          Text(l10n.adminRecentActions, style: AppTypography.h3),
          const SizedBox(height: AppSpacing.md),
          _RecentAuditLogs(l10n: l10n, appState: appState),
        ],
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color accent;

  const _KpiCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.r12),
          border: Border.all(color: AppColors.grey200),
          boxShadow: const [
            BoxShadow(
              color: Color(0x11000000),
              blurRadius: 14,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppRadius.r12),
              ),
              child: Icon(icon, color: accent),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: AppTypography.h2.copyWith(color: AppColors.grey900),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    title,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.neutral600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionGrid extends StatelessWidget {
  final AppLocalizations l10n;
  const _QuickActionGrid({required this.l10n});

  @override
  Widget build(BuildContext context) {
    Widget tile({
      required String title,
      required IconData icon,
      required Color color,
      required String route,
    }) {
      return InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.r12),
            border: Border.all(color: AppColors.grey200),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.r12),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: Text(title, style: AppTypography.h4)),
              const Icon(Icons.chevron_right, color: AppColors.neutral500),
            ],
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, c) {
        final cols = c.maxWidth >= 900 ? 2 : 1;
        final children = [
          tile(
            title: l10n.adminActionReviewVerifications,
            icon: Icons.verified_user_outlined,
            color: AppColors.primary900,
            route: '/admin/verification-queue',
          ),
          tile(
            title: l10n.adminActionManageDisputes,
            icon: Icons.gavel_outlined,
            color: AppColors.warningOrange,
            route: '/admin/disputes',
          ),
          tile(
            title: l10n.adminActionUserManagement,
            icon: Icons.people_outline,
            color: AppColors.infoBlue,
            route: '/admin/users',
          ),
          tile(
            title: l10n.adminActionSystemConfig,
            icon: Icons.settings_outlined,
            color: AppColors.neutral600,
            route: '/admin/system-config',
          ),
          tile(
            title: l10n.adminActionSupportTickets,
            icon: Icons.support_agent,
            color: AppColors.infoBlue,
            route: '/admin/tickets',
          ),
          tile(
            title: l10n.adminActionNotificationsCenter,
            icon: Icons.notifications_none,
            color: AppColors.primary900,
            route: '/admin/notifications',
          ),
        ];

        if (cols == 1) {
          return Column(
            children: [
              for (var i = 0; i < children.length; i++) ...[
                children[i],
                if (i != children.length - 1)
                  const SizedBox(height: AppSpacing.md),
              ],
            ],
          );
        }

        return Column(
          children: [
            for (var i = 0; i < children.length; i += 2) ...[
              Row(
                children: [
                  Expanded(child: children[i]),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: children[i + 1]),
                ],
              ),
              if (i + 2 < children.length)
                const SizedBox(height: AppSpacing.md),
            ],
          ],
        );
      },
    );
  }
}

class _ChartCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _ChartCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.r12),
            border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.h4),
          const SizedBox(height: AppSpacing.md),
          SizedBox(height: 220, child: child),
        ],
      ),
    );
  }
}

class _DonutPlaceholder extends StatelessWidget {
  const _DonutPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 180,
        height: 180,
        child: PieChart(
          PieChartData(
            sectionsSpace: 2,
            centerSpaceRadius: 50,
            sections: [
              PieChartSectionData(
                color: AppColors.successGreen,
                value: 45,
                title: '45%',
                radius: 40,
                titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              PieChartSectionData(
                color: AppColors.warningOrange,
                value: 25,
                title: '25%',
                radius: 40,
                titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              PieChartSectionData(
                color: AppColors.errorRed,
                value: 18,
                title: '18%',
                radius: 40,
                titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              PieChartSectionData(
                color: AppColors.infoBlue,
                value: 12,
                title: '12%',
                radius: 40,
                titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LinePlaceholder extends StatelessWidget {
  const _LinePlaceholder();

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: AppColors.grey200,
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: false,
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: 5,
        minY: 0,
        maxY: 4,
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 1),
              FlSpot(1, 1.5),
              FlSpot(2, 2),
              FlSpot(3, 1.8),
              FlSpot(4, 2.5),
              FlSpot(5, 2.2),
            ],
            isCurved: false,
            color: AppColors.primary500,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }
}

class _RecentAuditLogs extends StatelessWidget {
  final AppLocalizations l10n;
  final AppState appState;

  const _RecentAuditLogs({required this.l10n, required this.appState});

  @override
  Widget build(BuildContext context) {
    final recentLogs = appState.auditLogs.take(5).toList();

    if (recentLogs.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.r12),
          border: Border.all(color: AppColors.grey200),
        ),
        child: Center(
          child: Text(
            l10n.adminNoRecentActions,
            style: AppTypography.body.copyWith(color: AppColors.neutral500),
          ),
        ),
      );
    }

    return Column(
      children: [
        for (final log in recentLogs) ...[
          _AuditLogRow(log: log),
          const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}

class _AuditLogRow extends StatelessWidget {
  final AuditLog log;
  const _AuditLogRow({required this.log});

  @override
  Widget build(BuildContext context) {
    final icon = switch (log.action) {
      AdminActionType.verificationApproved => Icons.check_circle_outline,
      AdminActionType.verificationRejected => Icons.cancel_outlined,
      AdminActionType.disputeResolved => Icons.gavel_outlined,
      _ => Icons.info_outline,
    };

    final color = switch (log.action) {
      AdminActionType.verificationApproved => AppColors.successGreen,
      AdminActionType.verificationRejected => AppColors.errorRed,
      AdminActionType.disputeResolved => AppColors.primary900,
      _ => AppColors.infoBlue,
    };

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.r12),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(log.action.toString().split('.').last, style: AppTypography.h5),
                const SizedBox(height: 4),
                Text(
                  '${log.adminName} • ${_formatDate(log.timestamp)}',
                  style: AppTypography.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h';
    } else {
      return '${diff.inDays}d';
    }
  }
}
