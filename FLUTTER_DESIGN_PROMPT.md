# CrackDetectX — توثيق التصميم الشامل (الحالة الفعلية الكاملة)

> **آخر تحديث:** أبريل 2026  
> **الحالة:** مكتمل وجاهز للتطوير  
> **إجمالي الشاشات:** 24 شاشة رئيسية + 9 شاشات لوحة إدارة  
> **اللغات:** العربية والإنجليزية (RTL/LTR كامل)  
> **الأدوار:** مهندس ميداني، مالك مبنى، شركة إصلاح، مسؤول (Admin)

---

## 📱 نظرة عامة على التطبيق

**CrackDetectX** تطبيق موبايل احترافي مدعوم بالذكاء الاصطناعي لفحص سلامة المباني. يتيح للمستخدمين رفع صور المباني لتحليلها واكتشاف التشققات والمخاطر الهيكلية، ويضم سوقاً هندسياً متكاملاً يربط أصحاب المباني بالشركات الهندسية المعتمدة، فضلاً عن لوحة تحكم إدارية شاملة تضم 9 شاشات.

---

## 🎨 نظام التصميم

### لوحة الألوان

```dart
// الوضع النهاري (Light Mode)
const Color primaryDark    = Color(0xFF1E3A8A);  // أزرق داكن — اللون الرئيسي للعلامة التجارية
const Color primaryLight   = Color(0xFF3B82F6);  // أزرق فاتح — لوني الإبراز
const Color primaryWhite   = Color(0xFFFFFFFF);  // أبيض — خلفية
const Color textPrimary    = Color(0xFF1F2937);  // رمادي داكن — نص رئيسي
const Color textSecondary  = Color(0xFF6B7280);  // رمادي متوسط — نص ثانوي
const Color backgroundLight= Color(0xFFF9FAFB);  // رمادي فاتح — خلفية البطاقات
const Color borderLight    = Color(0xFFE5E7EB);  // حدود فاتحة

// الوضع الليلي (Dark Mode)
const Color darkBackground = Color(0xFF111827);  // خلفية داكنة
const Color darkCard       = Color(0xFF1F2937);  // خلفية البطاقات الداكنة
const Color darkBorder     = Color(0xFF374151);  // حدود داكنة
const Color darkText       = Color(0xFFF9FAFB);  // نص فاتح

// لوحة الإدارة (Admin Sidebar)
const Color adminSidebarBg = Color(0xFF0F1E4A);  // خلفية الشريط الجانبي

// ألوان مستويات الخطورة
const Color riskLow        = Color(0xFF10B981);  // أخضر
const Color riskModerate   = Color(0xFFF59E0B);  // برتقالي
const Color riskHigh       = Color(0xFFEF4444);  // أحمر
const Color riskCritical   = Color(0xFF7C3AED);  // بنفسجي

// ألوان الحالة
const Color success        = Color(0xFF10B981);
const Color warning        = Color(0xFFF59E0B);
const Color error          = Color(0xFFEF4444);
const Color info           = Color(0xFF3B82F6);

// تأثيرات المسح بالذكاء الاصطناعي
const Color aiScanBlue     = Color(0xFF60A5FA);
const Color aiScanCyan     = Color(0xFF06B6D4);
```

### الخطوط

```dart
// الإنجليزية: Inter أو Poppins
// العربية: Cairo أو Tajawal

TextStyle h1 = TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -0.5);
TextStyle h2 = TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: -0.3);
TextStyle h3 = TextStyle(fontSize: 20, fontWeight: FontWeight.w600);
TextStyle h4 = TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
TextStyle bodyLarge  = TextStyle(fontSize: 16, fontWeight: FontWeight.normal);
TextStyle bodyMedium = TextStyle(fontSize: 14, fontWeight: FontWeight.normal);
TextStyle bodySmall  = TextStyle(fontSize: 12, fontWeight: FontWeight.normal);
TextStyle caption    = TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: textSecondary);
TextStyle button     = TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.5);
```

### نظام المسافات

```dart
const double space4  = 4.0;
const double space8  = 8.0;
const double space12 = 12.0;
const double space16 = 16.0;
const double space20 = 20.0;
const double space24 = 24.0;
const double space32 = 32.0;
const double space40 = 40.0;
const double space48 = 48.0;
const double space64 = 64.0;
```

### نصف قطر الحواف

```dart
const double radiusSmall  = 8.0;
const double radiusMedium = 12.0;
const double radiusLarge  = 16.0;
const double radiusXLarge = 24.0;
const double radiusFull   = 9999.0;
```

### الظلال

```dart
BoxShadow shadowSmall  = BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4,  offset: Offset(0, 2));
BoxShadow shadowMedium = BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8,  offset: Offset(0, 4));
BoxShadow shadowLarge  = BoxShadow(color: Colors.black.withOpacity(0.1),  blurRadius: 16, offset: Offset(0, 8));
BoxShadow aiGlow       = BoxShadow(color: aiScanBlue.withOpacity(0.3),    blurRadius: 20, offset: Offset(0, 0));
```

---

## 🗂️ مكتبة المكوّنات

### 1. الأزرار

#### الزر الرئيسي (Gradient)
```dart
Container(
  width: double.infinity,
  height: 56,
  decoration: BoxDecoration(
    gradient: LinearGradient(colors: [primaryDark, primaryLight]),
    borderRadius: BorderRadius.circular(radiusMedium),
    boxShadow: [shadowMedium],
  ),
  child: Material(
    color: Colors.transparent,
    child: InkWell(
      borderRadius: BorderRadius.circular(radiusMedium),
      onTap: onPressed,
      child: Center(child: Text('نص الزر', style: button.copyWith(color: Colors.white))),
    ),
  ),
)
```

#### الزر الثانوي (Outlined)
```dart
Container(
  width: double.infinity, height: 56,
  decoration: BoxDecoration(
    border: Border.all(color: primaryLight, width: 2),
    borderRadius: BorderRadius.circular(radiusMedium),
  ),
  child: Center(child: Text('نص الزر', style: button.copyWith(color: primaryLight))),
)
```

#### زر الإدارة (Admin Dark)
```dart
// الزر المستخدم في شاشة تسجيل الدخول للوصول للوحة الإدارة
Container(
  width: double.infinity, height: 48,
  decoration: BoxDecoration(
    color: Color(0xFF0F1E4A),  // adminSidebarBg
    borderRadius: BorderRadius.circular(radiusLarge),
  ),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.shield, color: Colors.white, size: 18),
      SizedBox(width: space8),
      Text('دخول لوحة الإدارة (تجريبي)', style: bodySmall.copyWith(color: Colors.white)),
    ],
  ),
)
```

### 2. شارة مستوى الخطورة
```dart
Container(
  padding: EdgeInsets.symmetric(horizontal: space12, vertical: space8),
  decoration: BoxDecoration(
    color: getRiskColor(riskLevel).withOpacity(0.1),
    borderRadius: BorderRadius.circular(radiusFull),
    border: Border.all(color: getRiskColor(riskLevel), width: 1.5),
  ),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(width: 8, height: 8, decoration: BoxDecoration(color: getRiskColor(riskLevel), shape: BoxShape.circle)),
      SizedBox(width: space8),
      Text(riskText, style: bodySmall.copyWith(color: getRiskColor(riskLevel), fontWeight: FontWeight.w600)),
    ],
  ),
)
```

