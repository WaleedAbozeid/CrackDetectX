import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../ai/types.dart';
import '../core/constants.dart';

/// Generates a PDF report from a detection result
/// 
/// [report] - The report containing detection results
/// Returns the file path of the generated PDF, or null if generation fails
/// Throws [Exception] if PDF generation fails
Future<String?> generateReportPDF(Report report) async {
  try {
    final pdf = pw.Document();
    final now = DateTime.now();
    
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          // Header
          pw.Header(
            level: 0,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  AppConstants.pdfReportTitle,
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  _formatDateTime(now),
                  style: const pw.TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 20),

          // Summary Section
          pw.Text(
            AppConstants.pdfSummaryTitle,
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(),
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('نسبة التأكد:'),
                    pw.Text('${(report.result.metrics.confidence * 100).toStringAsFixed(1)}%'),
                  ],
                ),
                pw.SizedBox(height: 8),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('طول الشق:'),
                    pw.Text('${report.result.metrics.lengthMeters.toStringAsFixed(2)} متر'),
                  ],
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 20),

          // Recommendations
          pw.Text(
            AppConstants.pdfRecommendationsTitle,
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(),
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
            ),
            child: pw.Text(
              report.result.metrics.confidence > 0.8
                  ? '⚠️ يُنصح بإجراء إصلاح فوري للشق المكتشف.'
                  : '✓ يُنصح بمراقبة الحالة والإصلاح عند الحاجة.',
            ),
          ),
          pw.SizedBox(height: 20),

          // Report ID
          pw.Text(
            AppConstants.pdfReportInfoTitle,
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text('معرّف التقرير: ${report.id}'),
          pw.Text('التاريخ والوقت: ${_formatDateTime(report.createdAt)}'),
        ],
      ),
    );

    // Save PDF
    final dir = await getApplicationDocumentsDirectory();
    final fileName =
        '${AppConstants.pdfFileNamePrefix}${report.id}${AppConstants.pdfFileExtension}';
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(await pdf.save());
    return file.path;
  } catch (e) {
    throw Exception('${AppConstants.errorReportGenerationFailed}: $e');
  }
}

/// Formats a DateTime to a readable string
/// 
/// [dateTime] - The DateTime to format
/// Returns formatted string without milliseconds
String _formatDateTime(DateTime dateTime) {
  return dateTime.toLocal().toString().split('.').first;
}
