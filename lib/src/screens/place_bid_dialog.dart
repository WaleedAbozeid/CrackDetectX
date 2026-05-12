import 'package:flutter/material.dart';
import 'package:crackdetectx/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../design/colors.dart';
import '../design/typography.dart';
import '../design/spacing.dart';
import '../design/radius.dart';
import '../store/app_state.dart';
import '../models/marketplace_models.dart';
import '../repositories/marketplace_repository.dart';
import '../core/api_exception.dart';

class PlaceBidDialog extends StatefulWidget {
  final RepairRequest request;
  final String engineerId;
  final String engineerName;

  const PlaceBidDialog({
    super.key,
    required this.request,
    required this.engineerId,
    required this.engineerName,
  });

  @override
  State<PlaceBidDialog> createState() => _PlaceBidDialogState();
}

class _PlaceBidDialogState extends State<PlaceBidDialog> {
  final _formKey = GlobalKey<FormState>();
  final _priceController = TextEditingController();
  final _durationController = TextEditingController();
  final _warrantyController = TextEditingController();
  final _proposalController = TextEditingController();
  final _methodController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _priceController.dispose();
    _durationController.dispose();
    _warrantyController.dispose();
    _proposalController.dispose();
    _methodController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    try {
      // ── Live API call ──────────────────────────────────────────────────
      final bid = await MarketplaceRepository.instance.submitBid(
        requestId: widget.request.id,
        price: double.parse(_priceController.text),
        durationDays: int.parse(_durationController.text),
        proposal: _proposalController.text,
        warrantyMonths: int.tryParse(_warrantyController.text) ?? 0,
        methodDescription: _methodController.text.isNotEmpty
            ? _methodController.text
            : null,
      );

      if (!mounted) return;
      // Keep local AppState in sync
      Provider.of<AppState>(context, listen: false).placeBid(bid);

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.bidSuccess),
          backgroundColor: AppColors.successGreen,
        ),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: AppColors.dangerRed,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.bidError(e.toString())),
          backgroundColor: AppColors.dangerRed,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.bidTitle,
          style: const TextStyle(color: AppColors.primary900),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: const BackButton(color: AppColors.primary900),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Project Summary Card
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.primary50,
                  borderRadius: BorderRadius.circular(AppRadius.r12),
                  border: Border.all(color: AppColors.primary100),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${AppLocalizations.of(context)!.bidProjectPrefix}${widget.request.title}',
                            style: AppTypography.h4.copyWith(
                              color: AppColors.primary900,
                            ),
                          ),
                        ),
                        if (widget.request.biddingEndsAt != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  DateTime.now().isAfter(
                                    widget.request.biddingEndsAt!,
                                  )
                                  ? AppColors.dangerRed.withValues(alpha: 0.1)
                                  : AppColors.successGreen.withValues(
                                      alpha: 0.1,
                                    ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              DateTime.now().isAfter(
                                    widget.request.biddingEndsAt!,
                                  )
                                  ? AppLocalizations.of(context)!.bidClosed
                                  : AppLocalizations.of(context)!.bidOpen,
                              style: AppTypography.caption.copyWith(
                                color:
                                    DateTime.now().isAfter(
                                      widget.request.biddingEndsAt!,
                                    )
                                    ? AppColors.dangerRed
                                    : AppColors.successGreen,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.request.location,
                      style: AppTypography.bodySmall,
                    ),
                    if (widget.request.budgetMin != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(context)!.bidBudgetRange(
                          widget.request.budgetMin.toString(),
                          widget.request.budgetMax.toString(),
                        ),
                        style: AppTypography.caption.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary700,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              if (widget.request.biddingEndsAt != null &&
                  DateTime.now().isAfter(widget.request.biddingEndsAt!))
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.timer_off_outlined,
                          size: 48,
                          color: AppColors.dangerRed,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          AppLocalizations.of(context)!.bidClosedMessage,
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.dangerRed,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else ...[
                // Financial Proposal
                Text(
                  AppLocalizations.of(context)!.bidFinancialTitle,
                  style: AppTypography.h4,
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        decoration: _buildInput(
                          AppLocalizations.of(context)!.bidPrice,
                          AppLocalizations.of(context)!.currencyEGP,
                        ),
                        validator: (v) => v!.isEmpty
                            ? AppLocalizations.of(context)!.errorRequired
                            : null,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: TextFormField(
                        controller: _durationController,
                        keyboardType: TextInputType.number,
                        decoration: _buildInput(
                          AppLocalizations.of(context)!.bidDuration,
                          AppLocalizations.of(context)!.unitDays,
                        ),
                        validator: (v) => v!.isEmpty
                            ? AppLocalizations.of(context)!.errorRequired
                            : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),

                TextFormField(
                  controller: _warrantyController,
                  keyboardType: TextInputType.number,
                  decoration: _buildInput(
                    AppLocalizations.of(context)!.bidWarranty,
                    AppLocalizations.of(context)!.unitMonths,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Technical Proposal
                Text(
                  AppLocalizations.of(context)!.bidTechnicalTitle,
                  style: AppTypography.h4,
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _methodController,
                  maxLines: 3,
                  decoration: _buildInput(
                    AppLocalizations.of(context)!.bidMethodology,
                    null,
                    AppLocalizations.of(context)!.bidMethodologyHint,
                  ),
                  validator: (v) => v!.isEmpty
                      ? AppLocalizations.of(context)!.errorRequired
                      : null,
                ),
                const SizedBox(height: AppSpacing.lg),
                TextFormField(
                  controller: _proposalController,
                  maxLines: 4,
                  decoration: _buildInput(
                    AppLocalizations.of(context)!.bidNotes,
                    null,
                    AppLocalizations.of(context)!.bidNotesHint,
                  ),
                ),

                const SizedBox(height: AppSpacing.xxl),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary500,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.r12),
                      ),
                    ),
                    child: _isSubmitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            AppLocalizations.of(context)!.bidSubmitAction,
                            style: AppTypography.button.copyWith(fontSize: 16),
                          ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInput(String label, [String? suffix, String? hint]) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      suffixText: suffix,
      filled: true,
      fillColor: AppColors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.r12),
        borderSide: const BorderSide(color: AppColors.borderLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.r12),
        borderSide: const BorderSide(color: AppColors.borderLight),
      ),
    );
  }
}
