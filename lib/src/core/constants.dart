/// Application-wide constants for CrackDetectX
class AppConstants {
  AppConstants._(); // Private constructor to prevent instantiation

  // ==================== APP INFO ====================
  static const String appName = 'CrackDetectX';
  static const String appTagline = 'AI-Powered Building Safety Inspector';
  static const String appVersion = '1.0.0';

  // ==================== ROUTES ====================
  static const String routeSplash = '/';
  static const String routeWelcome = '/welcome';
  static const String routeOnboarding = '/onboarding';
  static const String routeLogin = '/login';
  static const String routeSignup = '/signup';
  static const String routeHome = '/home';
  static const String routeScan = '/scan';
  static const String routeResult = '/result';
  static const String routeReports = '/reports';
  static const String routeSelectBuilding = '/select-building';
  static const String routeAddBuilding = '/add-building';
  static const String routeProjects = '/projects';
  static const String routeAnnotate = '/annotate';

  // ==================== AI PROCESSING ====================
  static const int minProcessingDelayMs = 1500;
  static const int maxProcessingDelayMs = 3000;
  static const double minConfidence = 0.6;
  static const double maxConfidence = 1.0;
  static const double highRiskThreshold = 0.85;
  static const double mediumRiskThreshold = 0.7;

  // ==================== STORAGE ====================
  static const String reportsStorageKey = 'crackdetectx_reports';
  static const String todosStorageKey = 'crackdetectx_todos';
  static const String settingsStorageKey = 'crackdetectx_settings';
  static const String buildingsStorageKey = 'crackdetectx_buildings';
  static const String projectsStorageKey = 'crackdetectx_projects';
  static const String annotationsStorageKey = 'crackdetectx_annotations';
  static const String userRoleStorageKey = 'crackdetectx_user_role';

  // ==================== PDF GENERATION ====================
  static const String pdfFileNamePrefix = 'crack_report_';
  static const String pdfFileExtension = '.pdf';
  static const String pdfReportTitle = 'تقرير كشف الشقوق';
  static const String pdfSummaryTitle = 'ملخص النتائج';
  static const String pdfRecommendationsTitle = 'التوصيات';
  static const String pdfReportInfoTitle = 'معلومات التقرير';

  // ==================== UI CONSTANTS ====================
  static const double defaultButtonHeight = 56.0;
  static const double defaultCardElevation = 2.0;
  static const int maxImageSizeMB = 10;
  static const int animationDurationMs = 300;

  // ==================== ERROR MESSAGES ====================
  static const String errorImagePickFailed = 'حدث خطأ أثناء اختيار الصورة';
  static const String errorImageProcessingFailed = 'حدث خطأ أثناء معالجة الصورة';
  static const String errorReportGenerationFailed = 'حدث خطأ أثناء إنشاء التقرير';
  static const String errorReportSaveFailed = 'حدث خطأ أثناء حفظ التقرير';
  static const String errorReportLoadFailed = 'حدث خطأ أثناء تحميل التقارير';

  // ==================== SUCCESS MESSAGES ====================
  static const String successReportSaved = 'تم حفظ التقرير بنجاح';
  static const String successReportDeleted = 'تم حذف التقرير بنجاح';
  static const String successImageProcessed = 'تم معالجة الصورة بنجاح';
}

