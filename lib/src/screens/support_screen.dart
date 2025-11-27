import 'package:flutter/material.dart';
import '../widgets/app_top_bar.dart';
import '../design/typography.dart';
import '../design/spacing.dart';
import '../design/colors.dart';
import '../design/radius.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: AppTopBar(
        title: 'Support & Help',
        onBack: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              // Quick Actions
              Text(
                'Quick Actions',
                style: AppTypography.h3,
              ),
              const SizedBox(height: AppSpacing.md),

              // FAQ Card
              _QuickActionCard(
                icon: Icons.help_center,
                title: 'FAQ & Guides',
                description: 'Find answers to common questions',
                onTap: () => _showFAQ(context),
              ),
              const SizedBox(height: AppSpacing.md),

              // Contact Support Card
              _QuickActionCard(
                icon: Icons.mail,
                title: 'Contact Support',
                description: 'Get in touch with our team',
                onTap: () => _showContactForm(context),
              ),
              const SizedBox(height: AppSpacing.md),

              // Send Feedback Card
              _QuickActionCard(
                icon: Icons.send,
                title: 'Send Feedback',
                description: 'Share your thoughts and suggestions',
                onTap: () => _showFeedbackForm(context),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // FAQ Section
              Text(
                'Frequently Asked Questions',
                style: AppTypography.h3,
              ),
              const SizedBox(height: AppSpacing.md),

              _FAQItem(
                question: 'How accurate is the AI?',
                answer: 'Our AI model has an accuracy of 96.8% in detecting structural damage.',
              ),
              _FAQItem(
                question: 'Can I export reports?',
                answer: 'Yes, you can export your inspection reports as PDF files.',
              ),
              _FAQItem(
                question: 'Is my data secure?',
                answer: 'All your data is encrypted and stored securely on our servers.',
              ),
              _FAQItem(
                question: 'Does it work offline?',
                answer: 'You can view your saved reports offline, but AI analysis requires internet.',
              ),
              _FAQItem(
                question: 'What image formats are supported?',
                answer: 'We support JPG, PNG, and other common image formats.',
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Social Media
              Text(
                'Follow Us',
                style: AppTypography.h3,
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _SocialIcon(icon: Icons.link, onTap: () {}),
                  const SizedBox(width: AppSpacing.lg),
                  _SocialIcon(icon: Icons.facebook, onTap: () {}),
                  const SizedBox(width: AppSpacing.lg),
                  _SocialIcon(icon: Icons.language, onTap: () {}),
                  const SizedBox(width: AppSpacing.lg),
                  _SocialIcon(icon: Icons.code, onTap: () {}),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  void _showFAQ(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening FAQ & Guides...')),
    );
  }

  void _showContactForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contact Support'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Subject',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.r12),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Your message',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.r12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Message sent successfully!')),
              );
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _showFeedbackForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send Feedback'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Your feedback',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.r12),
                ),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Checkbox(value: false, onChanged: (val) {}),
                const Expanded(
                  child: Text('Attach screenshot'),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Feedback sent! Thank you.')),
              );
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.r16),
          border: Border.all(color: AppColors.grey200),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primary100,
                borderRadius: BorderRadius.circular(AppRadius.r12),
              ),
              child: Icon(
                icon,
                color: AppColors.primary900,
                size: 28,
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.h4,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    description,
                    style: AppTypography.caption,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.grey400,
            ),
          ],
        ),
      ),
    );
  }
}

class _FAQItem extends StatefulWidget {
  final String question;
  final String answer;

  const _FAQItem({
    required this.question,
    required this.answer,
  });

  @override
  State<_FAQItem> createState() => _FAQItemState();
}

class _FAQItemState extends State<_FAQItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.r12),
        border: Border.all(color: AppColors.grey200),
      ),
      child: ExpansionTile(
        title: Text(
          widget.question,
          style: AppTypography.h4,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Text(
              widget.answer,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.grey600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SocialIcon({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.primary100,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: AppColors.primary900,
        ),
      ),
    );
  }
}
