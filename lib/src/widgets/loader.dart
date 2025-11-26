import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../design/colors.dart';
import '../design/typography.dart';

class Loader extends StatelessWidget {
  final String label;
  const Loader({this.label = 'جاري المعالجة...', super.key});

  @override
  Widget build(BuildContext context) {
    late final Widget animation;
    try {
      animation = Lottie.asset('assets/lottie/processing.json', width: 120, height: 120, repeat: true);
    } catch (_) {
      animation = CircularProgressIndicator(color: AppColors.primary500);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        animation,
        const SizedBox(height: 12),
        Text(label, style: AppTypography.bodyText1),
      ],
    );
  }
}
