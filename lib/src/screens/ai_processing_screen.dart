import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../store/app_state.dart';
import '../ai/model_stub.dart';
import '../widgets/loader.dart';
import 'result_screen.dart';
import '../widgets/top_bar.dart';
// spacing not needed here yet; kept for future token use

class AIProcessingScreen extends StatefulWidget {
  const AIProcessingScreen({super.key});

  @override
  State<AIProcessingScreen> createState() => _AIProcessingScreenState();
}

class _AIProcessingScreenState extends State<AIProcessingScreen> {
  @override
  void initState() {
    super.initState();
    _runProcessing();
  }

  Future<void> _runProcessing() async {
    final appState = Provider.of<AppState>(context, listen: false);
    final img = appState.selectedImagePath;
    try {
  final result = await processImageStub(img ?? '');
      appState.setDetectionResult(result);
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ResultScreen()));
    } catch (e) {
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ResultScreen(error: true)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(title: 'جارٍ التحليل'),
      body: const Center(child: Loader()),
    );
  }
}