> مستويات الخطورة: **منخفض** (أخضر) | **متوسط** (برتقالي) | **مرتفع** (أحمر) | **حرج** (بنفسجي)

### 3. دائرة نقاط الصحة
```dart
Stack(
  alignment: Alignment.center,
  children: [
    SizedBox(
      width: 120, height: 120,
      child: CircularProgressIndicator(
        value: healthScore / 100,
        strokeWidth: 12,
        backgroundColor: backgroundLight,
        valueColor: AlwaysStoppedAnimation<Color>(getScoreColor(healthScore)),
      ),
    ),
    Column(mainAxisSize: MainAxisSize.min, children: [
      Text('${healthScore.toInt()}', style: h1.copyWith(color: primaryDark)),
      Text('نقاط الصحة', style: caption),
    ]),
  ],
)
```

### 4. شريط التنقل السفلي
```dart
BottomNavigationBar(
  currentIndex: currentIndex,
  onTap: onIndexChanged,
  type: BottomNavigationBarType.fixed,
  backgroundColor: Colors.white,
  selectedItemColor: primaryLight,
  unselectedItemColor: textSecondary,
  items: [
    BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'الرئيسية'),
    BottomNavigationBarItem(icon: Icon(Icons.scanner_outlined), activeIcon: Icon(Icons.scanner), label: 'فحص'),
    BottomNavigationBarItem(icon: Icon(Icons.description_outlined), activeIcon: Icon(Icons.description), label: 'التقارير'),
    BottomNavigationBarItem(icon: Icon(Icons.store_outlined), activeIcon: Icon(Icons.store), label: 'السوق'),
    BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'حسابي'),
  ],
)
```

---

## 📱 شاشات التطبيق الرئيسية (24 شاشة)

---

### الشاشة 1: شاشة البداية (Splash Screen)
**المسار:** `screens/SplashScreen`  
**المدة:** 2-3 ثوان

**المكوّنات:**
- خلفية متدرجة من `primaryDark` إلى `primaryLight`
- شعار التطبيق (أيقونة مبنى) في المركز بحجم 120
- اسم التطبيق "CrackDetectX" بنص أبيض متدرج
- نص ثانوي: "AI-Powered Building Inspector"
- مؤشر تحميل دائري أبيض في الأسفل

```dart
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [primaryDark, primaryLight]),
  ),
  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    Icon(Icons.construction, size: 120, color: Colors.white),
    SizedBox(height: space24),
    Text('CrackDetectX', style: h1.copyWith(color: Colors.white, fontSize: 36)),
    SizedBox(height: space8),
    Text('AI-Powered Building Inspector', style: bodyMedium.copyWith(color: Colors.white70)),
    SizedBox(height: space64),
    CircularProgressIndicator(color: Colors.white),
  ]),
)
```

**التنقل:** بعد انتهاء المؤقت ← شاشة Onboarding

---

### الشاشة 2: شاشة التعريف (Onboarding — 3 صفحات)
**المسار:** `screens/OnboardingScreen`

**الميزات:**
- `PageView` قابل للسحب مع 3 صفحات
- مؤشرات نقاط أسفل الشاشة
- زر "تخطي" في الزاوية العلوية
- زر "التالي" / "ابدأ الآن"
- دعم RTL كامل

**الصفحة 1 — الترحيب:**
- رسم توضيحي: مبنى مع تأثير مسح الذكاء الاصطناعي
- العنوان: "مرحباً بك في CrackDetectX"
- النص: "فحص المباني بالذكاء الاصطناعي بين يديك"

**الصفحة 2 — الذكاء الاصطناعي:**
- رسم توضيحي: ذكاء اصطناعي يحلل التشققات
- العنوان: "كشف متقدم بالذكاء الاصطناعي"
- النص: "اكتشف التشققات والمخاطر الهيكلية فوراً"

**الصفحة 3 — السوق:**
- رسم توضيحي: مهندسون وشركات
- العنوان: "تواصل مع الخبراء"
- النص: "احصل على عروض أسعار من شركات هندسية معتمدة"

**التنقل:** إتمام → شاشة تسجيل الدخول

---

### الشاشة 3: شاشة تسجيل الدخول (Login Screen)
**المسار:** `screens/LoginScreen`

**المكوّنات:**
- أيقونة المبنى في المركز (دائرة بلون `primaryDark`)
- حقل البريد الإلكتروني مع أيقونة بريد
- حقل كلمة المرور مع زر إظهار/إخفاء (Eye / EyeOff)
- رابط "نسيت كلمة المرور؟"
- زر "تسجيل الدخول" بتدرج لوني
- رابط "إنشاء حساب جديد"
- **زر الإدارة (تجريبي):** زر منفصل بلون `0xFF0F1E4A` مع أيقونة Shield للوصول إلى لوحة التحكم الإدارية — يظهر في الأسفل تحت خط فاصل مع نص "للمراجعة والعروض التقديمية فقط"
- دعم RTL/LTR حسب اللغة المحددة
- i18n كامل (العربية/الإنجليزية)

**التنقل:**
- تسجيل الدخول الطبيعي → شاشة Home
- زر الإدارة (تجريبي) → AdminPanel (لوحة تحكم منفصلة بالكامل)
- إنشاء حساب → شاشة Register

---

### الشاشة 4: شاشة إنشاء الحساب (Register Screen)
**المسار:** `screens/RegisterScreen`

**حقول النموذج:**
- الاسم الكامل
- البريد الإلكتروني
- رقم الهاتف
- كلمة المرور (مع مؤشر قوة كلمة المرور)
- تأكيد كلمة المرور
- مربع الموافقة على الشروط والأحكام
- زر "إنشاء الحساب"
- رابط "لديك حساب بالفعل؟ تسجيل الدخول"

**التنقل:** نجاح التسجيل → شاشة Home

---

### الشاشة 5: لوحة التحكم الرئيسية (Home Screen)
**المسار:** `screens/HomeScreen`

**قسم أ — الرأس (Header):**
- صورة المستخدم (دائرية)
- نص ترحيبي: "مرحباً، [الاسم]"
- أيقونة الإشعارات (مع شارة عدد)
- دعم RTL

**قسم ب — بطاقات الإحصائيات السريعة (صف أفقي):**
```dart
Row(children: [
  StatCard(value: '24', label: 'إجمالي الفحوص'),
  StatCard(value: '8',  label: 'مبانٍ تحت المراقبة'),
  StatCard(value: '12', label: 'التقارير المنشأة'),
])
// بتدرج لوني من primaryDark إلى primaryLight
```

**قسم ج — الإجراءات السريعة (شبكة 2×2):**
- **فحص جديد** (زر رئيسي بتدرج) → شاشة Upload
- **عرض التقارير** → شاشة History
- **مشاريعي** → شاشة My Projects
- **ابحث عن مهندسين** → شاشة Marketplace

**قسم د — الفحوص الأخيرة (قائمة عمودية):**
بطاقة لكل فحص تشمل:
- صورة مصغرة للمبنى
- اسم المبنى / الموقع
- نقاط الصحة
- شارة مستوى الخطورة
- التاريخ
- سهم للعرض التفصيلي

---

### الشاشة 6: شاشة رفع الصور (Upload Screen)
**المسار:** `screens/UploadScreen`

