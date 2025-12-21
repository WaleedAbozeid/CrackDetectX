import 'package:flutter/material.dart';

class AppStrings {
  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'welcome_back': 'Welcome Back,',
      'scan_building': 'Scan Building',
      'scans': 'scans',
      'avg_health': 'Avg Health',
      'cracks_detected': 'Cracks Detected',
      'start_new_scan': 'Start New Scan',
      'scan_subtitle': 'Capture image or upload from gallery',
      'start_scan_now': 'Start Scan Now',
      'recent_scans': 'Recent Scans',
      'view_all': 'View All',
      'market_title': 'Engineering Market',
      'market_subtitle': 'Connect with certified engineering companies',
      'explore_market': 'Explore Market',
      'nav_home': 'Home',
      'nav_scan': 'Scan',
      'nav_reports': 'Reports',
      'nav_market': 'Marketplace',
      'nav_profile': 'Profile',
      'no_recent_activity': 'No recent activity',
      'building_name': 'Building Name',
    },
    'ar': {
      'welcome_back': 'أهلاً بك،',
      'scan_building': 'فحص المباني',
      'scans': 'فحص',
      'avg_health': 'متوسط الصحة',
      'cracks_detected': 'تصدعات مكتشفة',
      'start_new_scan': 'ابدأ فحص جديد',
      'scan_subtitle': 'التقط صورة أو ارفع من المعرض',
      'start_scan_now': 'بدء الفحص الآن',
      'recent_scans': 'عمليات المسح الأخيرة',
      'view_all': 'عرض الكل',
      'market_title': 'السوق الهندسي',
      'market_subtitle': 'تواصل مع شركات هندسية معتمدة',
      'explore_market': 'استكشف السوق',
      'nav_home': 'الرئيسية',
      'nav_scan': 'فحص',
      'nav_reports': 'تقارير',
      'nav_market': 'السوق',
      'nav_profile': 'حسابي',
      'no_recent_activity': 'لا يوجد نشاط مؤخر',
      'building_name': 'اسم المبنى',
    },
  };

  static String tr(BuildContext context, String key) {
    // Basic way to get locale, ideally from a Provider
    // But for simplicity in plain calls, we assume context has inherited provider
    // or we pass locale directly.
    // Wait, accessing Provider here might be verbose in every widget.
    // Let's rely on the locale being passed or infer from Directionality as a fallback?
    // Better yet, let's make it accept a String languageCode.

    // However, to make it easy to use: AppStrings.of(context).welcome_back
    return key; // Placeholder, proper impl below
  }

  static String get(String languageCode, String key) {
    return _localizedValues[languageCode]?[key] ??
        _localizedValues['en']![key] ??
        key;
  }
}
