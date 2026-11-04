
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';

import '../../../../shared/widgets/kora_primary_button.dart';
import '../../../../shared/widgets/kora_hover_text.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _backgroundAnimation;
  late final Animation<double> _logoAnimation;
  late final Animation<Offset> _logoSlide;

  late final Animation<double> _titleAnimation;
  late final Animation<Offset> _titleSlide;

  late final Animation<double> _descriptionAnimation;
  late final Animation<Offset> _descriptionSlide;

  late final Animation<double> _buttonAnimation;
  late final Animation<Offset> _buttonSlide;

  late final Animation<double> _loginAnimation;
  late final Animation<Offset> _loginSlide;

  late final Animation<double> _buttonScale;
  late final Animation<double> _loginScale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    _backgroundAnimation = _createFade(0.0, 0.55);

    _logoAnimation = _createFade(0.05, 0.40);
    _logoSlide = _createSlide(
      0.05,
      0.40,
      const Offset(0, -0.20),
    );

    _titleAnimation = _createFade(0.18, 0.62);
    _titleSlide = _createSlide(
      0.18,
      0.62,
      const Offset(-0.18, 0),
    );

    _descriptionAnimation = _createFade(0.38, 0.76);
    _descriptionSlide = _createSlide(
      0.38,
      0.76,
      const Offset(-0.10, 0),
    );

    _buttonAnimation = _createFade(0.55, 0.90);
    _buttonSlide = _createSlide(
      0.55,
      0.90,
      const Offset(0, 0.20),
    );

    _buttonScale = Tween<double>(
      begin: 0.88,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.55,
          0.90,
          curve: Curves.easeOutBack,
        ),
      ),
    );

    _loginAnimation = _createFade(0.72, 1.0);
    _loginSlide = _createSlide(
      0.72,
      1.0,
      const Offset(0, 0.12),
    );

    _loginScale = Tween<double>(
      begin: 0.94,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.72,
          1.0,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    _controller.forward();
  }

  Animation<double> _createFade(double begin, double end) {
    return CurvedAnimation(
      parent: _controller,
      curve: Interval(
        begin,
        end,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  Animation<Offset> _createSlide(
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
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          final headerHeight =
          (height * 0.085).clamp(68.0, 92.0);

          final buttonHeight =
          (height * 0.075).clamp(54.0, 70.0);

          final titleSize =
          (width * 0.082).clamp(29.0, 43.0);

          return Stack(
            fit: StackFit.expand,
            children: [
              // 1. FONDO.
              const ColoredBox(
                color: AppColors.dark,
              ),



// 2. FOTOGRAFÍA DEL DEPORTISTA.
// Comienza debajo del encabezado para evitar que se cubra la cabeza.
              Positioned(
                top: headerHeight + 12,
                left: 0,
                right: 0,
                bottom: 0,
                child: FadeTransition(
                  opacity: _backgroundAnimation,
                  child: ShaderMask(
                    blendMode: BlendMode.dstIn,
                    shaderCallback: (bounds) {
                      return const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black,
                          Colors.black,
                          Colors.black,
                          Colors.transparent,
                        ],
                        stops: [0.0, 0.12, 0.72, 0.86, 1.0],
                      ).createShader(bounds);
                    },
                    child: ShaderMask(
                      blendMode: BlendMode.dstIn,
                      shaderCallback: (bounds) {
                        return const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.transparent,
                            Colors.black,
                            Colors.black,
                            Colors.transparent,
                          ],
                          stops: [0.0, 0.12, 0.88, 1.0],
                        ).createShader(bounds);
                      },
                      child: Image.asset(
                        'assets/images/welcome_athlete.png',
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                        filterQuality: FilterQuality.high,
                        errorBuilder: (_, __, ___) {
                          return const SizedBox.expand();
                        },
                      ),
                    ),
                  ),
                ),
              ),

              // 3. OSCURECIMIENTO DEL FONDO.
              Positioned.fill(
                child: IgnorePointer(
                  child: Stack(
                    children: [
                      // Oscurecimiento lateral.
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                AppColors.dark.withValues(alpha: 0.78),
                                AppColors.dark.withValues(alpha: 0.42),
                                Colors.transparent,
                                Colors.transparent,
                              ],
                              stops: const [
                                0.0,
                                0.32,
                                0.62,
                                1.0,
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Integración inferior: transición progresiva hacia el fondo oscuro.
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.transparent,
                                AppColors.dark.withValues(alpha: 0.45),
                                AppColors.dark.withValues(alpha: 0.92),
                              ],
                              stops: const [
                                0.0,
                                0.68,
                                0.88,
                                1.0,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 4. CONTENIDO PRINCIPAL.
              SafeArea(
                child: LayoutBuilder(
                  builder: (context, safeConstraints) {
                    final contentHeight =
                        safeConstraints.maxHeight;

                    return Stack(
                      children: [
                        // ENCABEZADO KORA.
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: _entrance(
                            opacity: _logoAnimation,
                            position: _logoSlide,
                            child: Container(
                              height: headerHeight,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(40),
                                  bottomRight: Radius.circular(40),
                                ),
                              ),
                              child: Center(
                                child: Image.asset(
                                  'assets/images/kora_logo.png',
                                  width: width * 0.68,
                                  height: headerHeight * 0.78,
                                  fit: BoxFit.contain,
                                  filterQuality: FilterQuality.high,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // TITULAR Y DESCRIPCIÓN.
                        Positioned(
                          top: contentHeight * 0.255,
                          left: width * 0.075,
                          right: width * 0.27,
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // TITULAR.
                              _entrance(
                                opacity: _titleAnimation,
                                position: _titleSlide,
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: 'Tu rutina\n',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      const TextSpan(
                                        text: 'también\ncuenta.',
                                        style: TextStyle(
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.manrope(
                                    fontSize: titleSize,
                                    height: 1.04,
                                    fontWeight: FontWeight.w900,
                                    fontStyle: FontStyle.italic,
                                    letterSpacing: -1.5,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 18),

                              // DESCRIPCIÓN.
                              _entrance(
                                opacity: _descriptionAnimation,
                                position: _descriptionSlide,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: width * 0.58,
                                  ),
                                  child: Text(
                                    'Pequeños pasos, grandes\n'
                                        'cambios sostenibles con IA.',
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.manrope(
                                      color: const Color(0xFFE8EAE6),
                                      fontSize: (width * 0.032)
                                          .clamp(12.0, 16.0),
                                      height: 1.55,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // BOTÓN COMENZAR AHORA.
                        Positioned(
                          left: width * 0.105,
                          right: width * 0.105,
                          bottom: contentHeight * 0.125,
                          child: _entrance(
                            opacity: _buttonAnimation,
                            position: _buttonSlide,
                            child: ScaleTransition(
                              scale: _buttonScale,
                              child: KoraPrimaryButton(
                                label: 'Comenzar ahora',
                                onPressed: () {
                                  context.push(AppRoutes.register);
                                },
                                icon: Icons.arrow_forward_rounded,
                                height: buttonHeight,
                              ),
                            ),
                          ),
                        ),
// INICIO DE SESIÓN.
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: contentHeight * 0.045,
                          child: _entrance(
                            opacity: _loginAnimation,
                            position: _loginSlide,
                            child: ScaleTransition(
                              scale: _loginScale,
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    '¿Ya eres parte? ',
                                    style: GoogleFonts.manrope(
                                      color: Colors.white.withValues(alpha: 0.85),
                                      fontSize: (width * 0.034).clamp(12.0, 17.0),
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  KoraHoverText(
                                    text: 'Inicia sesión',
                                    onTap: () {
                                      context.push(AppRoutes.login);
                                    },
                                    fontSize: (width * 0.034).clamp(12.0, 17.0),
                                  ),
                                ],
                              ),
                            ),
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