**قسم أ — منطقة السحب والإفلات:**
```dart
DottedBorder(
  color: primaryLight, strokeWidth: 2, dashPattern: [8, 4],
  child: Container(
    height: 300,
    color: primaryLight.withOpacity(0.05),
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.cloud_upload_outlined, size: 80, color: primaryLight),
      Text('اسحب وأفلت صورتك هنا'),
      Text('أو'),
      ElevatedButton(onPressed: pickImage, child: Text('اختر ملف')),
      Text('الصيغ المدعومة: JPG، PNG، HEIC'),
      Text('الحجم الأقصى: 10 ميغابايت'),
    ]),
  ),
)
```

**قسم ب — معاينة الصور المرفوعة:**
- شبكة من الصور المصغرة
- أيقونة حذف على كل صورة
- زر "إضافة المزيد"

**قسم ج — نموذج بيانات المبنى:**
- حقل الموقع
- قائمة منسدلة لنوع المبنى
- حقل ملاحظات إضافية

**قسم د — زر بدء التحليل** (ثابت في الأسفل)

---

### الشاشة 7: شاشة المسح بالذكاء الاصطناعي (Scanning Screen)
**المسار:** `screens/ScanningScreen`

**قسم أ — تأثير المسح المتحرك:**
```dart
Stack(alignment: Alignment.center, children: [
  Image.network(imageUrl),
  // خط مسح متحرك
  AnimatedBuilder(
    animation: scanAnimation,
    builder: (context, child) {
      return Positioned(
        top: scanAnimation.value * imageHeight,
        left: 0, right: 0,
        child: Container(
          height: 4,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.transparent, aiScanBlue, aiScanCyan, aiScanBlue, Colors.transparent,
            ]),
            boxShadow: [aiGlow],
          ),
        ),
      );
    },
  ),
  // إطارات التشققات المكتشفة
  ...detectedCracks.map((crack) {
    return Positioned(
      left: crack.x, top: crack.y,
      child: Container(
        width: crack.width, height: crack.height,
        decoration: BoxDecoration(border: Border.all(color: riskHigh, width: 2), borderRadius: BorderRadius.circular(radiusSmall)),
      ),
    );
  }),
])
```

**قسم ب — شريط التقدم:**
```dart
Column(children: [
  LinearProgressIndicator(value: progress, color: primaryLight, minHeight: 8),
  SizedBox(height: space16),
  Text('${(progress * 100).toInt()}%', style: h3),
])
```

**قسم ج — رسائل الحالة المتحركة:**
- "جاري تحليل الصورة..."
- "اكتشاف التشققات..."
- "حساب مستوى الخطورة..."
- "إنشاء التقرير..."

---

### الشاشة 8: شاشة النتائج (Results Screen)
**المسار:** `screens/ResultsScreen`

**قسم أ — بطاقة الصحة الكلية:**
```dart
Container(
  padding: EdgeInsets.all(space24),
  decoration: BoxDecoration(
    gradient: LinearGradient(colors: [primaryDark, primaryLight]),
    borderRadius: BorderRadius.circular(radiusXLarge),
    boxShadow: [shadowLarge],
  ),
  child: Column(children: [
    Text('الصحة العامة', style: h3.copyWith(color: Colors.white)),
    SizedBox(height: space24),
    // دائرة نقاط الصحة البيضاء
    Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      Column(children: [
        Text('12', style: h2.copyWith(color: Colors.white)),
        Text('تشقق مكتشف', style: caption.copyWith(color: Colors.white70)),
      ]),
      Container(width: 1, height: 40, color: Colors.white30),
      Column(children: [
        Text('15%', style: h2.copyWith(color: Colors.white)),
        Text('نسبة التشقق', style: caption.copyWith(color: Colors.white70)),
      ]),
    ]),
  ]),
)
```

**قسم ب — شارة مستوى الخطورة** (كبيرة في المنتصف)

**قسم ج — النتائج التفصيلية (تبويبات):**
- الكل | تشققات رئيسية | تشققات ثانوية | تلف سطحي
- لكل نتيجة: صورة مصغرة، وصف، مؤشر شدة، إحداثيات الموقع

**قسم د — قسم التوصيات:**
- بطاقة لكل توصية مع أيقونة ولون حسب الأولوية

**قسم هـ — أزرار الإجراءات:**
- "عرض التقرير الكامل" (رئيسي)
- "نشر في السوق الهندسي" (ثانوي + أيقونة)
- "حفظ التقرير" (ثانوي)

---

### الشاشة 9: شاشة التقرير التفصيلي (Report Screen)
**المسار:** `screens/ReportScreen`

**قسم أ — بطاقة معلومات المبنى:**
- الموقع مع أيقونة خريطة
- نوع المبنى
- تاريخ الفحص
- اسم المفتش

**قسم ب — ملخص تحليل الذكاء الاصطناعي:**
- نقاط الصحة
- إجمالي التشققات
- نسبة التشقق
- تقييم السلامة الهيكلية

**قسم ج — رسم بياني لتوزيع التشققات:**
```dart
// رسم دائري (PieChart) يُظهر:
// - تشققات أفقية
// - تشققات رأسية
// - تشققات قطرية
```

**قسم د — رسم بياني لتوزيع الشدة:**
```dart
// BarChart يُظهر:
// - حرج | مرتفع | متوسط | منخفض
```

**قسم هـ — جدول تفاصيل التشققات:**
```dart
DataTable(
  columns: [
    DataColumn(label: Text('المعرف')),
    DataColumn(label: Text('النوع')),
    DataColumn(label: Text('الشدة')),
    DataColumn(label: Text('الموقع')),
  ],
  rows: cracks.map((crack) => DataRow(cells: [
    DataCell(Text(crack.id)),
    DataCell(Text(crack.type)),
    DataCell(RiskBadge(level: crack.severity)),
    DataCell(Text(crack.location)),
  ])).toList(),
)
```

**قسم و — معرض الصور:**
- الصورة الأصلية
- الصورة مع تعليقات التشققات
- صور مقربة للتشققات الرئيسية

**قسم ز — توصيات الخبراء التفصيلية** مع مستويات الأولوية

**قسم ح — أزرار الأسفل:**
- تحميل PDF
- مشاركة التقرير
- طباعة

---

### الشاشة 10: شاشة السجل (History Screen)
**المسار:** `screens/HistoryScreen`

**قسم أ — الفلاتر والتبويبات:**
- تبويبات: كل الفحوص | هذا الشهر | آخر 3 أشهر | هذا العام
- قائمة منسدلة للترتيب: التاريخ | نقاط الصحة | مستوى الخطورة

**قسم ب — بطاقات الإحصائيات:**
```dart
Row(children: [
  StatCard(title: 'إجمالي الفحوص', value: '24', icon: Icons.scanner),
  StatCard(title: 'متوسط الصحة', value: '78%', icon: Icons.health_and_safety),
])
```

**قسم ج — قائمة سجل الفحوص:**
لكل عنصر:
- صورة مصغرة للمبنى
- اسم المبنى
- تاريخ الفحص
- شريط تقدم لنقاط الصحة
- شارة مستوى الخطورة
- الضغط للعرض التفصيلي

---

### الشاشة 11: شاشة الملف الشخصي (Profile Screen)
**المسار:** `screens/ProfileScreen`

