// ─────────────────────────────────────────────────────────────────────────
// Environment Configuration — CrackDetectX
// ─────────────────────────────────────────────────────────────────────────
//
// ⚠️  هذا الملف هو المكان الوحيد الذي تحتاج لتعديله عند تغيير الـ Backend URL
//
// الخطوات عند استلام الـ Base URL من فريق الـ Backend:
// 1. افتح هذا الملف  (lib/src/core/env.dart)
// 2. غير قيمة [_productionBaseUrl] بالـ URL الجديد
// 3. غير [_activeEnv] إلى [_Env.production]
// 4. شغّل التطبيق — خلاص! ✅
//
// مثال:
//   static const _productionBaseUrl = 'https://api.crackdetectx.com/api/v1';
//   static const _activeEnv = _Env.production;
//
// ─────────────────────────────────────────────────────────────────────────


// البيئات المتاحة
enum _Env { local, production }

class AppEnv {
  AppEnv._();

  // ══════════════════════════════════════════════════════════════
  //  ✏️  غيّر هذين السطرين فقط عند استلام الـ URL
  // ══════════════════════════════════════════════════════════════

  /// الـ Base URL للبيئة المحلية (localhost للتطوير)
  static const String _localBaseUrl = 'http://10.0.2.2:6000/api/v1';
  //                                   ↑ على Android Emulator استخدم 10.0.2.2
  //                                     على Windows/iOS جهاز حقيقي استخدم IP الـ PC مثل:
  //                                     'http://192.168.1.x:6000/api/v1'

  /// الـ Base URL للإنتاج — ضع هنا الـ URL الذي يرسله لك فريق الـ Backend
  static const String _productionBaseUrl = 'https://quartered-mascot-cinch.ngrok-free.dev/api/v1';

  /// البيئة النشطة حالياً
  /// - [_Env.local]      → يستخدم localhost
  /// - [_Env.production] → يستخدم الـ ngrok URL (الباك إند عند المطور)
  static const _Env _activeEnv = _Env.production;

  // ══════════════════════════════════════════════════════════════
  //  لا تغير شيئاً تحت هذا الخط
  // ══════════════════════════════════════════════════════════════

  /// الـ Base URL المستخدم في كل الـ API calls
  static String get baseUrl => switch (_activeEnv) {
        _Env.local      => _localBaseUrl,
        _Env.production => _productionBaseUrl,
      };

  /// هل نحن في بيئة الإنتاج؟
  static bool get isProduction => _activeEnv == _Env.production;

  /// هل نحن في بيئة التطوير المحلية؟
  static bool get isLocal => _activeEnv == _Env.local;

  /// Timeout settings (بالثواني)
  static const int connectTimeoutSeconds = 30;
  static const int receiveTimeoutSeconds = 30;
  static const int uploadTimeoutSeconds  = 120; // للصور

  @override
  String toString() => 'AppEnv(env: $_activeEnv, baseUrl: $baseUrl)';
}
