
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';

class PlanGenerationPage extends StatefulWidget {
  const PlanGenerationPage({super.key});

  @override
  State<PlanGenerationPage> createState() =>
      _PlanGenerationPageState();
}

class _PlanGenerationPageState extends State<PlanGenerationPage>
    with TickerProviderStateMixin {
  late final AnimationController _generationController;
  late final AnimationController _pulseController;

  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();

    _generationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _generationController,
      curve: Curves.easeInOut,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.88,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _generationController,
        curve: Curves.easeOutBack,
      ),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _generationController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        setState(() {
          _isCompleted = true;
        });

        _pulseController.stop();
      }
    });

    _generationController.forward();
  }

  @override
  void dispose() {
    _generationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dark,
      body: SafeArea(
        child: Stack(
          children: [
            const Positioned.fill(
              child: _GenerationBackground(),
            ),

            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),

                    _buildAnimatedIcon(),

                    const SizedBox(height: 88),

                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: Text(
                        _isCompleted
                            ? '¡Tu plan está listo!'
                            : 'Sincronizando...',
                        key: ValueKey(_isCompleted),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.manrope(
                          color: Colors.white,
                          fontSize: 37,
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.italic,
                          letterSpacing: -1.8,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: Text(
                        _isCompleted
                            ? 'Hemos preparado una propuesta de entrenamiento basada en tu perfil y preferencias.'
                            : 'Combinando tu perfil con modelos de optimización biomecánica.',
                        key: ValueKey('description_$_isCompleted'),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.manrope(
                          color: const Color(0xFF829783),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          height: 1.7,
                        ),
                      ),
                    ),

                    const SizedBox(height: 38),

                    if (!_isCompleted)
                      _buildProgress()
                    else
                      _buildCompletedIndicator(),
                  ],
                ),
              ),
            ),

            if (!_isCompleted)
              Positioned(
                left: 0,
                right: 0,
                bottom: 34,
                child: AnimatedBuilder(
                  animation: _generationController,
                  builder: (context, child) {
                    final progress =
                    (_generationController.value * 100).round();

                    return Text(
                      '$progress%',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.manrope(
                        color: const Color(0xFF829783),
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedIcon() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final pulse = _isCompleted
            ? 1.0
            : 1 + (_pulseController.value * 0.045);

        return Transform.scale(
          scale: pulse,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: 192,
            height: 192,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.045),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.12),
                width: 1,
              ),
            ),
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.07),
                ),
                child: Icon(
                  _isCompleted
                      ? Icons.check_circle_outline_rounded
                      : Icons.psychology_alt_rounded,
                  color: AppColors.primary,
                  size: 48,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgress() {
    return AnimatedBuilder(
      animation: _generationController,
      builder: (context, child) {
        return Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: _generationController.value,
                minHeight: 5,
                backgroundColor: Colors.white.withValues(alpha: 0.10),
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Preparando tu experiencia Kora',
              style: GoogleFonts.manrope(
                color: const Color(0xFF829783),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCompletedIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 22,
        vertical: 13,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_rounded,
            color: AppColors.primary,
            size: 19,
          ),
          const SizedBox(width: 9),
          Text(
            'Generación completada',
            style: GoogleFonts.manrope(
              color: AppColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _GenerationBackground extends StatelessWidget {
  const _GenerationBackground();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _GenerationBackgroundPainter(),
        size: Size.infinite,
      ),
    );
  }
}

class _GenerationBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF294A32)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 23
      ..strokeCap = StrokeCap.round;

    final topPath = Path()
      ..moveTo(-35, -40)
      ..cubicTo(20, 80, 55, 160, 125, 160)
      ..cubicTo(185, 160, 230, 65, 270, -30);

    canvas.drawPath(topPath, paint);

    final bottomPath = Path()
      ..moveTo(-45, size.height + 50)
      ..cubicTo(10, size.height - 110, 60, size.height - 165,
          125, size.height - 145)
      ..cubicTo(190, size.height - 125, 225, size.height - 25,
          270, size.height + 50);

    canvas.drawPath(bottomPath, paint);

    final cornerPaint = Paint()
      ..color = const Color(0xFF294A32)
      ..style = PaintingStyle.fill;

    final topCorner = Path()
      ..moveTo(size.width - 25, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, 22)
      ..close();

    canvas.drawPath(topCorner, cornerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}