import 'package:flutter/material.dart';
import 'package:crackdetectx/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../widgets/app_button.dart';
import '../widgets/dotted_border_container.dart';
import 'image_review_screen.dart';
import '../store/app_state.dart';
import '../design/spacing.dart';
import '../design/colors.dart';
import '../design/typography.dart';
import '../design/radius.dart';
import '../widgets/top_bar.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  bool _loading = false;

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    setState(() => _loading = true);
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: source);
      if (picked != null) {
        if (context.mounted) {
          Provider.of<AppState>(
            context,
            listen: false,
          ).setSelectedImage(picked.path);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ImageReviewScreen()),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.errorGeneric(e.toString()),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppTopBar(title: AppLocalizations.of(context)!.newScanTitle),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.uploadImageTitle,
                style: AppTypography.h3,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                AppLocalizations.of(context)!.uploadImageDesc,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Upload Zone
              GestureDetector(
                onTap: _loading
                    ? null
                    : () => _pickImage(context, ImageSource.gallery),
                child: DottedBorderContainer(
                  color: AppColors.primary300,
                  child: Container(
                    height: 280,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.primary50,
                      borderRadius: BorderRadius.circular(AppRadius.r16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary900.withValues(
                                  alpha: 0.05,
                                ),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: _loading
                              ? const CircularProgressIndicator()
                              : const Icon(
                                  Icons.cloud_upload_outlined,
                                  size: 48,
                                  color: AppColors.primary500,
                                ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          AppLocalizations.of(context)!.tapToSelect,
                          style: AppTypography.h4.copyWith(
                            color: AppColors.primary900,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          AppLocalizations.of(context)!.imageFormats,
                          style: AppTypography.caption,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.or,
                      style: AppTypography.caption,
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),

              const SizedBox(height: AppSpacing.xl),

              // Camera Button
              AppButton(
                title: AppLocalizations.of(context)!.takePhoto,
                prefixIcon: Icons.camera_alt,
                onPressed: () => _pickImage(context, ImageSource.camera),
                backgroundColor: AppColors.white,
                textColor: AppColors.primary900,
                useGradient: false,
                // Add border styling if supported by AppButton, otherwise it's fine as secondary style
              ),
            ],
          ),
        ),
      ),
    );
  }
}