**قسم أ — الرأس:**
```dart
Container(
  padding: EdgeInsets.all(space24),
  decoration: BoxDecoration(gradient: LinearGradient(colors: [primaryDark, primaryLight])),
  child: Column(children: [
    CircleAvatar(radius: 50, backgroundColor: Colors.white, child: Icon(Icons.person, size: 50, color: primaryDark)),
    SizedBox(height: space16),
    Text('وليد أبوزيد', style: h3.copyWith(color: Colors.white)),
    Text('walid@example.com', style: bodyMedium.copyWith(color: Colors.white70)),
    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.verified, color: success, size: 20),
      SizedBox(width: space4),
      Text('مستخدم موثق', style: bodySmall.copyWith(color: Colors.white)),
    ]),
  ]),
)
```

**قسم ب — بطاقات الإحصائيات:**
- إجمالي الفحوص | المباني تحت المراقبة | التقارير المنشأة | عضو منذ

**قسم ج — قائمة الإعدادات:**
- تعديل الملف الشخصي
- تغيير كلمة المرور
- إعدادات الإشعارات
- اللغة والمنطقة
- الخصوصية والأمان
- المساعدة والدعم
- عن CrackDetectX
- تسجيل الخروج (باللون الأحمر)

---

### الشاشة 12: شاشة الإعدادات (Settings Screen)
**المسار:** `screens/SettingsScreen`

**قسم أ — إعدادات الحساب:**
- تعديل الملف الشخصي
- تغيير كلمة المرور
- حذف الحساب

**قسم ب — تفضيلات التطبيق:**
```dart
// اختيار اللغة
ListTile(
  title: Text('اللغة'),
  trailing: DropdownButton<String>(
    value: currentLanguage,
    items: [
      DropdownMenuItem(value: 'ar', child: Text('العربية')),
      DropdownMenuItem(value: 'en', child: Text('English')),
    ],
    onChanged: (value) => changeLanguage(value),
  ),
)

// تبديل الوضع الليلي
SwitchListTile(
  title: Text('الوضع الليلي'),
  subtitle: Text('التبديل بين السمة الفاتحة والداكنة'),
  value: isDarkMode,
  onChanged: toggleDarkMode,
  activeColor: primaryLight,
)
```

**قسم ج — إعدادات الفحص:**
- الحفظ التلقائي
- وضع الجودة العالية
- تفضيلات الإشعارات

**قسم د — الخصوصية والأمان:**
- موقع تخزين البيانات
- مسح ذاكرة التخزين المؤقت
- سياسة الخصوصية
- الشروط والأحكام

**قسم هـ — عن التطبيق:**
- إصدار التطبيق
- التواصل مع الدعم
- تقييم التطبيق
- تابعنا على وسائل التواصل الاجتماعي

---

### الشاشة 13: شاشة الإشعارات (Notifications Screen)
**المسار:** `screens/NotificationsScreen`

**المكوّنات:**
- قائمة الإشعارات مُصنّفة حسب التاريخ
- أيقونات متميزة لكل نوع (تشقق، سوق، نظام)
- علامة "مقروء / غير مقروء"
- إجراءات السحب للحذف أو التحديد كمقروء
- زر "تحديد الكل كمقروء"

---

## 🏪 شاشات السوق الهندسي (7 شاشات)

---

### الشاشة 14: الصفحة الرئيسية للسوق (Marketplace Home)
**المسار:** `screens/marketplace/MarketplaceHome`

**قسم أ — الرأس:**
- عنوان "السوق الهندسي"
- شريط بحث
- أيقونة فلتر

**قسم ب — تبديل دور المستخدم:**
```dart
Container(
  padding: EdgeInsets.all(space4),
  decoration: BoxDecoration(color: backgroundLight, borderRadius: BorderRadius.circular(radiusMedium)),
  child: Row(children: [
    Expanded(child: RoleTab(title: 'مالك مبنى',  icon: Icons.home,     isSelected: role == 'owner')),
    Expanded(child: RoleTab(title: 'شركة هندسية', icon: Icons.business, isSelected: role == 'company')),
  ]),
)
```

**لمالك المبنى:**
- زر "إنشاء طلب جديد"
- طلباتي النشطة (مع شارة عدد)
- العروض الواردة (مع شارة عدد)
- تصفح الشركات

**للشركة الهندسية:**
- إحصائيات لوحة تحكم الشركة
- تصفح الطلبات المتاحة
- عروضي المقدمة
- المشاريع النشطة

---

### الشاشة 15: إنشاء طلب ترميم (Post Project / Create Request)
**المسار:** `screens/marketplace/PostProject`

**حقول النموذج:**
```dart
Form(child: ListView(padding: EdgeInsets.all(space20), children: [
  TextFormField(decoration: InputDecoration(labelText: 'عنوان الطلب')),
  TextFormField(maxLines: 4, decoration: InputDecoration(labelText: 'الوصف')),
  
  Text('بيانات المبنى', style: h4),
  Row(children: [
    TextFormField(decoration: InputDecoration(labelText: 'عمر المبنى', suffixText: 'سنة')),
    TextFormField(decoration: InputDecoration(labelText: 'عدد الأدوار')),
  ]),
  Row(children: [
    TextFormField(decoration: InputDecoration(labelText: 'المساحة', suffixText: 'م²')),
    TextFormField(decoration: InputDecoration(labelText: 'الميزانية', prefixText: 'ج.م ')),
  ]),
  
  Text('الجدول الزمني', style: h4),
  Wrap(spacing: space8, children: [
    ChoiceChip(label: Text('عاجل (7 أيام)'), selected: timeline == 'urgent'),
    ChoiceChip(label: Text('شهر واحد'),       selected: timeline == '1month'),
    ChoiceChip(label: Text('3 أشهر'),          selected: timeline == '3months'),
    ChoiceChip(label: Text('مرن'),             selected: timeline == 'flexible'),
  ]),
  
  // إرفاق تقرير الفحص من السجل
  Card(child: ListTile(
    leading: Icon(Icons.attach_file, color: primaryLight),
    title: Text('إرفاق تقرير الفحص'),
    trailing: Icon(Icons.chevron_right),
    onTap: showReportSelector,
  )),
  
  Text('الخدمات المطلوبة', style: h4),
  CheckboxListTile(title: Text('تقييم هيكلي'), value: services.contains('assessment')),
  CheckboxListTile(title: Text('أعمال ترميم'),  value: services.contains('repair')),
  CheckboxListTile(title: Text('استشارة'),      value: services.contains('consultation')),
  CheckboxListTile(title: Text('مراقبة دورية'), value: services.contains('monitoring')),
  
  ElevatedButton(onPressed: publishListing, child: Text('نشر الطلب')),
]))
```

---

### الشاشة 16: تفاصيل الطلب (Project Details)
**المسار:** `screens/marketplace/ProjectDetails`

**المكوّنات:**
- معلومات المشروع (العنوان، الموقع، الميزانية، الجدول الزمني)
- تقرير الفحص المرفق (ملخص مع رابط للتقرير الكامل)
- قائمة العروض الواردة (لمالك المبنى)
- حالة المشروع
- أزرار: قبول عرض | إغلاق الطلب | تعديل الطلب

---

### الشاشة 17: مشاريعي (My Projects)
**المسار:** `screens/marketplace/MyProjects`

**تبويبات:**
- نشط | منتهي | مسودة

لكل مشروع:
- عنوان المشروع
- التاريخ والميزانية
- عدد العروض الواردة
- شريط تقدم حالة المشروع
- الضغط لعرض التفاصيل

---

### الشاشة 18: تصفح الشركات / تفاصيل الشركة (Company Details)
**المسار:** `screens/marketplace/CompanyDetails`

