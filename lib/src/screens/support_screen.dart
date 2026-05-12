import 'package:flutter/material.dart';
import '../core/api_client.dart';
import '../core/api_exception.dart';
import '../store/app_state.dart';
import '../widgets/app_top_bar.dart';
import '../design/typography.dart';
import '../design/spacing.dart';
import '../design/colors.dart';
import '../design/radius.dart';

/// Support screen — allows users to submit support tickets via POST /support.
/// FAQ section stays static; Contact form submits to backend.
class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: AppTopBar(
        title: 'الدعم والمساعدة',
        onBack: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('الإجراءات السريعة', style: AppTypography.h3),
              const SizedBox(height: AppSpacing.md),

              _QuickActionCard(
                icon: Icons.help_center,
                title: 'الأسئلة الشائعة',
                description: 'إجابات على الأسئلة الأكثر شيوعاً',
                onTap: () => _scrollToFAQ(context),
              ),
              const SizedBox(height: AppSpacing.md),

              _QuickActionCard(
                icon: Icons.mail,
                title: 'تواصل مع الدعم',
                description: 'أرسل تذكرة دعم للفريق',
                onTap: () => _showContactForm(context),
              ),
              const SizedBox(height: AppSpacing.md),

              _QuickActionCard(
                icon: Icons.send,
                title: 'إرسال ملاحظة',
                description: 'شاركنا أفكارك واقتراحاتك',
                onTap: () => _showFeedbackForm(context),
              ),
              const SizedBox(height: AppSpacing.xxl),

              Text('الأسئلة الشائعة', style: AppTypography.h3),
              const SizedBox(height: AppSpacing.md),

              const _FAQItem(
                question: 'ما مدى دقة الذكاء الاصطناعي؟',
                answer: 'يصل نموذجنا إلى دقة 96.8% في كشف الأضرار الإنشائية.',
              ),
              const _FAQItem(
                question: 'هل يمكنني تصدير التقارير؟',
                answer: 'نعم، يمكن تصدير تقارير الفحص بصيغة PDF.',
              ),
              const _FAQItem(
                question: 'هل بياناتي آمنة؟',
                answer: 'جميع بياناتك مشفّرة ومحفوظة بأمان على خوادمنا.',
              ),
              const _FAQItem(
                question: 'هل يعمل التطبيق بدون إنترنت؟',
                answer: 'يمكنك عرض التقارير المحفوظة بدون إنترنت، لكن التحليل يحتاج اتصالاً.',
              ),
              const _FAQItem(
                question: 'ما صيغ الصور المدعومة؟',
                answer: 'ندعم JPG وPNG وصيغ الصور الشائعة الأخرى.',
              ),
              const SizedBox(height: AppSpacing.xxl),

              Text('تواصل معنا', style: AppTypography.h3),
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

  void _scrollToFAQ(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('انتقل إلى قسم الأسئلة الشائعة')),
    );
  }

  void _showContactForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => _ContactDialog(),
    );
  }

  void _showFeedbackForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => _FeedbackDialog(),
    );
  }
}

// ─── Contact Dialog (submits to POST /support) ────────────────────────────────

class _ContactDialog extends StatefulWidget {
  @override
  State<_ContactDialog> createState() => _ContactDialogState();
}

class _ContactDialogState extends State<_ContactDialog> {
  final _subjectCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  bool _isSending = false;
  String? _error;

  @override
  void dispose() {
    _subjectCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (_subjectCtrl.text.trim().isEmpty || _messageCtrl.text.trim().isEmpty) {
      setState(() => _error = 'يرجى ملء جميع الحقول');
      return;
    }
    setState(() { _isSending = true; _error = null; });
    try {
      if (!AppState.useMockData) {
        await ApiClient.instance.post('/support', data: {
          'subject': _subjectCtrl.text.trim(),
          'message': _messageCtrl.text.trim(),
          'type':    'support',
        });
      }
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم إرسال رسالتك بنجاح! سنرد عليك قريباً.'),
          backgroundColor: AppColors.successGreen,
        ),
      );
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } catch (_) {
      if (mounted) setState(() => _error = 'حدث خطأ، حاول مرة أخرى');
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('تواصل مع الدعم'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Text(_error!,
                  style: AppTypography.caption.copyWith(
                      color: AppColors.dangerRed)),
            ),
          TextField(
            controller: _subjectCtrl,
            decoration: InputDecoration(
              hintText: 'الموضوع',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.r12)),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _messageCtrl,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'رسالتك',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.r12)),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: _isSending ? null : _send,
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary500),
          child: _isSending
              ? const SizedBox(
                  width: 16, height: 16,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: AppColors.white))
              : const Text('إرسال'),
        ),
      ],
    );
  }
}

// ─── Feedback Dialog ─────────────────────────────────────────────────────────

class _FeedbackDialog extends StatefulWidget {
  @override
  State<_FeedbackDialog> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<_FeedbackDialog> {
  final _ctrl = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (_ctrl.text.trim().isEmpty) return;
    setState(() => _isSending = true);
    try {
      if (!AppState.useMockData) {
        await ApiClient.instance.post('/support', data: {
          'message': _ctrl.text.trim(),
          'type':    'feedback',
        });
      }
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('شكراً على ملاحظتك!'),
          backgroundColor: AppColors.successGreen,
        ),
      );
    } catch (_) {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('إرسال ملاحظة'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _ctrl,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'ملاحظتك...',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.r12)),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: _isSending ? null : _send,
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary500),
          child: _isSending
              ? const SizedBox(
                  width: 16, height: 16,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: AppColors.white))
              : const Text('إرسال'),
        ),
      ],
    );
  }
}

// ─── Sub-widgets ─────────────────────────────────────────────────────────────

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
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(
                color: AppColors.primary100,
                borderRadius: BorderRadius.circular(AppRadius.r12),
              ),
              child: Icon(icon, color: AppColors.primary900, size: 28),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.h4),
                  const SizedBox(height: AppSpacing.xs),
                  Text(description, style: AppTypography.caption),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.grey400),
          ],
        ),
      ),
    );
  }
}

class _FAQItem extends StatefulWidget {
  final String question;
  final String answer;

  const _FAQItem({required this.question, required this.answer});

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
        title: Text(widget.question, style: AppTypography.h4),
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Text(
              widget.answer,
              style: AppTypography.bodySmall.copyWith(color: AppColors.grey600),
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

  const _SocialIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48, height: 48,
        decoration: const BoxDecoration(
          color: AppColors.primary100,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.primary900),
      ),
    );
  }
}
