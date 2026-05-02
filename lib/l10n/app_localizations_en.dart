// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'CrackDetectX';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get error => 'Error';

  @override
  String get loading => 'Loading...';

  @override
  String get login => 'Login';

  @override
  String get signup => 'Sign Up';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get welcome => 'Welcome';

  @override
  String get homeTitle => 'Home';

  @override
  String get scanNow => 'Scan Now';

  @override
  String get recentReports => 'Recent Reports';

  @override
  String get marketplaceTitle => 'Engineering Marketplace';

  @override
  String get createListing => 'Create Listing';

  @override
  String get placeBid => 'Place Bid';

  @override
  String get budget => 'Budget';

  @override
  String get riskLevel => 'Risk Level';

  @override
  String get owner => 'Building Owner';

  @override
  String get engineer => 'Engineer';

  @override
  String get company => 'Company';

  @override
  String get welcomeTagline => 'AI-Powered Building Safety Inspector';

  @override
  String get featureDetectionTitle => 'AI-Powered Detection';

  @override
  String get featureDetectionDesc =>
      'Advanced neural networks analyze structural damage';

  @override
  String get featureRiskTitle => 'Real-Time Risk Analysis';

  @override
  String get featureRiskDesc => 'Instant assessment of crack severity levels';

  @override
  String get featureReportsTitle => 'Detailed Reports';

  @override
  String get featureReportsDesc =>
      'Comprehensive PDF reports with recommendations';

  @override
  String get signIn => 'Sign In';

  @override
  String get createAccount => 'Create Account';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get signInToContinue => 'Sign in to continue';

  @override
  String get errorFillFields => 'Please fill in all fields';

  @override
  String errorLoginFailed(Object error) {
    return 'Login failed: $error';
  }

  @override
  String get hintEmail => 'Enter your email';

  @override
  String get hintPassword => 'Enter your password';

  @override
  String get signingIn => 'Signing In...';

  @override
  String get noAccount => 'Don\'t have an account? ';

  @override
  String get termsLogin =>
      'By signing in, you agree to our Terms & Privacy Policy';

  @override
  String get signupSubtitle => 'Join us to start inspecting';

  @override
  String get fullName => 'Full Name';

  @override
  String get hintFullName => 'Enter your full name';

  @override
  String get syndicateNumber => 'Syndicate Number';

  @override
  String get yearsOfExperience => 'Years of Experience';

  @override
  String get companyName => 'Company Name';

  @override
  String get tradeLicense => 'Trade License No.';

  @override
  String get taxId => 'Tax ID';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get creatingAccount => 'Creating...';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get termsSignup =>
      'By creating an account, you agree to our Terms & Privacy Policy';

  @override
  String get navHome => 'Home';

  @override
  String get navScan => 'Scan';

  @override
  String get navReports => 'Reports';

  @override
  String get navMarket => 'Marketplace';

  @override
  String get navProfile => 'Profile';

  @override
  String get scanBuilding => 'Scan Building';

  @override
  String get scans => 'scans';

  @override
  String get avgHealth => 'Avg Health';

  @override
  String get cracksDetected => 'Cracks Detected';

  @override
  String get startNewScan => 'Start New Scan';

  @override
  String get scanSubtitle => 'Capture image or upload from gallery';

  @override
  String get startScanNow => 'Start Scan Now';

  @override
  String get recentScans => 'Recent Scans';

  @override
  String get viewAll => 'View All';

  @override
  String get marketTitle => 'Engineering Market';

  @override
  String get marketSubtitle => 'Connect with certified engineering companies';

  @override
  String get exploreMarket => 'Explore Market';

  @override
  String get marketplaceScreenTitle => 'Engineering Marketplace';

  @override
  String get tabOwner => 'Building Owner';

  @override
  String get tabCompany => 'Engineering Company';

  @override
  String get searchHint => 'Search companies, services...';

  @override
  String get createListingSubtitle => 'Post your project for engineers';

  @override
  String get myListings => 'My Listings';

  @override
  String activeListingsCount(Object count) {
    return '$count Active';
  }

  @override
  String get companies => 'Companies';

  @override
  String get browseAll => 'Browse All';

  @override
  String get recommendedCompanies => 'Recommended Companies';

  @override
  String get noCompaniesFound => 'No companies found yet';

  @override
  String get loginForCompanyView => 'Please log in for company view';

  @override
  String get activeBids => 'Active Bids';

  @override
  String get statusPending => 'Pending';

  @override
  String get recentOpportunities => 'Recent Opportunities';

  @override
  String get noProjectsAvailable => 'No new projects available';

  @override
  String get filterTitle => 'Filter Projects/Companies';

  @override
  String get filterStatus => 'Status';

  @override
  String get statusAll => 'All';

  @override
  String get statusOpen => 'Open';

  @override
  String get statusUrgent => 'Urgent';

  @override
  String get filterBudget => 'Estimated Budget';

  @override
  String get actionClear => 'Clear';

  @override
  String get actionApply => 'Apply';

  @override
  String get newScanTitle => 'New Scan';

  @override
  String get uploadImageTitle => 'Upload Building Image';

  @override
  String get uploadImageDesc =>
      'Select a clear photo of the wall or structure you want to analyze.';

  @override
  String get tapToSelect => 'Tap to Select Image';

  @override
  String get imageFormats => 'JPG, PNG or HEIC';

  @override
  String get or => 'OR';

  @override
  String get takePhoto => 'Take Photo';

  @override
  String errorGeneric(Object error) {
    return 'Error: $error';
  }

  @override
  String get defaultUser => 'User';

  @override
  String get noEmail => 'No email';

  @override
  String get profileTitle => 'Profile';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get menuTitle => 'Menu';

  @override
  String get homeWelcomeBack => 'Welcome back';

  @override
  String get homeBuildingSafety => 'Building Safety';

  @override
  String get homeAiModelStatus => 'AI Model Status';

  @override
  String get homeAiReadyToAnalyze => 'Ready to analyze';

  @override
  String get homeScanWithCamera => 'Scan with Camera';

  @override
  String get homeUploadImage => 'Upload Image';

  @override
  String get homePreviousReports => 'Previous Reports';

  @override
  String get homeQuickStats => 'Quick Stats';

  @override
  String get homeAll => 'All';

  @override
  String get homeMonth => 'Month';

  @override
  String get homeAboutAiModel => 'About AI Model';

  @override
  String get homeSupportHelp => 'Support & Help';

  @override
  String inspectionsCount(int count) {
    return '$count inspections';
  }

  @override
  String get totalScans => 'Total Scans';

  @override
  String get highRisk => 'High Risk';

  @override
  String get adminDashboardTitle => 'Admin Dashboard';

  @override
  String get adminQuickActions => 'Quick Actions';

  @override
  String get adminRecentActions => 'Recent Admin Actions';

  @override
  String get adminNoRecentActions => 'No recent admin actions';

  @override
  String get adminKpiPendingVerifications => 'Pending Verifications';

  @override
  String get adminKpiOpenDisputes => 'Open Disputes';

  @override
  String get adminKpiActiveContracts => 'Active Contracts';

  @override
  String get adminActionReviewVerifications => 'Review Verification Requests';

  @override
  String get adminActionManageDisputes => 'Manage Disputes';

  @override
  String get adminActionUserManagement => 'User Management';

  @override
  String get adminActionSystemConfig => 'System Configuration';

  @override
  String get adminActionSupportTickets => 'Support Tickets';

  @override
  String get adminActionNotificationsCenter => 'Notifications Center';

  @override
  String get adminChartRiskDistribution => 'Risk Level Distribution';

  @override
  String get adminChartWeeklyActivity => 'Weekly Activity';

  @override
  String get adminChartPlaceholder =>
      'Charts will be connected to backend analytics later';

  @override
  String get settingsSectionGeneral => 'General';

  @override
  String get settingsSectionDataStorage => 'Data & Storage';

  @override
  String get settingsSectionAiModel => 'AI Model';

  @override
  String get settingsSectionAbout => 'About';

  @override
  String get settingsSectionSupport => 'Support';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsAutoSaveReports => 'Auto-save Reports';

  @override
  String get settingsOfflineMode => 'Offline Mode';

  @override
  String get settingsOnline => 'Online';

  @override
  String get settingsOffline => 'Offline';

  @override
  String get settingsClearCache => 'Clear Cache';

  @override
  String get settingsStorageUsed => 'Storage Used';

  @override
  String get settingsModelVersion => 'Model Version';

  @override
  String get settingsCheckUpdates => 'Check for Updates';

  @override
  String get settingsAutoUpdate => 'Auto-update';

  @override
  String get settingsAppVersion => 'App Version';

  @override
  String get settingsTermsOfService => 'Terms of Service';

  @override
  String get settingsPrivacyPolicy => 'Privacy Policy';

  @override
  String get settingsLicenses => 'Licenses';

  @override
  String get settingsHelpCenter => 'Help Center';

  @override
  String get settingsContactSupport => 'Contact Support';

  @override
  String get settingsReportBug => 'Report a Bug';

  @override
  String get dialogClearCacheTitle => 'Clear Cache';

  @override
  String get dialogClearCacheBody =>
      'Are you sure you want to clear the cache?';

  @override
  String get snackCacheCleared => 'Cache cleared';

  @override
  String get dialogCheckUpdatesTitle => 'Check for Updates';

  @override
  String get dialogCheckUpdatesBody => 'You are using the latest version';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get notifications => 'Notifications';

  @override
  String get languageEn => 'English';

  @override
  String get languageAr => 'العربية';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get logout => 'Logout';

  @override
  String get listingNewTitle => 'New Project Listing';

  @override
  String get listingProjectTitle => 'Project Title';

  @override
  String get listingTitleHint =>
      'e.g., Structural repair for residential building';

  @override
  String get listingTitleError => 'Please enter a title';

  @override
  String get listingDescription => 'Description';

  @override
  String get listingDescriptionHint =>
      'Describe the issue and project requirements...';

  @override
  String get listingDescriptionError => 'Please enter a description';

  @override
  String get listingAssessmentTitle => 'Assessment & Risk';

  @override
  String get listingAttachReport => 'Attach AI Report';

  @override
  String get listingSelectReport => 'Select a report from your history';

  @override
  String get listingHighRiskWarning =>
      'High risk projects require verified experts.';

  @override
  String get listingBudgetTitle => 'Estimated Budget (EGP)';

  @override
  String get listingBudgetMin => 'Min Budget';

  @override
  String get listingBudgetMax => 'Max Budget';

  @override
  String get listingTimelineTitle => 'Timeline';

  @override
  String get timelineUrgent => 'Urgent (7 days)';

  @override
  String get timeline1Month => '1 Month';

  @override
  String get timeline3Months => '3 Months';

  @override
  String get timelineFlexible => 'Flexible';

  @override
  String get listingServicesTitle => 'Services Needed';

  @override
  String get serviceAssessment => 'Structural Assessment';

  @override
  String get serviceRepair => 'Repair Works';

  @override
  String get serviceConsultation => 'Consultation';

  @override
  String get serviceMonitoring => 'Monitoring';

  @override
  String get listingPublishAction => 'Publish Listing';

  @override
  String get listingLoginError => 'Please log in to create a listing';

  @override
  String get listingSuccess => 'Listing published successfully!';

  @override
  String get bidSuccess => 'Bid submitted successfully!';

  @override
  String bidError(Object error) {
    return 'Error submitting bid: $error';
  }

  @override
  String get bidTitle => 'Submit Proposal';

  @override
  String get bidProjectPrefix => 'Project: ';

  @override
  String get bidClosed => 'Closed';

  @override
  String get bidOpen => 'Open';

  @override
  String bidBudgetRange(Object max, Object min) {
    return 'Budget: EGP $min - $max';
  }

  @override
  String get bidClosedMessage => 'Bidding for this project has closed.';

  @override
  String get bidFinancialTitle => 'Financial Proposal';

  @override
  String get bidPrice => 'Price';

  @override
  String get currencyEGP => 'EGP';

  @override
  String get errorRequired => 'Required';

  @override
  String get bidDuration => 'Duration';

  @override
  String get unitDays => 'Days';

  @override
  String get bidWarranty => 'Warranty Period';

  @override
  String get unitMonths => 'Months';

  @override
  String get bidTechnicalTitle => 'Technical Proposal';

  @override
  String get bidMethodology => 'Methodology';

  @override
  String get bidMethodologyHint => 'Briefly describe your repair approach...';

  @override
  String get bidNotes => 'Additional Notes';

  @override
  String get bidNotesHint => 'Any extra details, materials included, etc.';

  @override
  String get bidSubmitAction => 'Submit Bid';

  @override
  String get onboardingTitle1 => 'Welcome to CrackDetectX';

  @override
  String get onboardingSubtitle1 =>
      'AI-powered building inspection at your fingertips.';

  @override
  String get onboardingTitle2 => 'Advanced AI Detection';

  @override
  String get onboardingSubtitle2 =>
      'Instantly detect cracks and assess structural risks with 99% accuracy.';

  @override
  String get onboardingTitle3 => 'Expert Marketplace';

  @override
  String get onboardingSubtitle3 =>
      'Connect directly with certified engineering companies for repairs.';

  @override
  String get onboardingGetStarted => 'Get Started';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get browseCompanies => 'Browse Companies';

  @override
  String get filterCompanies => 'Filter Companies';

  @override
  String get filterProjects => 'Filter Projects';

  @override
  String get availableProjects => 'Available Projects';

  @override
  String starsPlus(Object count) {
    return '$count+ Stars';
  }

  @override
  String get verifiedOnly => 'Verified Only';

  @override
  String get topRated => 'Top Rated';

  @override
  String reviewsCount(Object count) {
    return '$count reviews';
  }

  @override
  String projectsCount(Object count) {
    return '$count projects';
  }

  @override
  String get noProjectsMatch => 'No projects match your search';

  @override
  String get clearFilters => 'Clear Filters';

  @override
  String get allLocations => 'All Locations';

  @override
  String get pleaseLoginBid => 'Please log in to place a bid';

  @override
  String get openStatus => 'Open';

  @override
  String get locationTitle => 'Location';

  @override
  String get ratingTitle => 'Rating';

  @override
  String get min => 'Min';

  @override
  String get max => 'Max';

  @override
  String get searchProjectsHint => 'Search projects...';

  @override
  String get projectDetails => 'Project Details';

  @override
  String get requestNotFound => 'Request not found';

  @override
  String get receivedBids => 'Received Bids';

  @override
  String get noBidsYet => 'No bids yet';

  @override
  String get confirmAcceptBidTitle => 'Accept Bid';

  @override
  String get confirmAcceptBidMessage =>
      'Are you sure you want to accept this bid? All other bids will be rejected.';

  @override
  String get actionAccept => 'Accept';

  @override
  String get bidAcceptedSuccess => 'Bid accepted successfully!';

  @override
  String get statusAccepted => 'Accepted';

  @override
  String get statusRejected => 'Rejected';

  @override
  String get contractDetails => 'Contract Details';

  @override
  String get contractNotFound => 'Contract not found';

  @override
  String get contractStatus => 'Contract Status';

  @override
  String get contractInfo => 'Contract Information';

  @override
  String get paymentDetails => 'Payment Details';

  @override
  String get agreedPrice => 'Agreed Price';

  @override
  String get fundsInEscrow => 'Funds held in Escrow';

  @override
  String get paymentReleased => 'Payment Released';

  @override
  String get markComplete => 'Mark Project as Complete';

  @override
  String get approveCompletion => 'Approve Completion';

  @override
  String get requestRevisions => 'Request Revisions';

  @override
  String get completionNotes => 'Completion Notes';

  @override
  String get ownerFeedback => 'Owner Feedback';

  @override
  String get raiseDispute => 'Raise a Dispute';

  @override
  String get submitReview => 'Submit Review';

  @override
  String get reviewSubmitted =>
      'You have already submitted a review for this project.';

  @override
  String get markedComplete => 'Marked as complete! Awaiting owner approval.';

  @override
  String get projectApproved => 'Project approved! Payment released.';

  @override
  String get revisionRequested => 'Revision request sent to engineer.';

  @override
  String get reviewSuccess => 'Review submitted successfully!';

  @override
  String get statusDraft => 'Draft';

  @override
  String get statusActive => 'Active';

  @override
  String get statusInProgress => 'In Progress';

  @override
  String get statusPendingCompletion => 'Pending Approval';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusDisputed => 'Disputed';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get disputeTitle => 'Raise a Dispute';

  @override
  String get disputeWarning => 'Important Notice';

  @override
  String get disputeWarningMessage =>
      'Disputes are reviewed by our admin team. Please provide accurate and detailed information.';

  @override
  String get disputeReason => 'Reason for Dispute';

  @override
  String get disputeReasonHint =>
      'e.g., Quality issues, Delayed completion, Payment dispute...';

  @override
  String get disputeDescription => 'Detailed Description';

  @override
  String get disputeDescriptionHint =>
      'Provide a detailed explanation of the issue...';

  @override
  String get disputeReasonRequired => 'Please enter a reason';

  @override
  String get disputeDescriptionRequired =>
      'Please provide a detailed description';

  @override
  String get disputeDescriptionTooShort =>
      'Description must be at least 20 characters';

  @override
  String get disputeSubmit => 'Submit Dispute';

  @override
  String get disputeSuccess =>
      'Dispute submitted successfully. Our team will review it.';

  @override
  String get reviewTitle => 'Review';

  @override
  String get reviewRating => 'Rating';

  @override
  String get reviewComment => 'Comment';

  @override
  String get reviewCommentHint => 'Share your experience...';
}
