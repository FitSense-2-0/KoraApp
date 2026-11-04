
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/kora_primary_button.dart';
import '../../../../shared/widgets/kora_text_field.dart';
import '../../../../shared/widgets/kora_animated_link.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late final AnimationController _animationController;

  late final Animation<double> _headerFade;
  late final Animation<Offset> _headerSlide;

  late final Animation<double> _backFade;
  late final Animation<Offset> _backSlide;

  late final Animation<double> _titleFade;
  late final Animation<Offset> _titleSlide;

  late final Animation<double> _descriptionFade;
  late final Animation<Offset> _descriptionSlide;

  late final Animation<double> _formFade;
  late final Animation<Offset> _formSlide;

  late final Animation<double> _socialFade;
  late final Animation<Offset> _socialSlide;

  late final Animation<double> _footerFade;
  late final Animation<Offset> _footerSlide;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _headerFade = _fade(0.00, 0.30);
    _headerSlide = _slide(
      0.00,
      0.35,
      const Offset(0, -0.15),
    );

    _backFade = _fade(0.12, 0.42);
    _backSlide = _slide(
      0.12,
      0.42,
      const Offset(-0.15, 0),
    );

    _titleFade = _fade(0.20, 0.52);
    _titleSlide = _slide(
      0.20,
      0.52,
      const Offset(0, 0.15),
    );

    _descriptionFade = _fade(0.30, 0.60);
    _descriptionSlide = _slide(
      0.30,
      0.60,
      const Offset(0, 0.12),
    );

    _formFade = _fade(0.40, 0.76);
    _formSlide = _slide(
      0.40,
      0.76,
      const Offset(0, 0.12),
    );

    _socialFade = _fade(0.62, 0.88);
    _socialSlide = _slide(
      0.62,
      0.88,
      const Offset(0, 0.10),
    );

    _footerFade = _fade(0.72, 1.0);
    _footerSlide = _slide(
      0.72,
      1.0,
      const Offset(0, 0.10),
    );

    _animationController.forward();
  }

  // ===========================================
  // CONFIGURACIÓN DE ANIMACIONES.
  // ===========================================

  Animation<double> _fade(double begin, double end) {
    return CurvedAnimation(
      parent: _animationController,
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
        parent: _animationController,
        curve: Interval(
          begin,
          end,
          curve: Curves.easeOutCubic,
        ),
      ),
    );
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
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // ===========================================
  // VALIDACIONES.
  // ===========================================

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'Ingresa tu correo electrónico';
    }

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email)) {
      return 'Ingresa un correo válido';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingresa tu contraseña';
    }

    return null;
  }

  // ===========================================
  // INICIO DE SESIÓN.
  // ===========================================

  void _login() {
    if (!_formKey.currentState!.validate()) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Datos validados. La autenticación se conectará al backend posteriormente.',
        ),
      ),
    );
  }

  // ===========================================
  // INTERFAZ PRINCIPAL.
  // ===========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;

            final headerHeight =
            (height * 0.085).clamp(68.0, 92.0);

            return SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: height,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // =====================================
                    // 1. ENCABEZADO KORA.
                    // =====================================

                    _entrance(
                      opacity: _headerFade,
                      position: _headerSlide,
                      child: _buildBrandHeader(
                        width: width,
                        headerHeight: headerHeight,
                      ),
                    ),

                    // =====================================
                    // 2. CONTENIDO DE INICIO DE SESIÓN.
                    // =====================================

                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        24,
                        26,
                        24,
                        34,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // BOTÓN REGRESAR.
                          _entrance(
                            opacity: _backFade,
                            position: _backSlide,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: _BackButton(
                                onTap: () => context.pop(),
                              ),
                            ),
                          ),

                          const SizedBox(height: 38),

                          // =================================
                          // 3. PRESENTACIÓN.
                          // =================================

                          _entrance(
                            opacity: _titleFade,
                            position: _titleSlide,
                            child: Column(
                              children: [
                                Text(
                                  'PORTAL DE ACCESO',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.manrope(
                                    color: AppColors.secondary,
                                    fontSize: 11,
                                    letterSpacing: 2.0,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),

                                const SizedBox(height: 14),

                                Text.rich(
                                  TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: 'Entrena con\n',
                                      ),
                                      TextSpan(
                                        text: 'propósito.',
                                        style: TextStyle(
                                          color: AppColors.secondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.manrope(
                                    color: AppColors.dark,
                                    fontSize: 36,
                                    height: 1.15,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // DESCRIPCIÓN.
                          _entrance(
                            opacity: _descriptionFade,
                            position: _descriptionSlide,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                              child: Text(
                                'Ingresa tus credenciales para acceder '
                                    'a tu experiencia de entrenamiento '
                                    'personalizado.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.manrope(
                                  color: AppColors.secondary,
                                  fontSize: 15,
                                  height: 1.6,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 42),

                          // =================================
                          // 4. FORMULARIO.
                          // =================================

                          _entrance(
                            opacity: _formFade,
                            position: _formSlide,
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.stretch,
                                children: [
                                  KoraTextField(
                                    label: 'Correo electrónico',
                                    hint: 'nombre@ejemplo.com',
                                    icon: Icons.mail_outline,
                                    keyboardType:
                                    TextInputType.emailAddress,
                                    controller: _emailController,
                                    validator: _validateEmail,
                                  ),

                                  const SizedBox(height: 26),

                                  KoraTextField(
                                    label: 'Contraseña',
                                    hint: 'Ingresa tu contraseña',
                                    icon: Icons.lock_outline,
                                    isPassword: true,
                                    controller: _passwordController,
                                    validator: _validatePassword,
                                  ),

                                  // RECUPERAR CONTRASEÑA.
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {
                                        context.push(
                                          AppRoutes.forgotPassword,
                                        );
                                      },
                                      child: Text(
                                        '¿Olvidaste tu clave?',
                                        style: GoogleFonts.manrope(
                                          color: AppColors.secondary,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  // BOTÓN PRINCIPAL.
                                  KoraPrimaryButton(
                                    label: 'Iniciar sesión',
                                    onPressed: _login,
                                    icon: Icons.arrow_forward_rounded,
                                    height: 62,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 34),

                          // =================================
                          // 5. OPCIONES SOCIALES.
                          // =================================

                          _entrance(
                            opacity: _socialFade,
                            position: _socialSlide,
                            child: Column(
                              children: [
                                const Row(
                                  children: [
                                    Expanded(child: Divider()),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      child: Text(
                                        'O CONTINÚA CON',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: AppColors.secondary,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                    Expanded(child: Divider()),
                                  ],
                                ),

                                const SizedBox(height: 20),

                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.g_mobiledata,
                                        ),
                                        label: const Text('Google'),
                                        style: _socialButtonStyle(),
                                      ),
                                    ),

                                    const SizedBox(width: 12),

                                    Expanded(
                                      child: OutlinedButton.icon(
                                        onPressed: () {},
                                        icon: const Icon(Icons.apple),
                                        label: const Text('Apple'),
                                        style: _socialButtonStyle(),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 32),

                          // =================================
                          // 6. REGISTRO.
                          // =================================

                          _entrance(
                            opacity: _footerFade,
                            position: _footerSlide,
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment:
                              WrapCrossAlignment.center,
                              children: [
                                Text(
                                  '¿No eres miembro aún? ',
                                  style: GoogleFonts.manrope(
                                    color: AppColors.dark,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                                KoraAnimatedLink(
                                  label: 'Únete a la comunidad Kora',
                                  fontSize: 13,
                                  color: AppColors.secondary,
                                  animateOnMount: false,
                                  onTap: () {
                                    context.go(AppRoutes.register);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ===========================================
  // ENCABEZADO KORA.
  // MISMO DISEÑO QUE REGISTERPAGE.
  // ===========================================

  Widget _buildBrandHeader({
    required double width,
    required double headerHeight,
  }) {
    return Container(
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
    );
  }

  // ===========================================
  // ESTILO DE BOTONES SOCIALES.
  // ===========================================

  ButtonStyle _socialButtonStyle() {
    return OutlinedButton.styleFrom(
      foregroundColor: AppColors.dark,
      backgroundColor: Colors.white,
      side: const BorderSide(
        color: Color(0xFFE4E4E4),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      textStyle: GoogleFonts.manrope(
        fontWeight: FontWeight.w800,
        fontSize: 13,
      ),
    );
  }
}

// ===========================================
// BOTÓN REGRESAR.
// ===========================================

class _BackButton extends StatelessWidget {
  const _BackButton({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(17),
        side: const BorderSide(
          color: Color(0xFFE4E4E4),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: const SizedBox(
          width: 50,
          height: 50,
          child: Icon(
            Icons.chevron_left_rounded,
            color: AppColors.dark,
            size: 32,
          ),
        ),
      ),
    );
  }
}