import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/kora_brand.dart';
import '../../../../shared/widgets/kora_pattern_background.dart';
import '../../../../shared/widgets/kora_primary_button.dart';
import '../../../../shared/widgets/kora_text_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool _requestSubmitted = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
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

  void _sendRecoveryRequest() {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _requestSubmitted = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Solicitud validada. La recuperación se conectará al backend posteriormente.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KoraPatternBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 30),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 46,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          child: InkWell(
                            onTap: () => context.pop(),
                            borderRadius: BorderRadius.circular(14),
                            child: const SizedBox(
                              width: 44,
                              height: 44,
                              child: Icon(
                                Icons.chevron_left,
                                color: AppColors.dark,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 35),

                      const Center(
                        child: KoraBrand(height: 58),
                      ),

                      const SizedBox(height: 42),

                      Container(
                        width: 76,
                        height: 76,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.55),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Icon(
                          Icons.lock_reset_rounded,
                          color: AppColors.dark,
                          size: 38,
                        ),
                      ),

                      const SizedBox(height: 28),

                      Text(
                        _requestSubmitted
                            ? 'Revisa tu correo'
                            : '¿Olvidaste tu contraseña?',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),

                      const SizedBox(height: 12),

                      Text(
                        _requestSubmitted
                            ? 'Si el correo ingresado está registrado, recibirás las instrucciones para recuperar el acceso.'
                            : 'No te preocupes. Ingresa el correo asociado a tu cuenta y te ayudaremos a recuperar el acceso.',
                        style: const TextStyle(
                          color: AppColors.secondary,
                          height: 1.6,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 32),

                      if (!_requestSubmitted) ...[
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              KoraTextField(
                                label: 'Correo electrónico',
                                hint: 'nombre@ejemplo.com',
                                icon: Icons.mail_outline,
                                keyboardType: TextInputType.emailAddress,
                                controller: _emailController,
                                validator: _validateEmail,
                              ),

                              const SizedBox(height: 26),

                              KoraPrimaryButton(
                                label: 'Enviar instrucciones',
                                icon: Icons.arrow_forward_rounded,
                                onPressed: _sendRecoveryRequest,
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        KoraPrimaryButton(
                          label: 'Volver al inicio de sesión',
                          onPressed: () {
                            context.go(AppRoutes.login);
                          },
                        ),
                      ],

                      const SizedBox(height: 35),

                      Center(
                        child: TextButton(
                          onPressed: () {
                            context.go(AppRoutes.login);
                          },
                          child: const Text(
                            'Volver a iniciar sesión',
                            style: TextStyle(
                              color: AppColors.secondary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}