import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'CrackDetectX'**
  String get appName;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signup;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// No description provided for @scanNow.
  ///
  /// In en, this message translates to:
  /// **'Scan Now'**
  String get scanNow;

  /// No description provided for @recentReports.
  ///
  /// In en, this message translates to:
  /// **'Recent Reports'**
  String get recentReports;

  /// No description provided for @marketplaceTitle.
  ///
  /// In en, this message translates to:
  /// **'Engineering Marketplace'**
  String get marketplaceTitle;

  /// No description provided for @createListing.
  ///
  /// In en, this message translates to:
  /// **'Create Listing'**
  String get createListing;

  /// No description provided for @placeBid.
  ///
  /// In en, this message translates to:
  /// **'Place Bid'**
  String get placeBid;

  /// No description provided for @budget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get budget;

  /// No description provided for @riskLevel.
  ///
  /// In en, this message translates to:
  /// **'Risk Level'**
  String get riskLevel;

  /// No description provided for @owner.
  ///
  /// In en, this message translates to:
  /// **'Building Owner'**
  String get owner;

  /// No description provided for @engineer.
  ///
  /// In en, this message translates to:
  /// **'Engineer'**
  String get engineer;

  /// No description provided for @company.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get company;

  /// No description provided for @welcomeTagline.
  ///
  /// In en, this message translates to:
  /// **'AI-Powered Building Safety Inspector'**
  String get welcomeTagline;

  /// No description provided for @featureDetectionTitle.
  ///
  /// In en, this message translates to:
  /// **'AI-Powered Detection'**
  String get featureDetectionTitle;

  /// No description provided for @featureDetectionDesc.
  ///
  /// In en, this message translates to:
  /// **'Advanced neural networks analyze structural damage'**
  String get featureDetectionDesc;

  /// No description provided for @featureRiskTitle.
  ///
  /// In en, this message translates to:
  /// **'Real-Time Risk Analysis'**
  String get featureRiskTitle;

  /// No description provided for @featureRiskDesc.
  ///
  /// In en, this message translates to:
  /// **'Instant assessment of crack severity levels'**
  String get featureRiskDesc;

  /// No description provided for @featureReportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Detailed Reports'**
  String get featureReportsTitle;

  /// No description provided for @featureReportsDesc.
  ///
  /// In en, this message translates to:
  /// **'Comprehensive PDF reports with recommendations'**
  String get featureReportsDesc;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @signInToContinue.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get signInToContinue;

  /// No description provided for @errorFillFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all fields'**
  String get errorFillFields;

  /// No description provided for @errorLoginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed: {error}'**
  String errorLoginFailed(Object error);

  /// No description provided for @hintEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get hintEmail;

  /// No description provided for @hintPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get hintPassword;

  /// No description provided for @signingIn.
  ///
  /// In en, this message translates to:
  /// **'Signing In...'**
  String get signingIn;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get noAccount;

  /// No description provided for @termsLogin.
  ///
  /// In en, this message translates to:
  /// **'By signing in, you agree to our Terms & Privacy Policy'**
  String get termsLogin;

  /// No description provided for @signupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Join us to start inspecting'**
  String get signupSubtitle;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @hintFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get hintFullName;

  /// No description provided for @syndicateNumber.
  ///
  /// In en, this message translates to:
  /// **'Syndicate Number'**
  String get syndicateNumber;

  /// No description provided for @yearsOfExperience.
  ///
  /// In en, this message translates to:
  /// **'Years of Experience'**
  String get yearsOfExperience;

  /// No description provided for @companyName.
  ///
  /// In en, this message translates to:
  /// **'Company Name'**
  String get companyName;

  /// No description provided for @tradeLicense.
  ///
  /// In en, this message translates to:
  /// **'Trade License No.'**
  String get tradeLicense;

  /// No description provided for @taxId.
  ///
  /// In en, this message translates to:
  /// **'Tax ID'**
  String get taxId;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @creatingAccount.
  ///
  /// In en, this message translates to:
  /// **'Creating...'**
  String get creatingAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @termsSignup.
  ///
  /// In en, this message translates to:
  /// **'By creating an account, you agree to our Terms & Privacy Policy'**
  String get termsSignup;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navScan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get navScan;

  /// No description provided for @navReports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get navReports;

  /// No description provided for @navMarket.
  ///
  /// In en, this message translates to:
  /// **'Marketplace'**
  String get navMarket;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @scanBuilding.
  ///
  /// In en, this message translates to:
  /// **'Scan Building'**
  String get scanBuilding;

  /// No description provided for @scans.
  ///
  /// In en, this message translates to:
  /// **'scans'**
  String get scans;

  /// No description provided for @avgHealth.
  ///
  /// In en, this message translates to:
  /// **'Avg Health'**
  String get avgHealth;

  /// No description provided for @cracksDetected.
  ///
  /// In en, this message translates to:
  /// **'Cracks Detected'**
  String get cracksDetected;

  /// No description provided for @startNewScan.
  ///
  /// In en, this message translates to:
  /// **'Start New Scan'**
  String get startNewScan;

  /// No description provided for @scanSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Capture image or upload from gallery'**
  String get scanSubtitle;

  /// No description provided for @startScanNow.
  ///
  /// In en, this message translates to:
  /// **'Start Scan Now'**
  String get startScanNow;

  /// No description provided for @recentScans.
  ///
  /// In en, this message translates to:
  /// **'Recent Scans'**
  String get recentScans;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @marketTitle.
  ///
  /// In en, this message translates to:
  /// **'Engineering Market'**
  String get marketTitle;

  /// No description provided for @marketSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Connect with certified engineering companies'**
  String get marketSubtitle;

  /// No description provided for @exploreMarket.
  ///
  /// In en, this message translates to:
  /// **'Explore Market'**
  String get exploreMarket;

  /// No description provided for @marketplaceScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Engineering Marketplace'**
  String get marketplaceScreenTitle;

  /// No description provided for @tabOwner.
  ///
  /// In en, this message translates to:
  /// **'Building Owner'**
  String get tabOwner;

  /// No description provided for @tabCompany.
  ///
  /// In en, this message translates to:
  /// **'Engineering Company'**
  String get tabCompany;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search companies, services...'**
  String get searchHint;

  /// No description provided for @createListingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Post your project for engineers'**
  String get createListingSubtitle;

  /// No description provided for @myListings.
  ///
  /// In en, this message translates to:
  /// **'My Listings'**
  String get myListings;

  /// No description provided for @activeListingsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Active'**
  String activeListingsCount(Object count);

  /// No description provided for @companies.
  ///
  /// In en, this message translates to:
  /// **'Companies'**
  String get companies;

  /// No description provided for @browseAll.
  ///
  /// In en, this message translates to:
  /// **'Browse All'**
  String get browseAll;

  /// No description provided for @recommendedCompanies.
  ///
  /// In en, this message translates to:
  /// **'Recommended Companies'**
  String get recommendedCompanies;

  /// No description provided for @noCompaniesFound.
  ///
  /// In en, this message translates to:
  /// **'No companies found yet'**
  String get noCompaniesFound;

  /// No description provided for @loginForCompanyView.
  ///
  /// In en, this message translates to:
  /// **'Please log in for company view'**
  String get loginForCompanyView;

  /// No description provided for @activeBids.
  ///
  /// In en, this message translates to:
  /// **'Active Bids'**
  String get activeBids;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// No description provided for @recentOpportunities.
  ///
  /// In en, this message translates to:
  /// **'Recent Opportunities'**
  String get recentOpportunities;

  /// No description provided for @noProjectsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No new projects available'**
  String get noProjectsAvailable;

  /// No description provided for @filterTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter Projects/Companies'**
  String get filterTitle;

  /// No description provided for @filterStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get filterStatus;

  /// No description provided for @statusAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get statusAll;

  /// No description provided for @statusOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get statusOpen;

  /// No description provided for @statusUrgent.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get statusUrgent;

  /// No description provided for @filterBudget.
  ///
  /// In en, this message translates to:
  /// **'Estimated Budget'**
  String get filterBudget;

  /// No description provided for @actionClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get actionClear;

  /// No description provided for @actionApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get actionApply;

  /// No description provided for @newScanTitle.
  ///
  /// In en, this message translates to:
  /// **'New Scan'**
  String get newScanTitle;

  /// No description provided for @uploadImageTitle.
  ///
  /// In en, this message translates to:
  /// **'Upload Building Image'**
  String get uploadImageTitle;

  /// No description provided for @uploadImageDesc.
  ///
  /// In en, this message translates to:
  /// **'Select a clear photo of the wall or structure you want to analyze.'**
  String get uploadImageDesc;

  /// No description provided for @tapToSelect.
  ///
  /// In en, this message translates to:
  /// **'Tap to Select Image'**
  String get tapToSelect;

  /// No description provided for @imageFormats.
  ///
  /// In en, this message translates to:
  /// **'JPG, PNG or HEIC'**
  String get imageFormats;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorGeneric(Object error);

  /// No description provided for @defaultUser.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get defaultUser;

  /// No description provided for @noEmail.
  ///
  /// In en, this message translates to:
  /// **'No email'**
  String get noEmail;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @totalScans.
  ///
  /// In en, this message translates to:
  /// **'Total Scans'**
  String get totalScans;

  /// No description provided for @highRisk.
  ///
  /// In en, this message translates to:
  /// **'High Risk'**
  String get highRisk;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @languageEn.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEn;

  /// No description provided for @languageAr.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get languageAr;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @listingNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New Project Listing'**
  String get listingNewTitle;

  /// No description provided for @listingProjectTitle.
  ///
  /// In en, this message translates to:
  /// **'Project Title'**
  String get listingProjectTitle;

  /// No description provided for @listingTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Structural repair for residential building'**
  String get listingTitleHint;

  /// No description provided for @listingTitleError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a title'**
  String get listingTitleError;

  /// No description provided for @listingDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get listingDescription;

  /// No description provided for @listingDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Describe the issue and project requirements...'**
  String get listingDescriptionHint;

  /// No description provided for @listingDescriptionError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a description'**
  String get listingDescriptionError;

  /// No description provided for @listingAssessmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Assessment & Risk'**
  String get listingAssessmentTitle;

  /// No description provided for @listingAttachReport.
  ///
  /// In en, this message translates to:
  /// **'Attach AI Report'**
  String get listingAttachReport;

  /// No description provided for @listingSelectReport.
  ///
  /// In en, this message translates to:
  /// **'Select a report from your history'**
  String get listingSelectReport;

  /// No description provided for @listingHighRiskWarning.
  ///
  /// In en, this message translates to:
  /// **'High risk projects require verified experts.'**
  String get listingHighRiskWarning;

  /// No description provided for @listingBudgetTitle.
  ///
  /// In en, this message translates to:
  /// **'Estimated Budget (EGP)'**
  String get listingBudgetTitle;

  /// No description provided for @listingBudgetMin.
  ///
  /// In en, this message translates to:
  /// **'Min Budget'**
  String get listingBudgetMin;

  /// No description provided for @listingBudgetMax.
  ///
  /// In en, this message translates to:
  /// **'Max Budget'**
  String get listingBudgetMax;

  /// No description provided for @listingTimelineTitle.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get listingTimelineTitle;

  /// No description provided for @timelineUrgent.
  ///
  /// In en, this message translates to:
  /// **'Urgent (7 days)'**
  String get timelineUrgent;

  /// No description provided for @timeline1Month.
  ///
  /// In en, this message translates to:
  /// **'1 Month'**
  String get timeline1Month;

  /// No description provided for @timeline3Months.
  ///
  /// In en, this message translates to:
  /// **'3 Months'**
  String get timeline3Months;

  /// No description provided for @timelineFlexible.
  ///
  /// In en, this message translates to:
  /// **'Flexible'**
  String get timelineFlexible;

  /// No description provided for @listingServicesTitle.
  ///
  /// In en, this message translates to:
  /// **'Services Needed'**
  String get listingServicesTitle;

  /// No description provided for @serviceAssessment.
  ///
  /// In en, this message translates to:
  /// **'Structural Assessment'**
  String get serviceAssessment;

  /// No description provided for @serviceRepair.
  ///
  /// In en, this message translates to:
  /// **'Repair Works'**
  String get serviceRepair;

  /// No description provided for @serviceConsultation.
  ///
  /// In en, this message translates to:
  /// **'Consultation'**
  String get serviceConsultation;

  /// No description provided for @serviceMonitoring.
  ///
  /// In en, this message translates to:
  /// **'Monitoring'**
  String get serviceMonitoring;

  /// No description provided for @listingPublishAction.
  ///
  /// In en, this message translates to:
  /// **'Publish Listing'**
  String get listingPublishAction;

  /// No description provided for @listingLoginError.
  ///
  /// In en, this message translates to:
  /// **'Please log in to create a listing'**
  String get listingLoginError;

  /// No description provided for @listingSuccess.
  ///
  /// In en, this message translates to:
  /// **'Listing published successfully!'**
  String get listingSuccess;

  /// No description provided for @bidSuccess.
  ///
  /// In en, this message translates to:
  /// **'Bid submitted successfully!'**
  String get bidSuccess;

  /// No description provided for @bidError.
  ///
  /// In en, this message translates to:
  /// **'Error submitting bid: {error}'**
  String bidError(Object error);

  /// No description provided for @bidTitle.
  ///
  /// In en, this message translates to:
  /// **'Submit Proposal'**
  String get bidTitle;

  /// No description provided for @bidProjectPrefix.
  ///
  /// In en, this message translates to:
  /// **'Project: '**
  String get bidProjectPrefix;

  /// No description provided for @bidClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get bidClosed;

  /// No description provided for @bidOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get bidOpen;

  /// No description provided for @bidBudgetRange.
  ///
  /// In en, this message translates to:
  /// **'Budget: EGP {min} - {max}'**
  String bidBudgetRange(Object max, Object min);

  /// No description provided for @bidClosedMessage.
  ///
  /// In en, this message translates to:
  /// **'Bidding for this project has closed.'**
  String get bidClosedMessage;

  /// No description provided for @bidFinancialTitle.
  ///
  /// In en, this message translates to:
  /// **'Financial Proposal'**
  String get bidFinancialTitle;

  /// No description provided for @bidPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get bidPrice;

  /// No description provided for @currencyEGP.
  ///
  /// In en, this message translates to:
  /// **'EGP'**
  String get currencyEGP;

  /// No description provided for @errorRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get errorRequired;

  /// No description provided for @bidDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get bidDuration;

  /// No description provided for @unitDays.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get unitDays;

  /// No description provided for @bidWarranty.
  ///
  /// In en, this message translates to:
  /// **'Warranty Period'**
  String get bidWarranty;

  /// No description provided for @unitMonths.
  ///
  /// In en, this message translates to:
  /// **'Months'**
  String get unitMonths;

  /// No description provided for @bidTechnicalTitle.
  ///
  /// In en, this message translates to:
  /// **'Technical Proposal'**
  String get bidTechnicalTitle;

  /// No description provided for @bidMethodology.
  ///
  /// In en, this message translates to:
  /// **'Methodology'**
  String get bidMethodology;

  /// No description provided for @bidMethodologyHint.
  ///
  /// In en, this message translates to:
  /// **'Briefly describe your repair approach...'**
  String get bidMethodologyHint;

  /// No description provided for @bidNotes.
  ///
  /// In en, this message translates to:
  /// **'Additional Notes'**
  String get bidNotes;

  /// No description provided for @bidNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Any extra details, materials included, etc.'**
  String get bidNotesHint;

  /// No description provided for @bidSubmitAction.
  ///
  /// In en, this message translates to:
  /// **'Submit Bid'**
  String get bidSubmitAction;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Welcome to CrackDetectX'**
  String get onboardingTitle1;

  /// No description provided for @onboardingSubtitle1.
  ///
  /// In en, this message translates to:
  /// **'AI-powered building inspection at your fingertips.'**
  String get onboardingSubtitle1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Advanced AI Detection'**
  String get onboardingTitle2;

  /// No description provided for @onboardingSubtitle2.
  ///
  /// In en, this message translates to:
  /// **'Instantly detect cracks and assess structural risks with 99% accuracy.'**
  String get onboardingSubtitle2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Expert Marketplace'**
  String get onboardingTitle3;

  /// No description provided for @onboardingSubtitle3.
  ///
  /// In en, this message translates to:
  /// **'Connect directly with certified engineering companies for repairs.'**
  String get onboardingSubtitle3;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboardingGetStarted;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
