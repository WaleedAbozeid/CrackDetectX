import 'package:flutter/material.dart';
import '../widgets/app_button.dart';
import '../widgets/scanner_animation.dart';
import 'image_review_screen.dart';
import 'ai_processing_screen.dart';
import 'package:provider/provider.dart';
import '../store/app_state.dart';
import '../design/spacing.dart';
import '../widgets/top_bar.dart';
import 'package:image_picker/image_picker.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  bool _loading = false;

  Future<void> _pickImage(BuildContext context) async {
    setState(() {
      _loading = true;
    });
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        Provider.of<AppState>(context, listen: false).setSelectedImage(picked.path);
        Navigator.push(context, MaterialPageRoute(builder: (_) => const ImageReviewScreen()));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('حدث خطأ أثناء اختيار الصورة: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(title: 'اختيار صورة'),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            const ScannerAnimation(),
            const SizedBox(height: AppSpacing.md),
            _loading
                ? const CircularProgressIndicator()
                : AppButton(title: 'اختر من المعرض', onPressed: () => _pickImage(context)),
            const SizedBox(height: AppSpacing.sm),
            AppButton(title: 'تحليل بواسطة الذكاء الاصطناعي', onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AIProcessingScreen()))),
          ],
        ),
      ),
    );
  }
}