**قسم أ — الرأس:**
```dart
Container(
  padding: EdgeInsets.all(space24),
  decoration: BoxDecoration(gradient: LinearGradient(colors: [primaryDark, primaryLight])),
  child: Column(children: [
    CircleAvatar(radius: 50, backgroundImage: NetworkImage(company.logo)),
    SizedBox(height: space16),
    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(company.name, style: h3.copyWith(color: Colors.white)),
      if (company.verified) Icon(Icons.verified, color: success, size: 24),
    ]),
    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.star, color: warning, size: 20),
      Text('${company.rating} (${company.reviews} تقييم)', style: bodyMedium.copyWith(color: Colors.white)),
    ]),
  ]),
)
```

**قسم ب — الإحصائيات السريعة:**
```dart
Row(children: [
  StatCard(icon: Icons.check_circle, value: '${company.completedProjects}', label: 'مشروع مكتمل'),
  StatCard(icon: Icons.access_time,  value: '${company.avgResponseTime}س',  label: 'وقت الاستجابة'),
  StatCard(icon: Icons.thumb_up,     value: '${company.successRate}%',       label: 'معدل النجاح'),
])
```

**قسم ج — معلومات الشركة:**
- الوصف | سنوات الخبرة | حجم الفريق | مناطق الخدمة

**قسم د — التخصصات:**
```dart
Wrap(spacing: space8, runSpacing: space8, children: company.specializations.map((spec) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: space12, vertical: space8),
    decoration: BoxDecoration(
      color: primaryLight.withOpacity(0.1),
      borderRadius: BorderRadius.circular(radiusFull),
      border: Border.all(color: primaryLight),
    ),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(Icons.check, color: primaryLight, size: 16),
      Text(spec, style: bodySmall.copyWith(color: primaryDark)),
    ]),
  );
}).toList())
```

**قسم هـ — الشهادات والتراخيص** (شبكة شارات)

**قسم و — المشاريع الأخيرة** (قائمة أفقية بصور غلاف)

**قسم ز — التقييمات والمراجعات** (ملخص + تقييمات فردية)

**قسم ح — أزرار الأسفل:**
```dart
Row(children: [
  Expanded(flex: 2, child: ElevatedButton.icon(icon: Icon(Icons.request_quote), label: Text('طلب عرض سعر'))),
  Expanded(child: OutlinedButton.icon(icon: Icon(Icons.message), label: Text('تواصل'))),
])
```

---

### الشاشة 19: طلب عرض سعر (Quote Request)
**المسار:** `screens/marketplace/QuoteRequest`

**المكوّنات:**
- معلومات الشركة (مختصرة) في الأعلى
- نموذج تفاصيل المشروع
- وصف المشكلة
- نطاق الميزانية المتوقعة
- الجدول الزمني المطلوب
- رفع صور إضافية
- زر "إرسال طلب العرض"

---

### الشاشة 20: التواصل مع الشركة (Contact Company)
**المسار:** `screens/marketplace/ContactCompany`

**المكوّنات:**
- واجهة محادثة مباشرة (Chat UI)
- معلومات الشركة في الرأس
- مربع إدخال الرسالة مع أيقونة إرفاق
- زر إرسال
- عرض الرسائل السابقة

---

## 🛡️ لوحة تحكم المسؤول (Admin Panel — 9 شاشات)

> **الحالة:** مكتملة وتعمل فعلياً  
> **الوصول:** من شاشة تسجيل الدخول عبر زر "دخول لوحة الإدارة (تجريبي)"  
> **الاتجاه:** RTL بالكامل  
> **لون الشريط الجانبي:** `0xFF0F1E4A`

### هيكل الشريط الجانبي (AdminPanel)
**المسار:** `components/admin/AdminPanel`

```dart
// الشريط الجانبي المنزلق
Drawer(
  backgroundColor: Color(0xFF0F1E4A),
  child: Column(children: [
    // الشعار
    DrawerHeader(child: Row(children: [
      Icon(Icons.scan_qr, color: Colors.white),
      Column(children: [
        Text('CrackDetectX', style: bodyMedium.copyWith(color: Colors.white)),
        Text('لوحة الإدارة',  style: caption.copyWith(color: Colors.blue[300])),
      ]),
      // زر طي/توسيع الشريط
    ])),
    
    // عناصر التنقل (9 عناصر)
    // العنصر النشط يحصل على تدرج أزرق ومؤشر جانبي
    // العناصر غير النشطة: نص أبيض شفاف
    // الشارات: دائرة ملونة (برتقالية للشركات، حمراء للتذاكر)
    
    // معلومات المسؤول + زر تسجيل الخروج في الأسفل
    UserTile(
      avatar: ShieldIcon,
      name: 'المسؤول الرئيسي',
      email: 'admin@crackdetectx.com',
    ),
  ]),
)
```

**عناصر التنقل الـ 9:**

| المفتاح | الاسم | الأيقونة | الشارة |
|---------|-------|---------|-------|
| `dashboard`     | لوحة التحكم           | LayoutDashboard | — |
| `companies`     | التحقق من الشركات      | Building2       | عدد الشركات المعلقة (برتقالي) |
| `requests`      | إدارة الطلبات          | ClipboardList   | — |
| `bids`          | عروض الأسعار          | Gavel           | — |
| `contracts`     | العقود                | FileSignature   | — |
| `tickets`       | تذاكر الدعم           | MessageSquare   | عدد التذاكر المفتوحة (أحمر) |
| `users`         | المستخدمون            | Users           | — |
| `notifications` | مركز الإشعارات        | Bell            | — |
| `system`        | مراقبة النظام          | Activity        | — |

---

### شاشة الإدارة 1: لوحة التحكم (Admin Dashboard)
**المسار:** `components/admin/AdminDashboard`

**قسم أ — بطاقات KPI (شبكة 4 × 2):**
```
المستخدمون الكليون  | الشركات المعلقة | الطلبات النشطة | التذاكر المفتوحة
إجمالي الفحوص      | نمو المستخدمين | العقود المعتمدة | الإيرادات
```
كل بطاقة تشمل:
- أيقونة بلون خلفية متدرج
- القيمة الرئيسية (رقم كبير)
- الاسم
- التغيير مقارنة بالشهر الماضي (نسبة مئوية مع سهم)

**قسم ب — الرسوم البيانية (4 مخططات بـ Recharts):**

1. **LineChart** — نمو المستخدمين الشهري (أكتوبر → أبريل)
2. **AreaChart** — الفحوص الشهرية
3. **PieChart** — توزيع مستويات الخطورة (منخفض/متوسط/مرتفع/حرج)
4. **BarChart** — الطلبات الشهرية (مستلمة vs مكتملة)

> **ملاحظة مهمة:** جميع مفاتيح recharts نصية فريدة مبنية على بيانات العناصر وليس أرقاماً، لتجنب خطأ duplicate keys.

**قسم ج — النشاط الأخير:**
قائمة بآخر 6 أحداث في النظام مع:
- أيقونة النشاط مع خلفية ملونة
- وصف النشاط
- الوقت (منذ X دقيقة/ساعة)

**قسم د — التنبيهات العاجلة:**
بطاقات صغيرة لـ:
- الشركات في انتظار الموافقة
- التذاكر المفتوحة
- الطلبات المُبلَّغ عنها

---

### شاشة الإدارة 2: التحقق من الشركات (Company Verification)
**المسار:** `components/admin/CompanyVerification`

