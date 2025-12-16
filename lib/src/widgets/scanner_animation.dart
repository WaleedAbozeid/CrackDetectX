import 'package:flutter/material.dart';
import '../design/colors.dart';

/// A simple scanning animation widget: a rounded container with a moving
/// translucent scan line. Lightweight and doesn't require external assets.
class ScannerAnimation extends StatefulWidget {
  final double height;
  final double borderRadius;
  const ScannerAnimation({super.key, this.height = 220, this.borderRadius = 12});

  @override
  State<ScannerAnimation> createState() => _ScannerAnimationState();
}

class _ScannerAnimationState extends State<ScannerAnimation> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: Container(
        height: widget.height,
        width: double.infinity,
        color: AppColors.grey50,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // background subtle grid / overlay
            Opacity(
              opacity: 0.06,
              child: Image.asset('assets/lottie/placeholder_grid.png', fit: BoxFit.cover, errorBuilder: (_, _, _) => const SizedBox.shrink()),
            ),

            // moving scan line
            AnimatedBuilder(
              animation: _ctrl,
              builder: (context, child) {
                final t = _ctrl.value;
                final top = (t * (widget.height + 40)) - 20; // move slightly out of bounds
                return Positioned(
                  top: top.clamp(-20.0, widget.height),
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary500.withValues(alpha: 0.0), AppColors.primary300.withValues(alpha: 0.7), AppColors.primary500.withValues(alpha: 0.0)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                  ),
                );
              },
            ),

            // centered placeholder camera/preview icon
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.camera_alt, size: 48, color: AppColors.grey400),
                  SizedBox(height: 8),
                  Text('معاينة المسح', style: TextStyle(color: AppColors.grey600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
