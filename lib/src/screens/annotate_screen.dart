import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../store/app_state.dart';
import '../models/building_models.dart';
import '../design/colors.dart';
import '../design/typography.dart';
import '../design/spacing.dart';
import '../design/radius.dart';

/// Annotation screen — lets the engineer mark and describe a crack on the image.
///
/// Optional step shown after viewing the result.
/// Annotation is saved locally and will sync to backend when ready.
class AnnotateScreen extends StatefulWidget {
  final String reportId;
  final String imagePath;

  const AnnotateScreen({
    super.key,
    required this.reportId,
    required this.imagePath,
  });

  @override
  State<AnnotateScreen> createState() => _AnnotateScreenState();
}

class _AnnotateScreenState extends State<AnnotateScreen> {
  final _notesController = TextEditingController();
  String _selectedCrackType = 'structural';
  Offset? _tapPosition; // position tapped on the image
  bool _isSaving = false;

  static const _crackTypes = [
    'structural',
    'surface',
    'hairline',
    'corner',
    'diagonal',
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_tapPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('انقر على الصورة لتحديد موضع الشق')),
      );
      return;
    }

    setState(() => _isSaving = true);

    final annotation = Annotation.create(
      scanId: widget.reportId,
      coords: '{"x":${_tapPosition!.dx.toStringAsFixed(1)},'
          '"y":${_tapPosition!.dy.toStringAsFixed(1)}}',
      crackType: _selectedCrackType,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );

    if (!mounted) return;
    context.read<AppState>().addAnnotation(annotation);

    setState(() => _isSaving = false);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم حفظ التعليق بنجاح'),
        backgroundColor: AppColors.successGreen,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('إضافة تعليق على الشق', style: AppTypography.h3),
        backgroundColor: AppColors.primary500,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with tap to annotate
            Text('انقر على موضع الشق في الصورة', style: AppTypography.h4),
            const SizedBox(height: AppSpacing.sm),
            GestureDetector(
              onTapDown: (details) {
                setState(() => _tapPosition = details.localPosition);
              },
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.r16),
                    child: Image.file(
                      File(widget.imagePath),
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                  ),
                  if (_tapPosition != null)
                    Positioned(
                      left: _tapPosition!.dx - 12,
                      top: _tapPosition!.dy - 12,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: AppColors.dangerRed.withValues(alpha: 0.8),
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.white, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (_tapPosition != null)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xs),
                child: Text(
                  '✓ تم تحديد الموضع',
                  style: AppTypography.caption
                      .copyWith(color: AppColors.successGreen),
                ),
              ),
            const SizedBox(height: AppSpacing.lg),

            // Crack type selector
            Text('نوع الشق', style: AppTypography.h4),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.xs,
              children: _crackTypes.map((type) {
                final selected = _selectedCrackType == type;
                return ChoiceChip(
                  label: Text(type),
                  selected: selected,
                  onSelected: (_) => setState(() => _selectedCrackType = type),
                  selectedColor: AppColors.primary500,
                  labelStyle: AppTypography.caption.copyWith(
                    color: selected ? AppColors.white : AppColors.grey700,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Notes field
            Text('ملاحظات (اختياري)', style: AppTypography.h4),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'أضف وصفاً للشق أو ملاحظات إضافية...',
                hintStyle: AppTypography.bodySmall
                    .copyWith(color: AppColors.placeholder),
                filled: true,
                fillColor: AppColors.grey50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.r12),
                  borderSide: const BorderSide(color: AppColors.grey200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.r12),
                  borderSide:
                      const BorderSide(color: AppColors.primary500, width: 2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary500,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.r12),
                  ),
                ),
                child: _isSaving
                    ? const CircularProgressIndicator(color: AppColors.white)
                    : Text('حفظ التعليق',
                        style: AppTypography.button
                            .copyWith(color: AppColors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
