import 'dart:io';
import 'package:flutter/material.dart';
import 'package:crackdetectx/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../design/colors.dart';
import '../design/typography.dart';
import '../design/spacing.dart';
import '../design/radius.dart';
import '../store/app_state.dart';
import '../models/marketplace_models.dart';
import '../repositories/marketplace_repository.dart';
import '../models/offline_models.dart';
import '../core/api_exception.dart';
import 'package:uuid/uuid.dart';

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
  final List<XFile> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

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

            // Images Section
            Text(
              'Photos',
              style: AppTypography.h4,
            ),
            const SizedBox(height: AppSpacing.md),
            _buildImagePickerSection(),
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
                    if (level == RiskLevel.medium) {
                      color = AppColors.warningOrange;
                    }
                    if (level == RiskLevel.high) {
                      color = AppColors.dangerRed;
                    }

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
              onPressed: _isSubmitting ? null : _submitListing,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary500,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.r12),
                ),
                elevation: 2,
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      width: 20, height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: AppColors.white))
                  : Text(
                      AppLocalizations.of(context)!.listingPublishAction,
                      style: AppTypography.button.copyWith(fontSize: 16),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isSubmitting = false;

  Future<void> _submitListing() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_isSubmitting) return;

    final appState = Provider.of<AppState>(context, listen: false);
    final currentUser = appState.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.listingLoginError)),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      if (!appState.isOnline) {
        // ── Offline: save as draft ────────────────────────────────────────
        final draft = OfflineDraft(
          id: const Uuid().v4(),
          request: RepairRequest(
            id: const Uuid().v4(),
            ownerId: currentUser.id,
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
            images: _selectedImages.map((f) => f.path).toList(),
            location: 'Cairo, Egypt',
            status: RequestStatus.draft,
            budgetMin: double.tryParse(_budgetMinController.text),
            budgetMax: double.tryParse(_budgetMaxController.text),
            riskLevel: _riskLevel,
            createdAt: DateTime.now(),
          ),
          createdAt: DateTime.now(),
        );
        appState.saveOfflineDraft(draft.request);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم الحفظ كمسودة — سيُرسل عند استعادة الإنترنت'),
            backgroundColor: AppColors.warningOrange,
          ),
        );
        Navigator.pop(context);
        return;
      }

      // ── Online: send to backend ───────────────────────────────────────
      final request = await MarketplaceRepository.instance.createRequest(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        location: 'Cairo, Egypt',
        budgetMin: double.tryParse(_budgetMinController.text),
        budgetMax: double.tryParse(_budgetMaxController.text),
        riskLevel: _riskLevel.name,
        aiReportId: _selectedReport,
      );

      appState.createRepairRequest(request);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.listingSuccess),
            backgroundColor: AppColors.successGreen),
      );
      Navigator.pop(context);
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: AppColors.dangerRed),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('حدث خطأ، حاول مرة أخرى')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
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

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImages.add(image);
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  Widget _buildImagePickerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_selectedImages.isNotEmpty) ...[
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _selectedImages.length + 1,
              itemBuilder: (context, index) {
                if (index == _selectedImages.length) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: InkWell(
                      onTap: _pickImage,
                      child: Container(
                        width: 100,
                        decoration: BoxDecoration(
                          color: AppColors.backgroundLight,
                          borderRadius: BorderRadius.circular(AppRadius.r12),
                          border: Border.all(color: AppColors.borderLight, style: BorderStyle.solid),
                        ),
                        child: const Center(
                          child: Icon(Icons.add_a_photo, color: AppColors.primary500),
                        ),
                      ),
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.r12),
                        child: Image.file(
                          File(_selectedImages[index].path),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedImages.removeAt(index);
                            });
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(4),
                            child: const Icon(Icons.close, size: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ] else ...[
          InkWell(
            onTap: _pickImage,
            child: Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(AppRadius.r12),
                border: Border.all(color: AppColors.borderLight, style: BorderStyle.solid),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_photo_alternate, size: 40, color: AppColors.grey400),
                  const SizedBox(height: 8),
                  Text('Add Photos', style: AppTypography.bodyText.copyWith(color: AppColors.grey500)),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
