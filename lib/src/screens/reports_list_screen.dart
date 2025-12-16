import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../store/app_state.dart';
import 'report_view_screen.dart';
import '../widgets/top_bar.dart';
import '../design/typography.dart';
import '../design/spacing.dart';
import '../design/colors.dart';
import '../widgets/card.dart';

class ReportsListScreen extends StatefulWidget {
  const ReportsListScreen({super.key});

  @override
  State<ReportsListScreen> createState() => _ReportsListScreenState();
}

class _ReportsListScreenState extends State<ReportsListScreen> {
  @override
  Widget build(BuildContext context) {
    final reports = Provider.of<AppState>(context).reports;
    
    return Scaffold(
      appBar: const AppTopBar(title: 'التقارير المحفوظة'),
      body: reports.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.folder_open_outlined, size: 64, color: AppColors.grey300),
                  const SizedBox(height: AppSpacing.md),
                  Text('لا توجد تقارير', style: AppTypography.h3),
                  const SizedBox(height: AppSpacing.sm),
                  Text('ابدأ بمسح صورة جديدة', style: AppTypography.bodyText2),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: reports.length,
              itemBuilder: (context, idx) {
                final report = reports[idx];
                return Dismissible(
                  key: Key(report.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.dangerRed,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.delete_outline, color: AppColors.white),
                  ),
                  onDismissed: (_) {
                    Provider.of<AppState>(context, listen: false).removeReport(report.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم حذف التقرير')),
                    );
                  },
                  child: AppCard(
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(AppSpacing.md),
                      leading: Container(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: AppColors.primary500.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.assessment_outlined, color: AppColors.primary500),
                      ),
                      title: Text('تقرير #${report.id.substring(0, 8)}', style: AppTypography.h4),
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
                        ],
                      ),
                      trailing: const Icon(Icons.chevron_left, color: AppColors.grey400),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ReportViewScreen(report: report)),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
