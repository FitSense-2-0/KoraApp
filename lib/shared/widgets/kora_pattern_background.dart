import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class KoraPatternBackground extends StatelessWidget {
  const KoraPatternBackground({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(
          color: AppColors.background,
        ),

        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: _KoraPatternPainter(),
            ),
          ),
        ),

        child,
      ],
    );
  }
}

class _KoraPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.secondary.withValues(alpha: 0.07)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    const spacing = 38.0;

    for (double x = -size.height; x < size.width; x += spacing * 2) {
      for (double y = 0; y < size.height; y += spacing * 2) {
        final rect = Rect.fromLTWH(
          x + (y % (spacing * 4)),
          y,
          spacing,
          spacing,
        );

        canvas.drawRRect(
          RRect.fromRectAndRadius(
            rect,
            const Radius.circular(12),
          ),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}