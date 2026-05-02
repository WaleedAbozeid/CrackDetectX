// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'كراك ديتكت إكس';

  @override
  String get ok => 'موافق';

  @override
  String get cancel => 'إلغاء';

  @override
  String get error => 'خطأ';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get signup => 'إنشاء حساب';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get forgotPassword => 'هل نسيت كلمة المرور؟';

  @override
  String get welcome => 'مرحباً';

  @override
  String get homeTitle => 'الرئيسية';

  @override
  String get scanNow => 'فحص الآن';

  @override
  String get recentReports => 'أحدث التقارير';

  @override
  String get marketplaceTitle => 'سوق الهندسة';

  @override
  String get createListing => 'إنشاء مشروع';

  @override
  String get placeBid => 'تقديم عرض';

  @override
  String get budget => 'الميزانية';

  @override
  String get riskLevel => 'مستوى الخطورة';

  @override
  String get owner => 'مالك عقار';

  @override
  String get engineer => 'مهندس';

  @override
  String get company => 'شركة';

  @override
  String get welcomeTagline =>
      'مفتش السلامة الإنشائية المدعوم بالذكاء الاصطناعي';

  @override
  String get featureDetectionTitle => 'الكشف بالذكاء الاصطناعي';

  @override
  String get featureDetectionDesc =>
      'شبكات عصبية متقدمة لتحليل الأضرار الهيكلية';

  @override
  String get featureRiskTitle => 'تحليل المخاطر الفوري';

  @override
  String get featureRiskDesc => 'تقييم فوري لمستويات خطورة الشروخ';

  @override
  String get featureReportsTitle => 'تقارير مفصلة';

  @override
  String get featureReportsDesc => 'تقارير PDF شاملة مع التوصيات';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get welcomeBack => 'مرحباً بعودتك';

  @override
  String get signInToContinue => 'سجل دخولك للمتابعة';

  @override
  String get errorFillFields => 'يرجى ملء جميع الحقول';

  @override
  String errorLoginFailed(Object error) {
    return 'فشل تسجيل الدخول: $error';
  }

  @override
  String get hintEmail => 'أدخل بريدك الإلكتروني';

  @override
  String get hintPassword => 'أدخل كلمة المرور';

  @override
  String get signingIn => 'جاري الدخول...';

  @override
  String get noAccount => 'ليس لديك حساب؟ ';

  @override
  String get termsLogin =>
      'بتسجيل الدخول، أنت توافق على الشروط وسياسة الخصوصية';

  @override
  String get signupSubtitle => 'انضم إلينا وابدأ الفحص';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get hintFullName => 'أدخل اسمك الكامل';

  @override
  String get syndicateNumber => 'رقم النقابة';

  @override
  String get yearsOfExperience => 'سنوات الخبرة';

  @override
  String get companyName => 'اسم الشركة';

  @override
  String get tradeLicense => 'رقم السجل التجاري';

  @override
  String get taxId => 'الرقم الضريبي';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get creatingAccount => 'جاري الإنشاء...';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟ ';

  @override
  String get termsSignup => 'بإنشاء حساب، أنت توافق على الشروط وسياسة الخصوصية';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navScan => 'فحص';

  @override
  String get navReports => 'تقارير';

  @override
  String get navMarket => 'السوق';

  @override
  String get navProfile => 'حسابي';

  @override
  String get scanBuilding => 'فحص المباني';

  @override
  String get scans => 'فحص';

  @override
  String get avgHealth => 'متوسط الصحة';

  @override
  String get cracksDetected => 'تصدعات مكتشفة';

  @override
  String get startNewScan => 'ابدأ فحص جديد';

  @override
  String get scanSubtitle => 'التقط صورة أو ارفع من المعرض';

  @override
  String get startScanNow => 'بدء الفحص الآن';

  @override
  String get recentScans => 'عمليات المسح الأخيرة';

  @override
  String get viewAll => 'عرض الكل';

  @override
  String get marketTitle => 'السوق الهندسي';

  @override
  String get marketSubtitle => 'تواصل مع شركات هندسية معتمدة';

  @override
  String get exploreMarket => 'استكشف السوق';

  @override
  String get marketplaceScreenTitle => 'السوق الهندسي';

  @override
  String get tabOwner => 'مالك عقار';

  @override
  String get tabCompany => 'شركة هندسية';

  @override
  String get searchHint => 'بحث عن شركات، خدمات...';

  @override
  String get createListingSubtitle => 'أضف مشروعك للمهندسين';

  @override
  String get myListings => 'مشاريعي';

  @override
  String activeListingsCount(Object count) {
    return '$count نشط';
  }

  @override
  String get companies => 'الشركات';

  @override
  String get browseAll => 'تصفح الكل';

  @override
  String get recommendedCompanies => 'شركات موصى بها';

  @override
  String get noCompaniesFound => 'لم يتم العثور على شركات بعد';

  @override
  String get loginForCompanyView => 'يرجى تسجيل الدخول لعرض هذه الصفحة';

  @override
  String get activeBids => 'العروض النشطة';

  @override
  String get statusPending => 'قيد الانتظار';

  @override
  String get recentOpportunities => 'فرص حديثة';

  @override
  String get noProjectsAvailable => 'لا توجد مشاريع متاحة حالياً';

  @override
  String get filterTitle => 'تصفية المشاريع/الشركات';

  @override
  String get filterStatus => 'الحالة';

  @override
  String get statusAll => 'الكل';

  @override
  String get statusOpen => 'مفتوح';

  @override
  String get statusUrgent => 'عاجل';

  @override
  String get filterBudget => 'الميزانية المتوقعة';

  @override
  String get actionClear => 'مسح';

  @override
  String get actionApply => 'تطبيق';

  @override
  String get newScanTitle => 'فحص جديد';

  @override
  String get uploadImageTitle => 'رفع صورة للمبنى';

  @override
  String get uploadImageDesc =>
      'اختر صورة واضحة للجدار أو الهيكل الذي تريد تحليله.';

  @override
  String get tapToSelect => 'اضغط لاختيار صورة';

  @override
  String get imageFormats => 'JPG, PNG أو HEIC';

  @override
  String get or => 'أو';

  @override
  String get takePhoto => 'التقاط صورة';

  @override
  String errorGeneric(Object error) {
    return 'خطأ: $error';
  }

  @override
  String get defaultUser => 'مستخدم';

  @override
  String get noEmail => 'لا يوجد بريد إلكتروني';

  @override
  String get profileTitle => 'الملف الشخصي';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get menuTitle => 'القائمة';

  @override
  String get homeWelcomeBack => 'مرحباً بعودتك';

  @override
  String get homeBuildingSafety => 'سلامة المباني';

  @override
  String get homeAiModelStatus => 'حالة نموذج الذكاء الاصطناعي';

  @override
  String get homeAiReadyToAnalyze => 'جاهز للتحليل';

  @override
  String get homeScanWithCamera => 'فحص بالكاميرا';

  @override
  String get homeUploadImage => 'رفع صورة';

  @override
  String get homePreviousReports => 'التقارير السابقة';

  @override
  String get homeQuickStats => 'إحصائيات سريعة';

  @override
  String get homeAll => 'الكل';

  @override
  String get homeMonth => 'الشهر';

  @override
  String get homeAboutAiModel => 'حول نموذج الذكاء الاصطناعي';

  @override
  String get homeSupportHelp => 'الدعم والمساعدة';

  @override
  String inspectionsCount(int count) {
    return '$count فحص';
  }

  @override
  String get totalScans => 'إجمالي الفحوصات';

  @override
  String get highRisk => 'مخاطر عالية';

  @override
  String get adminDashboardTitle => 'لوحة التحكم';

  @override
  String get adminQuickActions => 'إجراءات سريعة';

  @override
  String get adminRecentActions => 'أحدث إجراءات الإدارة';

  @override
  String get adminNoRecentActions => 'لا توجد إجراءات حديثة';

  @override
  String get adminKpiPendingVerifications => 'طلبات التحقق المعلقة';

  @override
  String get adminKpiOpenDisputes => 'نزاعات مفتوحة';

  @override
  String get adminKpiActiveContracts => 'عقود نشطة';

  @override
  String get adminActionReviewVerifications => 'مراجعة طلبات التحقق';

  @override
  String get adminActionManageDisputes => 'إدارة النزاعات';

  @override
  String get adminActionUserManagement => 'إدارة المستخدمين';

  @override
  String get adminActionSystemConfig => 'إعدادات النظام';

  @override
  String get adminActionSupportTickets => 'تذاكر الدعم';

  @override
  String get adminActionNotificationsCenter => 'مركز الإشعارات';

  @override
  String get adminChartRiskDistribution => 'توزيع مستويات الخطر';

  @override
  String get adminChartWeeklyActivity => 'النشاط الأسبوعي';

  @override
  String get adminChartPlaceholder =>
      'سيتم ربط الرسوم التحليلية ببيانات الباك لاحقًا';

  @override
  String get settingsSectionGeneral => 'عام';

  @override
  String get settingsSectionDataStorage => 'البيانات والتخزين';

  @override
  String get settingsSectionAiModel => 'نموذج الذكاء الاصطناعي';

  @override
  String get settingsSectionAbout => 'حول';

  @override
  String get settingsSectionSupport => 'الدعم';

  @override
  String get settingsLanguage => 'اللغة';

  @override
  String get settingsNotifications => 'الإشعارات';

  @override
  String get settingsAutoSaveReports => 'حفظ التقارير تلقائيًا';

  @override
  String get settingsOfflineMode => 'وضع عدم الاتصال';

  @override
  String get settingsOnline => 'متصل';

  @override
  String get settingsOffline => 'غير متصل';

  @override
  String get settingsClearCache => 'مسح الكاش';

  @override
  String get settingsStorageUsed => 'المساحة المستخدمة';

  @override
  String get settingsModelVersion => 'إصدار النموذج';

  @override
  String get settingsCheckUpdates => 'التحقق من التحديثات';

  @override
  String get settingsAutoUpdate => 'تحديث تلقائي';

  @override
  String get settingsAppVersion => 'إصدار التطبيق';

  @override
  String get settingsTermsOfService => 'شروط الاستخدام';

  @override
  String get settingsPrivacyPolicy => 'سياسة الخصوصية';

  @override
  String get settingsLicenses => 'التراخيص';

  @override
  String get settingsHelpCenter => 'مركز المساعدة';

  @override
  String get settingsContactSupport => 'تواصل مع الدعم';

  @override
  String get settingsReportBug => 'الإبلاغ عن خطأ';

  @override
  String get dialogClearCacheTitle => 'مسح الكاش';

  @override
  String get dialogClearCacheBody => 'هل أنت متأكد أنك تريد مسح الكاش؟';

  @override
  String get snackCacheCleared => 'تم مسح الكاش';

  @override
  String get dialogCheckUpdatesTitle => 'التحقق من التحديثات';

  @override
  String get dialogCheckUpdatesBody => 'أنت تستخدم أحدث إصدار';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get languageEn => 'English';

  @override
  String get languageAr => 'العربية';

  @override
  String get lightMode => 'الوضع النهاري';

  @override
  String get darkMode => 'الوضع الليلي';

  @override
  String get deleteAccount => 'حذف الحساب';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get listingNewTitle => 'مشروع جديد';

  @override
  String get listingProjectTitle => 'عنوان المشروع';

  @override
  String get listingTitleHint => 'مثال: ترميم هيكلي لمبنى سكني';

  @override
  String get listingTitleError => 'يرجى إدخال العنوان';

  @override
  String get listingDescription => 'الوصف';

  @override
  String get listingDescriptionHint => 'صف المشكلة ومتطلبات المشروع...';

  @override
  String get listingDescriptionError => 'يرجى إدخال الوصف';

  @override
  String get listingAssessmentTitle => 'التقييم والمخاطر';

  @override
  String get listingAttachReport => 'إرفاق تقرير الذكاء الاصطناعي';

  @override
  String get listingSelectReport => 'اختر تقريراً من سجلك';

  @override
  String get listingHighRiskWarning =>
      'المشاريع عالية الخطورة تتطلب خبراء معتمدين.';

  @override
  String get listingBudgetTitle => 'الميزانية المتوقعة (جني)';

  @override
  String get listingBudgetMin => 'حد أدنى';

  @override
  String get listingBudgetMax => 'حد أقصى';

  @override
  String get listingTimelineTitle => 'الجدول الزمني';

  @override
  String get timelineUrgent => 'عاجل (7 أيام)';

  @override
  String get timeline1Month => 'شهر واحد';

  @override
  String get timeline3Months => '3 أشهر';

  @override
  String get timelineFlexible => 'مرن';

  @override
  String get listingServicesTitle => 'الخدمات المطلوبة';

  @override
  String get serviceAssessment => 'تقييم إنشائي';

  @override
  String get serviceRepair => 'أعمال ترميم';

  @override
  String get serviceConsultation => 'استشارة';

  @override
  String get serviceMonitoring => 'مراقبة';

  @override
  String get listingPublishAction => 'نشر المشروع';

  @override
  String get listingLoginError => 'يرجى تسجيل الدخول لإنشاء مشروع';

  @override
  String get listingSuccess => 'تم نشر المشروع بنجاح!';

  @override
  String get bidSuccess => 'تم تقديم العرض بنجاح!';

  @override
  String bidError(Object error) {
    return 'خطأ في تقديم العرض: $error';
  }

  @override
  String get bidTitle => 'تقديم عرض';

  @override
  String get bidProjectPrefix => 'المشروع: ';

  @override
  String get bidClosed => 'مغلق';

  @override
  String get bidOpen => 'مفتوح';

  @override
  String bidBudgetRange(Object max, Object min) {
    return 'الميزانية: $min - $max جني';
  }

  @override
  String get bidClosedMessage => 'انتهت فترة التقديم لهذا المشروع.';

  @override
  String get bidFinancialTitle => 'العرض المالي';

  @override
  String get bidPrice => 'السعر';

  @override
  String get currencyEGP => 'جني';

  @override
  String get errorRequired => 'مطلوب';

  @override
  String get bidDuration => 'المدة';

  @override
  String get unitDays => 'أيام';

  @override
  String get bidWarranty => 'فترة الضمان';

  @override
  String get unitMonths => 'أشهر';

  @override
  String get bidTechnicalTitle => 'العرض الفني';

  @override
  String get bidMethodology => 'المنهجية';

  @override
  String get bidMethodologyHint => 'صف باختصار نهج الإصلاح...';

  @override
  String get bidNotes => 'ملاحظات إضافية';

  @override
  String get bidNotesHint => 'أي تفاصيل إضافية، المواد المشمولة، إلخ.';

  @override
  String get bidSubmitAction => 'تقديم العرض';

  @override
  String get onboardingTitle1 => 'مرحباً بك في CrackDetectX';

  @override
  String get onboardingSubtitle1 => 'فحص المباني بالذكاء الاصطناعي بين يديك.';

  @override
  String get onboardingTitle2 => 'كشف متطور بالذكاء الاصطناعي';

  @override
  String get onboardingSubtitle2 =>
      'اكتشف الشقوق وقيّم المخاطر الهيكلية بدقة 99٪.';

  @override
  String get onboardingTitle3 => 'سوق الخبراء';

  @override
  String get onboardingSubtitle3 =>
      'تواصل مباشرة مع شركات هندسية معتمدة للإصلاحات.';

  @override
  String get onboardingGetStarted => 'ابدأ الآن';

  @override
  String get onboardingNext => 'التالي';

  @override
  String get onboardingSkip => 'تخطي';

  @override
  String get browseCompanies => 'تصفح الشركات';

  @override
  String get filterCompanies => 'تصفية الشركات';

  @override
  String get filterProjects => 'تصفية المشاريع';

  @override
  String get availableProjects => 'المشاريع المتاحة';

  @override
  String starsPlus(Object count) {
    return '$count+ نجوم';
  }

  @override
  String get verifiedOnly => 'تم التحقق فقط';

  @override
  String get topRated => 'الأعلى تقييماً';

  @override
  String reviewsCount(Object count) {
    return '$count مراجعة';
  }

  @override
  String projectsCount(Object count) {
    return '$count مشروع';
  }

  @override
  String get noProjectsMatch => 'لا توجد مشاريع تطابق بحثك';

  @override
  String get clearFilters => 'مسح التصفية';

  @override
  String get allLocations => 'كل المواقع';

  @override
  String get pleaseLoginBid => 'يرجى تسجيل الدخول لتقديم عرض';

  @override
  String get openStatus => 'مفتوح';

  @override
  String get locationTitle => 'الموقع';

  @override
  String get ratingTitle => 'التقييم';

  @override
  String get min => 'أدنى';

  @override
  String get max => 'أقصى';

  @override
  String get searchProjectsHint => 'بحث عن مشاريع...';

  @override
  String get projectDetails => 'تفاصيل المشروع';

  @override
  String get requestNotFound => 'المشروع غير موجود';

  @override
  String get receivedBids => 'العروض المستلمة';

  @override
  String get noBidsYet => 'لا توجد عروض بعد';

  @override
  String get confirmAcceptBidTitle => 'قبول العرض';

  @override
  String get confirmAcceptBidMessage =>
      'هل أنت متأكد من قبول هذا العرض؟ سيتم رفض جميع العروض الأخرى.';

  @override
  String get actionAccept => 'قبول';

  @override
  String get bidAcceptedSuccess => 'تم قبول العرض بنجاح!';

  @override
  String get statusAccepted => 'مقبول';

  @override
  String get statusRejected => 'مرفوض';

  @override
  String get contractDetails => 'تفاصيل العقد';

  @override
  String get contractNotFound => 'العقد غير موجود';

  @override
  String get contractStatus => 'حالة العقد';

  @override
  String get contractInfo => 'معلومات العقد';

  @override
  String get paymentDetails => 'تفاصيل الدفع';

  @override
  String get agreedPrice => 'السعر المتفق عليه';

  @override
  String get fundsInEscrow => 'الأموال محجوزة في Escrow';

  @override
  String get paymentReleased => 'تم تحرير الدفع';

  @override
  String get markComplete => 'تحديد المشروع كمكتمل';

  @override
  String get approveCompletion => 'الموافقة على الإنجاز';

  @override
  String get requestRevisions => 'طلب تعديلات';

  @override
  String get completionNotes => 'ملاحظات الإنجاز';

  @override
  String get ownerFeedback => 'ملاحظات المالك';

  @override
  String get raiseDispute => 'رفع نزاع';

  @override
  String get submitReview => 'إرسال تقييم';

  @override
  String get reviewSubmitted => 'لقد قمت بإرسال تقييم لهذا المشروع بالفعل.';

  @override
  String get markedComplete => 'تم تحديده كمكتمل! في انتظار موافقة المالك.';

  @override
  String get projectApproved => 'تمت الموافقة على المشروع! تم تحرير الدفع.';

  @override
  String get revisionRequested => 'تم إرسال طلب التعديل إلى المهندس.';

  @override
  String get reviewSuccess => 'تم إرسال التقييم بنجاح!';

  @override
  String get statusDraft => 'مسودة';

  @override
  String get statusActive => 'نشط';

  @override
  String get statusInProgress => 'قيد التنفيذ';

  @override
  String get statusPendingCompletion => 'في انتظار الموافقة';

  @override
  String get statusCompleted => 'مكتمل';

  @override
  String get statusDisputed => 'متنازع عليه';

  @override
  String get statusCancelled => 'ملغى';

  @override
  String get disputeTitle => 'رفع نزاع';

  @override
  String get disputeWarning => 'إشعار مهم';

  @override
  String get disputeWarningMessage =>
      'يتم مراجعة النزاعات من قبل فريق الإدارة. يرجى تقديم معلومات دقيقة ومفصلة.';

  @override
  String get disputeReason => 'سبب النزاع';

  @override
  String get disputeReasonHint =>
      'مثال: مشاكل في الجودة، تأخير في الاكتمال، نزاع دفع...';

  @override
  String get disputeDescription => 'وصف تفصيلي';

  @override
  String get disputeDescriptionHint => 'قدم شرحاً تفصيلياً للمشكلة...';

  @override
  String get disputeReasonRequired => 'يرجى إدخال السبب';

  @override
  String get disputeDescriptionRequired => 'يرجى تقديم وصف تفصيلي';

  @override
  String get disputeDescriptionTooShort =>
      'يجب أن يكون الوصف 20 حرفاً على الأقل';

  @override
  String get disputeSubmit => 'إرسال النزاع';

  @override
  String get disputeSuccess => 'تم إرسال النزاع بنجاح. سيقوم فريقنا بمراجعته.';

  @override
  String get reviewTitle => 'تقييم';

  @override
  String get reviewRating => 'التقييم';

  @override
  String get reviewComment => 'التعليق';

  @override
  String get reviewCommentHint => 'شارك تجربتك...';
}
