
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  Timer? _navigationTimer;

  late final AnimationController _controller;

  late final Animation<double> _backgroundFade;

  late final Animation<double> _logoFade;
  late final Animation<double> _logoScale;
  late final Animation<Offset> _logoSlide;

  late final Animation<double> _sloganFade;
  late final Animation<Offset> _sloganSlide;

  late final Animation<double> _loaderFade;
  late final Animation<double> _loaderScale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _backgroundFade = _fade(0.0, 0.35);

    _logoFade = _fade(0.20, 0.65);
    _logoScale = Tween<double>(
      begin: 0.78,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.20,
          0.68,
          curve: Curves.easeOutBack,
        ),
      ),
    );

    _logoSlide = _slide(
      0.20,
      0.65,
      const Offset(0, 0.18),
    );

    _sloganFade = _fade(0.48, 0.82);
    _sloganSlide = _slide(
      0.48,
      0.82,
      const Offset(0, 0.15),
    );

    _loaderFade = _fade(0.62, 0.95);

    _loaderScale = Tween<double>(
      begin: 0.65,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.62,
          0.95,
          curve: Curves.easeOutBack,
        ),
      ),
    );

    _controller.forward();

    _navigationTimer = Timer(
      const Duration(seconds: 3),
          () {
        if (!mounted) return;
        context.go(AppRoutes.welcome);
      },
    );
  }

  Animation<double> _fade(double begin, double end) {
    return CurvedAnimation(
      parent: _controller,
      curve: Interval(
        begin,
        end,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  Animation<Offset> _slide(
      double begin,
      double end,
      Offset offset,
      ) {
    return Tween<Offset>(
      begin: offset,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          begin,
          end,
          curve: Curves.easeOutCubic,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Widget _entrance({
    required Widget child,
    required Animation<double> opacity,
    required Animation<Offset> position,
  }) {
    return FadeTransition(
      opacity: opacity,
      child: SlideTransition(
        position: position,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dark,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;

          final headerHeight =
          (screenHeight * 0.105).clamp(76.0, 100.0);

          final logoWidth =
          (screenWidth * 0.48).clamp(155.0, 225.0);

          return Stack(
            fit: StackFit.expand,
            children: [
              // 1. FONDO.
              FadeTransition(
                opacity: _backgroundFade,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/images/splash_gym.jpg',
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      errorBuilder: (_, __, ___) {
                        return const ColoredBox(
                          color: AppColors.dark,
                        );
                      },
                    ),

                    Container(
                      color: const Color(0xB5112E24),
                    ),

                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.dark.withValues(alpha: 0.25),
                            AppColors.dark.withValues(alpha: 0.45),
                            AppColors.dark.withValues(alpha: 0.88),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 2. CONTENIDO.
              SafeArea(
                child: LayoutBuilder(
                  builder: (context, safeConstraints) {
                    final contentHeight =
                        safeConstraints.maxHeight;

                    return Stack(
                      children: [
                        // LOGOTIPO KORA CON CÁPSULA VERDE LIMA.


                        SizedBox(
                          width: double.infinity,
                          height: contentHeight,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Spacer(flex: 5),

                              // 1. IDENTIDAD DE MARCA.
                              Center(
                                child: _entrance(
                                  opacity: _logoFade,
                                  position: _logoSlide,
                                  child: ScaleTransition(
                                    scale: _logoScale,
                                    child: Container(
                                      width: (screenWidth * 0.78).clamp(260.0, 340.0),
                                      height: (screenWidth * 0.24).clamp(88.0, 112.0),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 22,
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.circular(100),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.primary.withValues(alpha: 0.18),
                                            blurRadius: 28,
                                            spreadRadius: 1,
                                            offset: const Offset(0, 8),
                                          ),
                                        ],
                                      ),
                                      alignment: Alignment.center,
                                      child: Image.asset(
                                        'assets/images/kora_logo.png',
                                        fit: BoxFit.contain,
                                        filterQuality: FilterQuality.high,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 38),

                              // 2. ESLOGAN.
                              Center(
                                child: _entrance(
                                  opacity: _sloganFade,
                                  position: _sloganSlide,
                                  child: Text(
                                    'TU RUTINA CUENTA',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.manrope(
                                      color: AppColors.primary,
                                      fontSize: (screenWidth * 0.031).clamp(11.0, 14.0),
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 4.5,
                                    ),
                                  ),
                                ),
                              ),

                              const Spacer(flex: 4),

                              // 3. INDICADOR DE CARGA.
                              Center(
                                child: FadeTransition(
                                  opacity: _loaderFade,
                                  child: ScaleTransition(
                                    scale: _loaderScale,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 46,
                                          height: 46,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 4,
                                            color: AppColors.primary,
                                            backgroundColor: Colors.white.withValues(
                                              alpha: 0.08,
                                            ),
                                          ),
                                        ),

                                        const SizedBox(height: 22),

                                        Text(
                                          'Iniciando sesión',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.manrope(
                                            color: Colors.white.withValues(alpha: 0.68),
                                            fontSize: 11,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 2.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              const Spacer(flex: 3),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}