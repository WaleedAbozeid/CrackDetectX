// PDF stub: implement real PDF generation using `pdf` + `printing` packages.
import '../ai/types.dart';

class PdfService {
  /// Generates a PDF for the given report and returns a path/URL to the generated file.
  /// Currently returns a placeholder string — replace with real file-generation.
  Future<String> generateReportPdf(Report report) async {
    // TODO: create a PDF file and return its local path
    await Future.delayed(const Duration(milliseconds: 200));
    return 'file://local/path/report_${report.id}.pdf';
  }
}
