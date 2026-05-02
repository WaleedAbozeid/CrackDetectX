import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../store/app_state.dart';
import '../design/spacing.dart';
import '../design/radius.dart';
import '../design/typography.dart';

class CreateDisputeScreen extends StatefulWidget {
  final String contractId;
  final String raisedBy;
  final String raisedByName;

  const CreateDisputeScreen({
    super.key,
    required this.contractId,
    required this.raisedBy,
    required this.raisedByName,
  });

  @override
  State<CreateDisputeScreen> createState() => _CreateDisputeScreenState();
}

class _CreateDisputeScreenState extends State<CreateDisputeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Raise a Dispute'),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Warning Card
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(AppRadius.r8),
                  border: Border.all(color: Colors.red, width: 2),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning, color: Colors.red, size: 32),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Important Notice',
                            style: AppTypography.h4.copyWith(color: Colors.red),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Disputes are reviewed by our admin team. Please provide accurate and detailed information.',
                            style: AppTypography.caption,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Reason Field
              Text('Reason for Dispute', style: AppTypography.h4),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _reasonController,
                decoration: const InputDecoration(
                  hintText:
                      'e.g., Quality issues, Delayed completion, Payment dispute...',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a reason';
                  }
                  return null;
                },
              ),

              const SizedBox(height: AppSpacing.lg),

              // Description Field
              Text('Detailed Description', style: AppTypography.h4),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Provide a detailed explanation of the issue...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 8,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please provide a detailed description';
                  }
                  if (value.trim().length < 20) {
                    return 'Description must be at least 20 characters';
                  }
                  return null;
                },
              ),

              const SizedBox(height: AppSpacing.xl),

              // Submit Button
              ElevatedButton.icon(
                onPressed: _submitDispute,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size(double.infinity, 52),
                ),
                icon: const Icon(Icons.send),
                label: const Text(
                  'Submit Dispute',
                  style: TextStyle(fontSize: 16),
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // Cancel Button
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                ),
                child: const Text('Cancel', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitDispute() {
    if (!_formKey.currentState!.validate()) return;

    final appState = Provider.of<AppState>(context, listen: false);

    appState.createDispute(
      contractId: widget.contractId,
      raisedBy: widget.raisedBy,
      raisedByName: widget.raisedByName,
      reason: _reasonController.text.trim(),
      description: _descriptionController.text.trim(),
    );

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Dispute submitted successfully. Our team will review it.',
        ),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 3),
      ),
    );

    // Go back
    Navigator.pop(context);
  }
}
