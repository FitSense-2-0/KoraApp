
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/kora_primary_button.dart';
import '../../../../shared/widgets/kora_text_field.dart';
import '../../../../shared/widgets/kora_animated_link.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ===========================================
  // VALIDACIONES.
  // ===========================================

  String? _validateName(String? value) {
    if (value == null || value.trim().length < 3) {
      return 'Ingresa tu nombre completo';
    }

    return null;
  }

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
    if (value == null || value.length < 8) {
      return 'Usa al menos 8 caracteres';
    }

    return null;
  }

  // ===========================================
  // REGISTRO.
  // ===========================================

  void _register() {
    if (!_formKey.currentState!.validate()) return;

    // Validación local.
    // La integración con backend se realizará posteriormente.
    context.push(AppRoutes.onboarding);
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

                    _buildBrandHeader(
                      width: width,
                      headerHeight: headerHeight,
                    ),

                    // =====================================
                    // 2. CONTENIDO DEL FORMULARIO.
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
                          Align(
                            alignment: Alignment.centerLeft,
                            child: _BackButton(
                              onTap: () => context.pop(),
                            ),
                          ),

                          const SizedBox(height: 42),

                          // =================================
                          // 3. TÍTULO Y DESCRIPCIÓN.
                          // =================================

                          Text(
                            'Crear cuenta',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.manrope(
                              color: AppColors.dark,
                              fontSize: 39,
                              height: 1.15,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -1.5,
                            ),
                          ),

                          const SizedBox(height: 16),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                            ),
                            child: Text(
                              'Empieza hoy tu camino personalizado '
                                  'hacia un mejor bienestar.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.manrope(
                                color: AppColors.secondary,
                                fontSize: 18,
                                height: 1.65,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          const SizedBox(height: 46),

                          // =================================
                          // 4. FORMULARIO DE REGISTRO.
                          // =================================

                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.stretch,
                              children: [
                                KoraTextField(
                                  label: 'Nombre completo',
                                  hint: 'Ej. Juan Pérez',
                                  icon: Icons.person_outline,
                                  controller: _nameController,
                                  validator: _validateName,
                                ),

                                const SizedBox(height: 26),

                                KoraTextField(
                                  label: 'Correo electrónico',
                                  hint: 'email@ejemplo.com',
                                  icon: Icons.mail_outline,
                                  keyboardType:
                                  TextInputType.emailAddress,
                                  controller: _emailController,
                                  validator: _validateEmail,
                                ),

                                const SizedBox(height: 26),

                                KoraTextField(
                                  label: 'Contraseña',
                                  hint: 'Mínimo 8 caracteres',
                                  icon: Icons.lock_outline,
                                  isPassword: true,
                                  controller: _passwordController,
                                  validator: _validatePassword,
                                ),

                                const SizedBox(height: 34),

                                // BOTÓN CREAR CUENTA.
                                KoraPrimaryButton(
                                  label: 'Crear cuenta',
                                  onPressed: _register,
                                  icon: Icons.arrow_forward_rounded,
                                  height: 66,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 38),

                          // =================================
                          // 5. ACCESO A CUENTA EXISTENTE.
                          // =================================

                          Text(
                            '¿Ya tienes una cuenta?',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.manrope(
                              color: AppColors.secondary,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Center(
                            child: KoraAnimatedLink(
                              label: 'Iniciar sesión',
                              fontSize: 17,
                              color: AppColors.dark,
                              onTap: () {
                                context.go(AppRoutes.login);
                              },
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
  // 6. ENCABEZADO KORA.
  // MISMO DISEÑO QUE WELCOMEPAGE.
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
}

// ===========================================
// 7. BOTÓN REGRESAR.
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