**الميزات:**
- قائمة الشركات مُصنّفة (معلقة / مقبولة / مرفوضة)
- فلتر بالحالة وشريط بحث
- بطاقة تفاصيل لكل شركة تشمل:
  - اسم الشركة، المالك، البريد، الهاتف، المدينة
  - الفئة ورقم الترخيص
  - قائمة المستندات المرفوعة مع حالة التحقق لكل مستند (✓/✗)
  - وصف الشركة
- أزرار: **قبول** (أخضر) | **رفض** (أحمر) مع حقل سبب الرفض
- عرض سبب الرفض للشركات المرفوضة

**نماذج البيانات (adminData.ts):**
```typescript
interface AdminCompany {
  id: number;
  name: string;
  ownerName: string;
  email: string;
  phone: string;
  category: string;
  city: string;
  status: 'pending' | 'approved' | 'rejected';
  documents: { name: string; type: string; verified: boolean }[];
  rating: number;
  totalProjects: number;
  joinDate: string;
  licenseNumber: string;
  description: string;
  rejectionReason?: string;
}
```

**شركات في البيانات التجريبية (6 شركات):**
- شركة الإنشاءات المتحدة (معلق)
- مجموعة البناء الحديث (معلق)
- شركة النيل للمقاولات (مقبول ✓)
- مؤسسة الجودة للإنشاءات (مقبول ✓)
- شركة الأمان الهندسي (مرفوض ✗)
- تطوير البنية التحتية (معلق)

---

### شاشة الإدارة 3: إدارة الطلبات (Requests Management)
**المسار:** `components/admin/RequestsManagement`

**الميزات:**
- جدول الطلبات مع أعمدة: المعرف | العنوان | صاحب الطلب | المدينة | الميزانية | الحالة | مستوى الخطورة | عدد العروض | التاريخ
- فلتر بالحالة (مفتوح/قيد التنفيذ/مكتمل/تحت التحقيق/مغلق)
- بحث بالاسم أو الموقع
- عرض علامة التحقيق للطلبات المُبلَّغ عنها مع السبب
- إجراءات: عرض التفاصيل | وضع علامة تحقيق | إغلاق الطلب

```typescript
interface AdminRequest {
  id: number;
  title: string;
  ownerName: string;
  ownerId: number;
  location: string;
  city: string;
  budget: number;
  status: 'open' | 'in_progress' | 'completed' | 'flagged' | 'closed';
  riskLevel: 'low' | 'medium' | 'high' | 'critical';
  description: string;
  bidsCount: number;
  createdAt: string;
  scanId?: number;
  flagReason?: string;
}
```

---

### شاشة الإدارة 4: مراقبة عروض الأسعار (Bids Monitoring)
**المسار:** `components/admin/BidsMonitoring`

**الميزات:**
- جدول العروض المقدمة مع: الطلب المرتبط | اسم الشركة | مبلغ العرض | مدة التنفيذ | الحالة | تاريخ التقديم
- فلتر بحالة العرض (معلق/مقبول/مرفوض/منسحب)
- إحصائيات سريعة: إجمالي العروض | عروض اليوم | متوسط قيمة العرض | نسبة القبول

```typescript
interface AdminBid {
  id: number;
  requestId: number;
  requestTitle: string;
  companyName: string;
  companyId: number;
  amount: number;
  deliveryDays: number;
  status: 'pending' | 'accepted' | 'rejected' | 'withdrawn';
  submittedAt: string;
  notes: string;
}
```

---

### شاشة الإدارة 5: مراقبة العقود (Contracts Monitoring)
**المسار:** `components/admin/ContractsMonitoring`

**الميزات:**
- قائمة العقود النشطة والمكتملة والملغاة والمتنازع عليها
- لكل عقد:
  - شريط تقدم (Progress Bar) لنسبة الإنجاز
  - قيمة العقد | تواريخ البداية والنهاية | المدينة
  - اسم الشركة المنفذة | اسم صاحب المشروع
- فلتر بالحالة

```typescript
interface AdminContract {
  id: number;
  requestId: number;
  requestTitle: string;
  companyName: string;
  ownerName: string;
  value: number;
  startDate: string;
  endDate: string;
  status: 'active' | 'completed' | 'cancelled' | 'disputed';
  progress: number;  // 0-100
  city: string;
}
```

---

### شاشة الإدارة 6: تذاكر الدعم (Support Tickets)
**المسار:** `components/admin/SupportTickets`

**الميزات:**
- قائمة التذاكر مع: المعرف | المستخدم | الموضوع | الفئة | الحالة | الأولوية | التاريخ
- فلتر بالحالة (مفتوح/قيد المعالجة/محلول/مغلق) والأولوية (عاجل/عالي/متوسط/منخفض)
- **واجهة محادثة داخل التذكرة:**
  - عرض رسائل المستخدم والمسؤول مع التمييز بين طرفي المحادثة
  - حقل رد المسؤول مع زر إرسال
  - تغيير حالة التذكرة مباشرة
- شارات الأولوية بألوان (عاجل: أحمر | عالي: برتقالي | متوسط: أصفر | منخفض: رمادي)

```typescript
interface AdminTicket {
  id: number;
  userId: number;
  userName: string;
  userEmail: string;
  userRole: 'engineer' | 'owner' | 'company' | 'admin';
  subject: string;
  category: string;
  status: 'open' | 'in_progress' | 'resolved' | 'closed';
  priority: 'low' | 'medium' | 'high' | 'urgent';
  messages: TicketMessage[];
  createdAt: string;
  updatedAt: string;
}

interface TicketMessage {
  id: number;
  sender: 'user' | 'admin';
  senderName: string;
  content: string;
  timestamp: string;
}
```

---

### شاشة الإدارة 7: إدارة المستخدمين (Users Management)
**المسار:** `components/admin/UsersManagement`

**الميزات:**
- جدول المستخدمين: الاسم | البريد | الهاتف | الدور | الحالة | المدينة | تاريخ التسجيل | عدد الفحوص | آخر نشاط
- فلتر بالدور (مهندس/مالك/شركة/مسؤول) والحالة (نشط/محظور/انتظار التحقق)
- بحث بالاسم أو البريد الإلكتروني
- إجراءات: تفعيل | حظر | حذف | تعديل الدور
- إحصائيات: إجمالي المستخدمين | المستخدمون الجدد هذا الشهر | المستخدمون النشطون | المحظورون

```typescript
interface AdminUser {
  id: number;
  name: string;
  email: string;
  phone: string;
  role: 'engineer' | 'owner' | 'company' | 'admin';
  status: 'active' | 'blocked' | 'pending_verification';
  joinDate: string;
  scansCount: number;
  city: string;
  avatar?: string;
  lastActive: string;
}
```

**مستخدمون في البيانات التجريبية (12 مستخدم):**
متنوعون بين أصحاب مباني ومهندسين وشركات من مدن مختلفة (القاهرة، الجيزة، الإسكندرية، المنصورة، أسيوط، بورسعيد، طنطا)

---

### شاشة الإدارة 8: مركز الإشعارات (Notifications Center)
**المسار:** `components/admin/NotificationsCenter`

**الميزات:**
- قائمة الإشعارات المُرسَلة مسبقاً مع: العنوان | النص | الجمهور المستهدف | التاريخ | إحصائيات القراءة
- **إنشاء إشعار جديد:**
  - حقل عنوان الإشعار
  - حقل نص الإشعار (متعدد الأسطر)
  - اختيار الجمهور المستهدف: الكل | مهندسون | أصحاب مباني | شركات
  - نوع الإشعار: معلومة | تحذير | نجاح | تنبيه
  - زر "إرسال الإشعار"
