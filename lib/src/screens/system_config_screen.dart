import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../store/app_state.dart';
import '../models/admin_models.dart';
import '../design/colors.dart';
import '../design/spacing.dart';
import '../design/typography.dart';
import '../design/radius.dart';

class SystemConfigScreen extends StatefulWidget {
  const SystemConfigScreen({super.key});

  @override
  State<SystemConfigScreen> createState() => _SystemConfigScreenState();
}

class _SystemConfigScreenState extends State<SystemConfigScreen> {
  late TextEditingController _biddingWindowController;
  late TextEditingController _minBudgetController;
  late TextEditingController _maxBudgetController;
  late TextEditingController _warrantyController;
  late TextEditingController _commissionController;
  late TextEditingController _aiThresholdController;

  @override
  void initState() {
    super.initState();
    final appState = Provider.of<AppState>(context, listen: false);
    final config =
        appState.systemConfig ??
        SystemConfig(
          id: 'config_1',
          lastUpdatedAt: DateTime.now(),
          lastUpdatedBy: 'System',
        );

    _biddingWindowController = TextEditingController(
      text: config.biddingWindowDays.toString(),
    );
    _minBudgetController = TextEditingController(
      text: config.minBudget.toString(),
    );
    _maxBudgetController = TextEditingController(
      text: config.maxBudget.toString(),
    );
    _warrantyController = TextEditingController(
      text: config.defaultWarrantyMonths.toString(),
    );
    _commissionController = TextEditingController(
      text: config.platformCommissionRate.toString(),
    );
    _aiThresholdController = TextEditingController(
      text: config.aiConfidenceThreshold.toString(),
    );
  }

  @override
  void dispose() {
    _biddingWindowController.dispose();
    _minBudgetController.dispose();
    _maxBudgetController.dispose();
    _warrantyController.dispose();
    _commissionController.dispose();
    _aiThresholdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final config = appState.systemConfig;

    return Scaffold(
      appBar: AppBar(
        title: const Text('System Configuration'),
        backgroundColor: AppColors.neutral800,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Info Banner
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.infoBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.r8),
                border: Border.all(color: AppColors.infoBlue),
              ),
              child: Row(
                children: [
                  Icon(Icons.info, color: AppColors.infoBlue),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      'Changes to system configuration affect all users',
                      style: AppTypography.body.copyWith(
                        color: AppColors.infoBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Marketplace Settings
            Text('Marketplace Settings', style: AppTypography.h3),
            const SizedBox(height: AppSpacing.md),

            _buildTextField(
              'Bidding Window (Days)',
              _biddingWindowController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: AppSpacing.md),

            _buildTextField(
              'Minimum Budget (EGP)',
              _minBudgetController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: AppSpacing.md),

            _buildTextField(
              'Maximum Budget (EGP)',
              _maxBudgetController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: AppSpacing.md),

            _buildTextField(
              'Default Warranty (Months)',
              _warrantyController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: AppSpacing.md),

            _buildTextField(
              'Platform Commission Rate (%)',
              _commissionController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),

            const SizedBox(height: AppSpacing.lg),
            const Divider(),
            const SizedBox(height: AppSpacing.lg),

            // AI Settings
            Text('AI Settings', style: AppTypography.h3),
            const SizedBox(height: AppSpacing.md),

            _buildTextField(
              'AI Confidence Threshold (0.0-1.0)',
              _aiThresholdController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            SwitchListTile(
              title: const Text('AI Auto-Approve Enabled'),
              subtitle: const Text(
                'Allow AI to auto-approve low-risk requests',
              ),
              value: config?.aiAutoApproveEnabled ?? false,
              onChanged: (value) {
                // Update config
              },
            ),

            SwitchListTile(
              title: const Text('Force Manual Review for High-Risk'),
              subtitle: const Text(
                'High-risk cases always require manual review',
              ),
              value: config?.forceManualReviewHighRisk ?? true,
              onChanged: (value) {
                // Update config
              },
            ),

            const SizedBox(height: AppSpacing.xl),

            // Save Button
            ElevatedButton.icon(
              onPressed: _saveConfiguration,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary900,
                minimumSize: const Size(double.infinity, 52),
              ),
              icon: const Icon(Icons.save),
              label: const Text(
                'Save Configuration',
                style: TextStyle(fontSize: 16),
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // Last Updated Info
            if (config != null)
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.neutral100,
                  borderRadius: BorderRadius.circular(AppRadius.r8),
                ),
                child: Column(
                  children: [
                    Text(
                      'Last updated by: ${config.lastUpdatedBy}',
                      style: AppTypography.caption,
                    ),
                    Text(
                      'On: ${_formatDate(config.lastUpdatedAt)}',
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.h5),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
      ],
    );
  }

  void _saveConfiguration() {
    final appState = Provider.of<AppState>(context, listen: false);

    try {
      final newConfig = SystemConfig(
        id: 'config_1',
        biddingWindowDays: int.parse(_biddingWindowController.text),
        minBudget: int.parse(_minBudgetController.text),
        maxBudget: int.parse(_maxBudgetController.text),
        defaultWarrantyMonths: int.parse(_warrantyController.text),
        platformCommissionRate: double.parse(_commissionController.text),
        aiConfidenceThreshold: double.parse(_aiThresholdController.text),
        lastUpdatedAt: DateTime.now(),
        lastUpdatedBy: 'Admin User', // TODO: Get real admin name
      );

      appState.setSystemConfig(newConfig);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Configuration saved successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving configuration: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
