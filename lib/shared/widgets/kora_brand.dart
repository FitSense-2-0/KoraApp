import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class KoraBrand extends StatelessWidget {
  const KoraBrand({
    super.key,
    this.height = 48,
    this.width,
    this.darkBackground = false,
  });

  final double height;
  final double? width;
  final bool darkBackground;

  @override
  Widget build(BuildContext context) {
    final brandWidth = width ?? height * 2.4;

    return Container(
      width: brandWidth,
      height: height,
      padding: EdgeInsets.symmetric(horizontal: height * 0.18),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(height * 0.45),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomPaint(
            size: Size(height * 0.55, height * 0.55),
            painter: _KoraMarkPainter(),
          ),
          SizedBox(width: height * 0.10),
          Text(
            'kora',
            style: TextStyle(
              color: AppColors.dark,
              fontSize: height * 0.43,
              fontWeight: FontWeight.w900,
              letterSpacing: -height * 0.025,
            ),
          ),
        ],
      ),
    );
  }
}

class _KoraMarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.dark
      ..strokeWidth = size.width * 0.19
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(size.width * 0.25, size.height * 0.88)
      ..lineTo(size.width * 0.38, size.height * 0.18)
      ..moveTo(size.width * 0.35, size.height * 0.59)
      ..lineTo(size.width * 0.75, size.height * 0.29)
      ..moveTo(size.width * 0.47, size.height * 0.53)
      ..lineTo(size.width * 0.78, size.height * 0.83);

    canvas.drawPath(path, paint);

    canvas.drawCircle(
      Offset(size.width * 0.72, size.height * 0.12),
      size.width * 0.105,
      Paint()..color = AppColors.dark,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}