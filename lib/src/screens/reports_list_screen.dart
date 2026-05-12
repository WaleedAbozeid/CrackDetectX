import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../store/app_state.dart';
import '../repositories/report_repository.dart';
import '../core/api_exception.dart';
import '../ai/types.dart';
import 'report_view_screen.dart';
import '../widgets/top_bar.dart';
import '../design/typography.dart';
import '../design/spacing.dart';
import '../design/colors.dart';
import '../widgets/card.dart';

/// Shows all reports — fetched from the backend API on load.
/// Falls back to AppState local cache if offline or useMockData = true.
class ReportsListScreen extends StatefulWidget {
  const ReportsListScreen({super.key});

  @override
  State<ReportsListScreen> createState() => _ReportsListScreenState();
}

class _ReportsListScreenState extends State<ReportsListScreen> {
  bool _isLoading = false;
  String? _errorMsg;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    // In mock mode, use AppState local data
    if (AppState.useMockData) return;

    setState(() { _isLoading = true; _errorMsg = null; });
    try {
      final reports = await ReportRepository.instance.getReports();
      if (!mounted) return;
      final appState = context.read<AppState>();
      for (final r in reports) {
        if (!appState.reports.any((e) => e.id == r.id)) {
          appState.addReport(r);
        }
      }
    } on ApiException catch (e) {
      if (mounted) setState(() => _errorMsg = e.message);
    } catch (_) {
      // silently fall back to local cache
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteReport(BuildContext context, String reportId) async {
    final appState = context.read<AppState>();
    final messenger = ScaffoldMessenger.of(context); // capture before await
    appState.removeReport(reportId);

    if (!AppState.useMockData) {
      try {
        await ReportRepository.instance.deleteReport(reportId);
      } on ApiException catch (e) {
        messenger.showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: AppColors.dangerRed),
        );
        if (mounted) _loadReports();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final reports = context.watch<AppState>().reports;

    return Scaffold(
      appBar: const AppTopBar(title: 'التقارير المحفوظة'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : reports.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.folder_open_outlined,
                          size: 64, color: AppColors.grey300),
                      const SizedBox(height: AppSpacing.md),
                      Text('لا توجد تقارير', style: AppTypography.h3),
                      const SizedBox(height: AppSpacing.sm),
                      Text('ابدأ بمسح صورة جديدة',
                          style: AppTypography.bodyText2),
                      if (_errorMsg != null) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Text(_errorMsg!,
                            style: AppTypography.caption.copyWith(
                                color: AppColors.dangerRed),
                            textAlign: TextAlign.center),
                        const SizedBox(height: AppSpacing.md),
                        ElevatedButton.icon(
                          onPressed: _loadReports,
                          icon: const Icon(Icons.refresh),
                          label: const Text('إعادة المحاولة'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary500),
                        ),
                      ],
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadReports,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    itemCount: reports.length,
                    itemBuilder: (context, idx) {
                      final report = reports[idx];
                      return Dismissible(
                        key: Key(report.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md),
                          decoration: BoxDecoration(
                            color: AppColors.dangerRed,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.delete_outline,
                              color: AppColors.white),
                        ),
                        onDismissed: (_) {
                          _deleteReport(context, report.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('تم حذف التقرير')),
                          );
                        },
                        child: AppCard(
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.all(AppSpacing.md),
                            leading: Container(
                              padding: const EdgeInsets.all(AppSpacing.sm),
                              decoration: BoxDecoration(
                                color: AppColors.primary500.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.assessment_outlined,
                                  color: AppColors.primary500),
                            ),
                            title: Text(
                                'تقرير #${report.id.substring(0, report.id.length.clamp(0, 8))}',
                                style: AppTypography.h4),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  'التاريخ: ${report.createdAt.toLocal().toString().split('.')[0]}',
                                  style: AppTypography.caption,
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  'الثقة: ${(report.result.metrics.confidence * 100).toStringAsFixed(1)}%',
                                  style: AppTypography.bodySmall,
                                ),
                                _SeverityBadge(
                                    severity: report.result.metrics.severity),
                              ],
                            ),
                            trailing: const Icon(Icons.chevron_left,
                                color: AppColors.grey400),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      ReportViewScreen(report: report)),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}

/// Small severity badge shown on each report card
class _SeverityBadge extends StatelessWidget {
  final Severity severity;
  const _SeverityBadge({required this.severity});

  Color get _color {
    switch (severity) {
      case Severity.high:   return AppColors.dangerRed;
      case Severity.medium: return AppColors.warningOrange;
      case Severity.low:    return AppColors.successGreen;
    }
  }

  String get _label {
    switch (severity) {
      case Severity.high:   return 'خطير';
      case Severity.medium: return 'متوسط';
      case Severity.low:    return 'منخفض';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        _label,
        style: AppTypography.caption.copyWith(color: _color, fontSize: 10),
      ),
    );
  }
}
