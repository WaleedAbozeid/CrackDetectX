import 'package:flutter/material.dart';
import 'package:crackdetectx/l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../design/colors.dart';
import '../design/typography.dart';
import '../design/spacing.dart';
import '../design/radius.dart';
import '../store/app_state.dart';
import '../models/marketplace_models.dart';

class CreateListingScreen extends StatefulWidget {
  const CreateListingScreen({super.key});

  @override
  State<CreateListingScreen> createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends State<CreateListingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _budgetMinController = TextEditingController();
  final _budgetMaxController = TextEditingController();

  String _timeline = 'flexible';
  RiskLevel _riskLevel = RiskLevel.low;
  final Set<String> _selectedServices = {};
  String? _selectedReport;

  // Placeholder for reports - in real app, fetch from Reports provider
  final List<String> _availableReports = [
    'Report #CD-2023-001 (High Risk)',
    'Report #CD-2023-002 (Low Risk)',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _budgetMinController.dispose();
    _budgetMaxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: const BackButton(color: AppColors.primary900),
        title: Text(
          AppLocalizations.of(context)!.listingNewTitle,
          style: AppTypography.h3.copyWith(color: AppColors.primary900),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            // Project Title
            TextFormField(
              controller: _titleController,
              decoration: _buildInputDecoration(
                labelText: AppLocalizations.of(context)!.listingProjectTitle,
                hintText: AppLocalizations.of(context)!.listingTitleHint,
                icon: Icons.title,
              ),
              style: AppTypography.bodyText,
              validator: (value) => value?.isEmpty ?? true
                  ? AppLocalizations.of(context)!.listingTitleError
                  : null,
            ),
            const SizedBox(height: AppSpacing.lg),

            // Description
            TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: _buildInputDecoration(
                labelText: AppLocalizations.of(context)!.listingDescription,
                hintText: AppLocalizations.of(context)!.listingDescriptionHint,
              ).copyWith(alignLabelWithHint: true),
              style: AppTypography.bodyText,
              validator: (value) => value?.isEmpty ?? true
                  ? AppLocalizations.of(context)!.listingDescriptionError
                  : null,
            ),
            const SizedBox(height: AppSpacing.xl),

            // Risk & Report Section
            Text(
              AppLocalizations.of(context)!.listingAssessmentTitle,
              style: AppTypography.h4,
            ),
            const SizedBox(height: AppSpacing.md),

            // Attach Scan Report
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.r12),
                side: const BorderSide(color: AppColors.borderLight),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.attach_file,
                  color: AppColors.primary500,
                ),
                title: Text(AppLocalizations.of(context)!.listingAttachReport),
                subtitle: Text(
                  _selectedReport ??
                      AppLocalizations.of(context)!.listingSelectReport,
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: _showReportSelector,
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Risk Level Dropdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(AppRadius.r12),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<RiskLevel>(
                  value: _riskLevel,
                  isExpanded: true,
                  icon: const Icon(Icons.warning_amber_rounded),
                  items: RiskLevel.values.map((RiskLevel level) {
                    Color color = AppColors.successGreen;
                    if (level == RiskLevel.medium)
                      color = AppColors.warningOrange;
                    if (level == RiskLevel.high) color = AppColors.dangerRed;

                    return DropdownMenuItem<RiskLevel>(
                      value: level,
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            level.name.toUpperCase(),
                            style: AppTypography.bodyText.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (RiskLevel? newValue) {
                    if (newValue != null) {
                      setState(() => _riskLevel = newValue);
                    }
                  },
                ),
              ),
            ),
            if (_riskLevel == RiskLevel.high)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.dangerRed,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      AppLocalizations.of(context)!.listingHighRiskWarning,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.dangerRed,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: AppSpacing.xl),

            // Budget Section
            Text(
              AppLocalizations.of(context)!.listingBudgetTitle,
              style: AppTypography.h4,
            ),
            const SizedBox(height: AppSpacing.md),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _budgetMinController,
                    keyboardType: TextInputType.number,
                    decoration: _buildInputDecoration(
                      labelText: AppLocalizations.of(context)!.listingBudgetMin,
                      prefixText: 'EGP ',
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: TextFormField(
                    controller: _budgetMaxController,
                    keyboardType: TextInputType.number,
                    decoration: _buildInputDecoration(
                      labelText: AppLocalizations.of(context)!.listingBudgetMax,
                      prefixText: 'EGP ',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            // Timeline
            Text(
              AppLocalizations.of(context)!.listingTimelineTitle,
              style: AppTypography.h4,
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              children: [
                _buildTimelineChip(
                  AppLocalizations.of(context)!.timelineUrgent,
                  'urgent',
                ),
                _buildTimelineChip(
                  AppLocalizations.of(context)!.timeline1Month,
                  '1month',
                ),
                _buildTimelineChip(
                  AppLocalizations.of(context)!.timeline3Months,
                  '3months',
                ),
                _buildTimelineChip(
                  AppLocalizations.of(context)!.timelineFlexible,
                  'flexible',
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            // Services Needed
            Text(
              AppLocalizations.of(context)!.listingServicesTitle,
              style: AppTypography.h4,
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildServiceCheckbox(
              AppLocalizations.of(context)!.serviceAssessment,
              'assessment',
            ),
            _buildServiceCheckbox(
              AppLocalizations.of(context)!.serviceRepair,
              'repair',
            ),
            _buildServiceCheckbox(
              AppLocalizations.of(context)!.serviceConsultation,
              'consultation',
            ),
            _buildServiceCheckbox(
              AppLocalizations.of(context)!.serviceMonitoring,
              'monitoring',
            ),

            const SizedBox(height: AppSpacing.xxl),

            // Publish Button
            ElevatedButton(
              onPressed: _submitListing,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary500,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.r12),
                ),
                elevation: 2,
              ),
              child: Text(
                AppLocalizations.of(context)!.listingPublishAction,
                style: AppTypography.button.copyWith(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitListing() {
    if (_formKey.currentState?.validate() ?? false) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.listingLoginError),
          ),
        );
        return;
      }

      // Calculate deadline
      DateTime? deadline;
      final now = DateTime.now();
      if (_timeline == 'urgent') {
        deadline = now.add(const Duration(days: 7));
      } else if (_timeline == '1month') {
        deadline = now.add(const Duration(days: 30));
      } else if (_timeline == '3months') {
        deadline = now.add(const Duration(days: 90));
      } else {
        deadline = now.add(const Duration(days: 30)); // Default for flexible
      }

      final request = RepairRequest(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        ownerId: user.uid,
        title: _titleController.text,
        description: _descriptionController.text,
        images: [], // TODO: Add image picker
        location: 'Cairo, Egypt', // TODO: Add location picker
        status: RequestStatus.posted,
        createdAt: now,
        biddingEndsAt: deadline,
        // New Fields
        budgetMin: double.tryParse(_budgetMinController.text),
        budgetMax: double.tryParse(_budgetMaxController.text),
        riskLevel: _riskLevel,
        aiReportId: _selectedReport,
      );

      Provider.of<AppState>(
        context,
        listen: false,
      ).createRepairRequest(request);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.listingSuccess)),
      );
      Navigator.pop(context);
    }
  }

  InputDecoration _buildInputDecoration({
    required String labelText,
    String? hintText,
    IconData? icon,
    String? suffixText,
    String? prefixText,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: icon != null ? Icon(icon, color: AppColors.grey500) : null,
      suffixText: suffixText,
      prefixText: prefixText,
      filled: true,
      fillColor: AppColors.backgroundLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.r12),
        borderSide: const BorderSide(color: AppColors.borderLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.r12),
        borderSide: const BorderSide(color: AppColors.borderLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.r12),
        borderSide: const BorderSide(color: AppColors.primary500, width: 2),
      ),
    );
  }

  Widget _buildTimelineChip(String label, String value) {
    final isSelected = _timeline == value;
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? AppColors.white : AppColors.textSecondary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onSelected: (selected) => setState(() => _timeline = value),
      selectedColor: AppColors.primary500,
      backgroundColor: AppColors.backgroundLight,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
    );
  }

  Widget _buildServiceCheckbox(String title, String value) {
    return CheckboxListTile(
      title: Text(title, style: AppTypography.bodyText),
      value: _selectedServices.contains(value),
      onChanged: (checked) {
        setState(() {
          if (checked ?? false) {
            _selectedServices.add(value);
          } else {
            _selectedServices.remove(value);
          }
        });
      },
      activeColor: AppColors.primary500,
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  void _showReportSelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.r20),
        ),
      ),
      builder: (context) => ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.lg),
        itemCount: _availableReports.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final report = _availableReports[index];
          return ListTile(
            title: Text(report),
            onTap: () {
              setState(() {
                _selectedReport = report;
                // Auto-detect risk from mock string
                if (report.contains('High Risk')) {
                  _riskLevel = RiskLevel.high;
                } else if (report.contains('Medium')) {
                  _riskLevel = RiskLevel.medium;
                } else {
                  _riskLevel = RiskLevel.low;
                }
              });
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