- معدل القراءة لكل إشعار (readCount / totalSent × 100%)

```typescript
interface AdminNotification {
  id: number;
  title: string;
  body: string;
  target: 'all' | 'engineers' | 'owners' | 'companies';
  sentAt: string;
  sentBy: string;
  readCount: number;
  totalSent: number;
  type: 'info' | 'warning' | 'success' | 'alert';
}
```

---

### شاشة الإدارة 9: مراقبة النظام (System Monitoring)
**المسار:** `components/admin/SystemMonitoring`

**الميزات:**
- مؤشرات أداء النظام في الوقت الفعلي:
  - استخدام وحدة المعالجة (CPU): شريط تقدم + رقم %
  - استخدام الذاكرة (RAM): شريط تقدم + رقم %
  - مساحة التخزين: شريط تقدم + رقم %
  - حالة قاعدة البيانات: متصل ✓
  - حالة خدمة الذكاء الاصطناعي: تعمل ✓
  - وقت التشغيل (Uptime)
- جدول الفحوص الأخيرة بالنظام:
  - المعرف | المستخدم | نوع المبنى | مستوى الخطورة | التشققات المكتشفة | الدقة % | المدينة | التاريخ

```typescript
interface ScanRecord {
  id: number;
  userId: number;
  userName: string;
  buildingType: string;
  riskLevel: 'low' | 'medium' | 'high' | 'critical';
  cracksDetected: number;
  confidence: number;  // نسبة دقة الذكاء الاصطناعي
  city: string;
  createdAt: string;
}
```

> **ملاحظة مهمة:** جميع مفاتيح recharts في هذه الشاشة وفي AdminDashboard نصية فريدة (مبنية على بيانات العناصر مثل اسم الشهر أو النوع) وليس أرقاماً صحيحة، وذلك لتجنب خطأ `duplicate keys` الذي تم إصلاحه.

---

## 📊 البيانات والإحصائيات التجريبية

### إحصائيات لوحة التحكم الرئيسية
```typescript
const dashboardStats = {
  totalUsers: 5247,
  newUsersThisMonth: 312,
  pendingCompanies: 3,
  totalCompanies: 150,
  activeRequests: 24,
  totalRequests: 867,
  openTickets: 7,
  totalTickets: 234,
  totalScans: 11432,
  scansThisMonth: 843,
  approvedContracts: 342,
  totalRevenue: 4250000,  // بالجنيه المصري
};
```

### البيانات الشهرية للرسوم البيانية
```typescript
// الفحوص الشهرية (أكتوبر → أبريل)
const monthlyScans = [
  { month: 'أكتوبر', scans: 520 },
  { month: 'نوفمبر', scans: 680 },
  { month: 'ديسمبر', scans: 750 },
  { month: 'يناير',  scans: 640 },
  { month: 'فبراير', scans: 820 },
  { month: 'مارس',   scans: 960 },
  { month: 'أبريل',  scans: 843 },
];

// توزيع مستويات الخطورة
const riskDistribution = [
  { name: 'منخفض', value: 35, color: '#10B981' },
  { name: 'متوسط', value: 28, color: '#F59E0B' },
  { name: 'مرتفع', value: 24, color: '#EF4444' },
  { name: 'حرج',   value: 13, color: '#7C3AED' },
];

// نمو المستخدمين الشهري
const userGrowth = [
  { month: 'أكتوبر', users: 3200 },
  { month: 'نوفمبر', users: 3650 },
  { month: 'ديسمبر', users: 3980 },
  { month: 'يناير',  users: 4210 },
  { month: 'فبراير', users: 4680 },
  { month: 'مارس',   users: 4935 },
  { month: 'أبريل',  users: 5247 },
];
```

---

## 🌐 دعم اللغتين وRTL/LTR

### نظام الترجمة (i18n)
التطبيق يدعم العربية والإنجليزية بالكامل عبر `AppContext`:

```dart
// مثال على مفاتيح الترجمة المُنفَّذة
const translations = {
  'ar': {
    'login': 'تسجيل الدخول',
    'joinUsToStart': 'انضم إلينا وابدأ رحلة الفحص',
    'email': 'البريد الإلكتروني',
    'enterEmail': 'أدخل بريدك الإلكتروني',
    'password': 'كلمة المرور',
    'enterPassword': 'أدخل كلمة المرور',
    'forgotPassword': 'نسيت كلمة المرور؟',
    'dontHaveAccount': 'ليس لديك حساب؟',
    'createNewAccount': 'إنشاء حساب جديد',
    // ... المزيد
  },
  'en': {
    'login': 'Sign In',
    'joinUsToStart': 'Join us and start your inspection journey',
    // ... المزيد
  },
};

// الاتجاه
bool isRTL = currentLanguage == 'ar';
TextDirection direction = isRTL ? TextDirection.rtl : TextDirection.ltr;
```

### تطبيق RTL في Flutter
```dart
// في MaterialApp
MaterialApp(
  locale: Locale(currentLanguage),
  supportedLocales: [Locale('ar'), Locale('en')],
  localizationsDelegates: [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
)

// في كل شاشة
Directionality(
  textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
  child: Scaffold(...),
)
```

---

## 🔐 نظام الأدوار (4 أدوار)

| الدور | المسؤوليات | الشاشات المتاحة |
|-------|-----------|----------------|
| **مهندس ميداني** | إجراء الفحوص، إنشاء التقارير التفصيلية | جميع شاشات الفحص والتقارير |
| **مالك مبنى** | رفع صور مبانيه، استقبال التقارير، نشر طلبات التعاقد | الرئيسية، الرفع، النتائج، السوق (دور مالك) |
| **شركة إصلاح** | تقديم عروض الأسعار، إدارة المشاريع | السوق (دور شركة)، لوحة تحكم الشركة |
| **مسؤول (Admin)** | إدارة كاملة للمنصة | لوحة الإدارة (9 شاشات) — عبر بوابة منفصلة |

---

## 🗺️ مخطط التنقل بين الشاشات

```
SplashScreen (2-3 ثوان)
    ↓
OnboardingScreen (3 صفحات قابلة للسحب)
    ↓
LoginScreen
    ├── [زر تسجيل الدخول]     → HomeScreen
    ├── [إنشاء حساب]         → RegisterScreen → HomeScreen
    └── [دخول الإدارة (تجريبي)] → AdminPanel (مستقل)
                                    ├── AdminDashboard
                                    ├── CompanyVerification
                                    ├── RequestsManagement
                                    ├── BidsMonitoring
                                    ├── ContractsMonitoring
                                    ├── SupportTickets
                                    ├── UsersManagement
                                    ├── NotificationsCenter
                                    └── SystemMonitoring

HomeScreen (مع شريط التنقل السفلي)
    ├── Tab: Home      → HomeScreen
    ├── Tab: Upload    → UploadScreen
    │                     ↓ (اختيار صورة)
    │                   ScanningScreen (تحليل AI)
    │                     ↓ (اكتمال التحليل)
    │                   ResultsScreen
    │                     ├── [عرض التقرير الكامل] → ReportScreen
    │                     └── [نشر في السوق]       → PostProject
    ├── Tab: History   → HistoryScreen → ResultsScreen
    ├── Tab: Marketplace → MarketplaceHome
    │                      ├── CompanyDetails → QuoteRequest
    │                      │                 → ContactCompany
    │                      ├── PostProject
    │                      └── MyProjects → ProjectDetails
    └── Tab: Profile   → ProfileScreen
                          ├── SettingsScreen
                          ├── NotificationsScreen
                          ├── HelpScreen
                          └── AboutScreen
```

