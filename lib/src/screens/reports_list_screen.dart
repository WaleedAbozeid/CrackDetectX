import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../store/app_state.dart';
import 'report_view_screen.dart';
import '../widgets/top_bar.dart';
import '../design/typography.dart';
import '../design/spacing.dart';

class ReportsListScreen extends StatelessWidget {
  const ReportsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reports = Provider.of<AppState>(context).reports;
    return Scaffold(
      appBar: const AppTopBar(title: 'التقارير'),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: reports.length,
        itemBuilder: (context, idx) {
          final r = reports[idx];
          return Card(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: ListTile(
              title: Text('تقرير ${r.id}', style: AppTypography.bodyText1),
              subtitle: Text('تم في ${r.createdAt.toLocal()}', style: AppTypography.caption),
              trailing: const Icon(Icons.chevron_left),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ReportViewScreen(report: r))),
            ),
          );
        },
      ),
    );
  }
}