---

## ⚠️ ملاحظات تقنية مهمة

### 1. إصلاح مفاتيح Recharts المكررة
في `AdminDashboard` و`SystemMonitoring`، تم استبدال جميع المفاتيح الرقمية بمفاتيح نصية فريدة:
```tsx
// ❌ خاطئ
<Line key={0} dataKey="scans" />

// ✅ صحيح
<Line key="monthly-scans-line" dataKey="scans" />
// أو مبني على البيانات:
data.map(item => <Cell key={`risk-${item.name}`} fill={item.color} />)
```

### 2. بنية ملفات Admin Panel
```
/components/admin/
├── AdminPanel.tsx          ← الإطار الرئيسي + الشريط الجانبي
├── adminData.ts            ← جميع البيانات التجريبية والأنواع TypeScript
├── AdminDashboard.tsx      ← KPIs + 4 رسوم بيانية + النشاط الأخير
├── CompanyVerification.tsx ← إدارة تسجيل الشركات
├── RequestsManagement.tsx  ← إدارة الطلبات
├── BidsMonitoring.tsx      ← مراقبة العروض
├── ContractsMonitoring.tsx ← مراقبة العقود
├── SupportTickets.tsx      ← واجهة الدعم الفني
├── UsersManagement.tsx     ← إدارة المستخدمين
├── NotificationsCenter.tsx ← إرسال واستعراض الإشعارات
└── SystemMonitoring.tsx    ← مراقبة أداء النظام
```

### 3. AppContext
`/contexts/AppContext.tsx` يوفر:
- `t(key)` — دالة الترجمة
- `isRTL` — اتجاه الواجهة
- `isDarkMode` — الوضع الليلي
- `currentLanguage` — اللغة الحالية ('ar' | 'en')
- `toggleLanguage()` — تبديل اللغة
- `toggleDarkMode()` — تبديل الوضع الليلي

### 4. مسار الوصول للإدارة في App.tsx
```tsx
// App.tsx يتتبع حالتين منفصلتين
const [isAuthenticated, setIsAuthenticated] = useState(false);
const [isAdmin, setIsAdmin] = useState(false);

// عند الضغط على "دخول لوحة الإدارة"
const handleAdminLogin = () => {
  setIsAdmin(true);
  setIsAuthenticated(true);
};

// عرض شرطي: لوحة الإدارة تعرض بدلاً من التطبيق كاملاً
if (isAdmin) return <AdminPanel onLogout={handleLogout} />;
```

---

## 📦 حزم Flutter المقترحة

```yaml
dependencies:
  flutter: sdk: flutter
  
  # الحالة والتنقل
  provider: ^6.1.0        # إدارة الحالة
  go_router: ^13.0.0     # التنقل المتقدم
  
  # الواجهة
  google_fonts: ^6.2.1    # Inter + Cairo
  fl_chart: ^0.68.0       # الرسوم البيانية (بديل Recharts)
  dotted_border: ^2.1.0   # حدود منقطة لمنطقة الرفع
  shimmer: ^3.0.0         # تأثير تحميل Skeleton
  lottie: ^3.1.0          # الرسوم المتحركة
  
  # الوظائف
  image_picker: ^1.0.7    # اختيار الصور
  camera: ^0.10.5         # الكاميرا المباشرة
  permission_handler: ^11.3.0
  http: ^1.2.0            # الطلبات الشبكية
  dio: ^5.4.0             # HTTP متقدم
  cached_network_image: ^3.3.1
  
  # التخزين
  shared_preferences: ^2.2.3  # إعدادات محلية
  hive_flutter: ^1.1.0        # قاعدة بيانات محلية
  
  # PDF والمشاركة
  pdf: ^3.10.8
  printing: ^5.12.0
  share_plus: ^9.0.0
  
  # الترجمة
  flutter_localizations: sdk: flutter
  intl: ^0.19.0
```

---

## 🔄 خلاصة الشاشات المكتملة

| # | الشاشة | الملف | الحالة |
|---|--------|-------|--------|
| 1  | Splash Screen            | `screens/SplashScreen`                    | ✅ مكتمل |
| 2  | Onboarding               | `screens/OnboardingScreen`                | ✅ مكتمل |
| 3  | Login                    | `screens/LoginScreen`                     | ✅ مكتمل + زر Admin |
| 4  | Register                 | `screens/RegisterScreen`                  | ✅ مكتمل |
| 5  | Home Dashboard           | `screens/HomeScreen`                      | ✅ مكتمل |
| 6  | Upload Screen            | `screens/UploadScreen`                    | ✅ مكتمل |
| 7  | AI Scanning              | `screens/ScanningScreen`                  | ✅ مكتمل |
| 8  | Results Screen           | `screens/ResultsScreen`                   | ✅ مكتمل |
| 9  | Report Screen            | `screens/ReportScreen`                    | ✅ مكتمل |
| 10 | History Screen           | `screens/HistoryScreen`                   | ✅ مكتمل |
| 11 | Profile Screen           | `screens/ProfileScreen`                   | ✅ مكتمل |
| 12 | Settings Screen          | `screens/SettingsScreen`                  | ✅ مكتمل |
| 13 | Notifications            | `screens/NotificationsScreen`             | ✅ مكتمل |
| 14 | Marketplace Home         | `screens/marketplace/MarketplaceHome`     | ✅ مكتمل |
| 15 | Post Project             | `screens/marketplace/PostProject`         | ✅ مكتمل |
| 16 | Project Details          | `screens/marketplace/ProjectDetails`      | ✅ مكتمل |
| 17 | My Projects              | `screens/marketplace/MyProjects`          | ✅ مكتمل |
| 18 | Company Details          | `screens/marketplace/CompanyDetails`      | ✅ مكتمل |
| 19 | Quote Request            | `screens/marketplace/QuoteRequest`        | ✅ مكتمل |
| 20 | Contact Company          | `screens/marketplace/ContactCompany`      | ✅ مكتمل |
| 21 | Help Screen              | `screens/HelpScreen`                      | ✅ مكتمل |
| 22 | About Screen             | `screens/AboutScreen`                     | ✅ مكتمل |
| — | **Admin: Dashboard**      | `admin/AdminDashboard`                    | ✅ مكتمل |
| — | **Admin: Companies**      | `admin/CompanyVerification`               | ✅ مكتمل |
| — | **Admin: Requests**       | `admin/RequestsManagement`                | ✅ مكتمل |
| — | **Admin: Bids**           | `admin/BidsMonitoring`                    | ✅ مكتمل |
| — | **Admin: Contracts**      | `admin/ContractsMonitoring`               | ✅ مكتمل |
| — | **Admin: Tickets**        | `admin/SupportTickets`                    | ✅ مكتمل |
| — | **Admin: Users**          | `admin/UsersManagement`                   | ✅ مكتمل |
| — | **Admin: Notifications**  | `admin/NotificationsCenter`               | ✅ مكتمل |
| — | **Admin: System**         | `admin/SystemMonitoring`                  | ✅ مكتمل |

---

*هذا الملف يمثل الحالة الفعلية الكاملة لتطبيق CrackDetectX بتاريخ أبريل 2026.*
