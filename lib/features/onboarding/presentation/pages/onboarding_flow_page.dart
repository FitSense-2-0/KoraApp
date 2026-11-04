import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/onboarding_data.dart';
import '../widgets/onboarding_navigation.dart';
import '../widgets/onboarding_option_card.dart';
import '../widgets/onboarding_step_header.dart';

class OnboardingFlowPage extends StatefulWidget {
  const OnboardingFlowPage({super.key});

  @override
  State<OnboardingFlowPage> createState() =>
      _OnboardingFlowPageState();
}

class _OnboardingFlowPageState extends State<OnboardingFlowPage> {
  static const int _totalSteps = 6;

  int _currentStep = 0;

  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _otherEquipmentController = TextEditingController();

  String? _fitnessGoal;
  String? _fitnessLevel;
  String? _biologicalSex;
  String? _preferredTime;
  String? _equipment;

  final List<String> _customEquipmentItems = [];
  final List<String> _availableDays = [];
  final List<String> _restrictions = [];

  static const _days = [
    ('Lunes', 'L'),
    ('Martes', 'M'),
    ('Miércoles', 'M'),
    ('Jueves', 'J'),
    ('Viernes', 'V'),
    ('Sábado', 'S'),
    ('Domingo', 'D'),
  ];

  static const List<String> _customEquipmentOptions = [
    'Mancuernas',
    'Bandas elásticas',
    'Pesas rusas',
    'Barra y discos',
    'Banco de pesas',
    'Barra de dominadas',
    'Cuerda para saltar',
    'Colchoneta',
    'TRX',
    'Balón medicinal',
    'Rodillo de espuma',
    'Otros',
  ];

  static const _stepTitles = [
    '¿Cuál es tu objetivo?',
    '¿Cuál es tu nivel?',
    'Perfil físico',
    'Disponibilidad',
    '¿Qué equipo tienes?',
    '¿Alguna restricción?',
  ];

  static const _stepDescriptions = [
    'Selecciona la meta principal que quieres alcanzar para que la IA diseñe tu ruta.',
    'Esto nos permite calibrar la intensidad y complejidad de tus rutinas.',
    'Dinos un poco más sobre ti para calcular tus requerimientos calóricos exactos.',
    'Dinos qué días y en qué horario prefieres entrenar para armar tu calendario.',
    'La IA filtrará los ejercicios según las herramientas que tengas a mano.',
    'Tu seguridad es lo primero. Dinos si debemos evitar ciertos movimientos o intensidades.',
  ];

  @override
  void dispose() {
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _otherEquipmentController.dispose();
    super.dispose();
  }

  // NAVEGACIÓN

  void _goBack() {
    if (_currentStep == 0) {
      context.pop();
      return;
    }

    setState(() {
      _currentStep--;
    });
  }

  void _continue() {
    final error = _validateStep();

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      _finishOnboarding();
    }
  }

  // VALIDACIONES

  String? _validateStep() {
    switch (_currentStep) {
      case 0:
        if (_fitnessGoal == null) {
          return 'Selecciona tu objetivo.';
        }
        break;

      case 1:
        if (_fitnessLevel == null) {
          return 'Selecciona tu nivel.';
        }
        break;

      case 2:
        final age = int.tryParse(_ageController.text);

        final weight = double.tryParse(
          _weightController.text.replaceAll(',', '.'),
        );

        final height = double.tryParse(
          _heightController.text.replaceAll(',', '.'),
        );

        if (_biologicalSex == null) {
          return 'Selecciona una opción de género.';
        }

        if (age == null || age < 18 || age > 100) {
          return 'Ingresa una edad válida (18 a 100 años).';
        }

        if (weight == null || weight < 30 || weight > 300) {
          return 'Ingresa un peso válido.';
        }

        if (height == null || height < 100 || height > 250) {
          return 'Ingresa una altura válida.';
        }
        break;

      case 3:
        if (_availableDays.isEmpty) {
          return 'Selecciona al menos un día disponible.';
        }

        if (_preferredTime == null) {
          return 'Selecciona un horario preferido.';
        }
        break;

      case 4:
        if (_equipment == null) {
          return 'Selecciona el equipo que tienes disponible.';
        }

        if (_equipment == 'Mi equipo') {
          if (_customEquipmentItems.isEmpty) {
            return 'Selecciona al menos un accesorio.';
          }

          if (_customEquipmentItems.contains('Otros') &&
              _otherEquipmentController.text.trim().isEmpty) {
            return 'Especifica qué otro equipo tienes.';
          }
        }
        break;

      case 5:
        break;
    }

    return null;
  }

  // FINALIZAR ONBOARDING

  void _finishOnboarding() {
    final data = OnboardingData(
      fitnessGoal: _fitnessGoal,
      fitnessLevel: _fitnessLevel,
      age: int.parse(_ageController.text),
      weight: double.parse(
        _weightController.text.replaceAll(',', '.'),
      ),
      height: double.parse(
        _heightController.text.replaceAll(',', '.'),
      ),
      biologicalSex: _biologicalSex,
      availableDays: List.unmodifiable(_availableDays),
      preferredTime: _preferredTime,
      equipment: _equipment,
      restrictions: List.unmodifiable(_restrictions),
      equipmentItems: List.unmodifiable(_customEquipmentItems),
      otherEquipment: _customEquipmentItems.contains('Otros')
          ? _otherEquipmentController.text.trim()
          : null,
    );

    debugPrint('OBJETIVO: ${data.fitnessGoal}');
    debugPrint('NIVEL: ${data.fitnessLevel}');
    debugPrint('GÉNERO: ${data.biologicalSex}');
    debugPrint('EDAD: ${data.age}');
    debugPrint('PESO: ${data.weight}');
    debugPrint('ALTURA: ${data.height}');
    debugPrint('DÍAS: ${data.availableDays}');
    debugPrint('HORARIO: ${data.preferredTime}');
    debugPrint('EQUIPO: ${data.equipment}');
    debugPrint('ACCESORIOS: ${data.equipmentItems}');
    debugPrint('OTRO EQUIPO: ${data.otherEquipment}');
    debugPrint('RESTRICCIONES: ${data.restrictions}');

    if (!mounted) return;

    context.go(
      AppRoutes.planGeneration,
      extra: data,
    );
  }

  // SELECCIONES

  void _toggleDay(String day) {
    setState(() {
      if (_availableDays.contains(day)) {
        _availableDays.remove(day);
      } else {
        _availableDays.add(day);
      }
    });
  }

  void _toggleRestriction(String value) {
    setState(() {
      if (value == 'Ninguna') {
        _restrictions
          ..clear()
          ..add('Ninguna');
      } else {
        _restrictions.remove('Ninguna');

        if (_restrictions.contains(value)) {
          _restrictions.remove(value);
        } else {
          _restrictions.add(value);
        }
      }
    });
  }

  void _toggleCustomEquipment(String equipment) {
    setState(() {
      if (_customEquipmentItems.contains(equipment)) {
        _customEquipmentItems.remove(equipment);

        if (equipment == 'Otros') {
          _otherEquipmentController.clear();
        }
      } else {
        _customEquipmentItems.add(equipment);
      }
    });
  }

  // COMPONENTE DE OPCIÓN

  Widget _option({
    required String title,
    required String subtitle,
    required bool selected,
    required VoidCallback onTap,
    IconData icon = Icons.fitness_center_rounded,
    String? imageAsset,
    bool compact = false,
  }) {
    return OnboardingOptionCard(
      title: title,
      description: subtitle,
      imageAsset: imageAsset,
      icon: icon,
      isSelected: selected,
      onTap: onTap,
      compact: compact,
    );
  }

  // PASO 1: OBJETIVO

  Widget _buildObjective() {
    return Column(
      children: [
        _option(
          title: 'Bajar de peso',
          subtitle: 'Cardio & resistencia muscular',
          imageAsset: 'assets/images/onboarding/objective_fat_loss.png',
          selected: _fitnessGoal == 'Bajar de peso',
          onTap: () {
            setState(() {
              _fitnessGoal = 'Bajar de peso';
            });
          },
        ),

        _option(
          title: 'Ganar músculo',
          subtitle: 'Hipertrofia',
          imageAsset: 'assets/images/onboarding/objective_muscle.png',
          selected: _fitnessGoal == 'Ganar músculo',
          onTap: () {
            setState(() {
              _fitnessGoal = 'Ganar músculo';
            });
          },
        ),

        _option(
          title: 'Ponerse fuerte',
          subtitle: 'Fuerza',
          imageAsset: 'assets/images/onboarding/objective_strength.png',
          selected: _fitnessGoal == 'Ponerse fuerte',
          onTap: () {
            setState(() {
              _fitnessGoal = 'Ponerse fuerte';
            });
          },
        ),

        _option(
          title: 'Resistencia',
          subtitle: 'Cardio & resistencia muscular',
          imageAsset: 'assets/images/onboarding/objective_condition.png',
          selected: _fitnessGoal == 'Resistencia',
          onTap: () {
            setState(() {
              _fitnessGoal = 'Resistencia';
            });
          },
        ),

        _option(
          title: 'Estado físico general',
          subtitle: 'Fuerza, cardio, resistencia & movilidad',
          imageAsset: 'assets/images/onboarding/objective_active.png',
          selected: _fitnessGoal == 'Estado físico general',
          onTap: () {
            setState(() {
              _fitnessGoal = 'Estado físico general';
            });
          },
        ),
      ],
    );
  }

  // PASO 2: NIVEL

  Widget _buildLevel() {
    return Column(
      children: [
        _option(
          title: 'Principiante',
          subtitle: 'Fase inicial',
          imageAsset: 'assets/images/onboarding/level_beginner.png',
          selected: _fitnessLevel == 'Principiante',
          onTap: () {
            setState(() {
              _fitnessLevel = 'Principiante';
            });
          },
        ),

        _option(
          title: 'Intermedio',
          subtitle: 'Consolidación',
          imageAsset: 'assets/images/onboarding/level_intermediate.png',
          selected: _fitnessLevel == 'Intermedio',
          onTap: () {
            setState(() {
              _fitnessLevel = 'Intermedio';
            });
          },
        ),

        _option(
          title: 'Avanzado',
          subtitle: 'Alto rendimiento',
          imageAsset: 'assets/images/onboarding/level_advanced.png',
          selected: _fitnessLevel == 'Avanzado',
          onTap: () {
            setState(() {
              _fitnessLevel = 'Avanzado';
            });
          },
        ),
      ],
    );
  }

  // PASO 3: PERFIL FÍSICO

  Widget _buildPhysicalProfile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel('Género'),

        Row(
          children: [
            Expanded(
              child: _genderButton('Masculino'),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _genderButton('Femenino'),
            ),
          ],
        ),

        const SizedBox(height: 30),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _fieldLabel('Edad (años)'),
                  _numberField(
                    _ageController,
                    hint: 'Edad',
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _fieldLabel('Peso (kg)'),
                  _numberField(
                    _weightController,
                    hint: 'Kg',
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _fieldLabel('Altura (cm)'),
                  _numberField(
                    _heightController,
                    hint: 'Cm',
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _fieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 7,
        bottom: 12,
      ),
      child: Text(
        label,
        style: GoogleFonts.manrope(
          color: AppColors.secondary,
          fontSize: 13,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _genderButton(String label) {
    final selected = _biologicalSex == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          _biologicalSex = label;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        height: 78,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.dark : AppColors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : const Color(0xFFF0F0EC),
            width: selected ? 2 : 1,
          ),
          boxShadow: selected
              ? [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.09),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ]
              : [],
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.manrope(
            color: selected
                ? AppColors.white
                : AppColors.secondary,
            fontSize: 15,
            fontWeight: FontWeight.w800,
            letterSpacing: 0,
          ),
        ),
      ),
    );
  }

  Widget _numberField(
      TextEditingController controller, {
        required String hint,
      }) {
    return Container(
      width: double.infinity,
      height: 66,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFF0F0EC),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        keyboardType: const TextInputType.numberWithOptions(
          decimal: true,
        ),
        cursorColor: AppColors.secondary,
        cursorWidth: 1.5,
        style: GoogleFonts.manrope(
          color: AppColors.dark,
          fontSize: 19,
          fontWeight: FontWeight.w800,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.manrope(
            color: const Color(0xFFB9C9B8),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          filled: false,
          isDense: true,
          contentPadding: EdgeInsets.zero,
          counterText: '',
        ),
      ),
    );
  }

  // PASO 4: DISPONIBILIDAD

  Widget _buildAvailability() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel('Días disponibles'),

        Row(
          children: _days.map((day) {
            final selected = _availableDays.contains(day.$1);

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 5),
                child: GestureDetector(
                  onTap: () => _toggleDay(day.$1),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    height: 91,
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.dark
                          : AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: selected
                            ? AppColors.primary
                            : AppColors.border,
                        width: selected ? 1.5 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          day.$1.substring(0, 3).toUpperCase(),
                          style: GoogleFonts.manrope(
                            color: selected
                                ? AppColors.primary
                                : AppColors.secondary,
                            fontSize: 8,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          day.$2,
                          style: GoogleFonts.manrope(
                            color: selected
                                ? AppColors.white
                                : AppColors.secondary,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 30),

        _fieldLabel('Horario preferido'),

        _option(
          title: 'Mañana',
          subtitle: '06:00 - 12:00',
          imageAsset:
          'assets/images/onboarding/availability_morning.png',
          selected: _preferredTime == 'Mañana',
          onTap: () {
            setState(() {
              _preferredTime = 'Mañana';
            });
          },
        ),

        _option(
          title: 'Tarde',
          subtitle: '12:00 - 18:00',
          imageAsset:
          'assets/images/onboarding/availability_afternoon.png',
          selected: _preferredTime == 'Tarde',
          onTap: () {
            setState(() {
              _preferredTime = 'Tarde';
            });
          },
        ),

        _option(
          title: 'Noche',
          subtitle: '18:00 - 23:00',
          imageAsset:
          'assets/images/onboarding/availability_night.png',
          selected: _preferredTime == 'Noche',
          onTap: () {
            setState(() {
              _preferredTime = 'Noche';
            });
          },
        ),
      ],
    );
  }

  // PASO 5: EQUIPAMIENTO

  Widget _buildEquipment() {
    return Column(
      children: [
        _option(
          title: 'Gimnasio completo',
          subtitle: 'Acceso a máquinas y pesas',
          imageAsset: 'assets/images/onboarding/equipment_gym.png',
          selected: _equipment == 'Gimnasio completo',
          onTap: () {
            setState(() {
              _equipment = 'Gimnasio completo';
              _customEquipmentItems.clear();
              _otherEquipmentController.clear();
            });
          },
        ),

        _option(
          title: 'Equipo básico',
          subtitle: 'Mancuernas, bandas y pesas rusas',
          imageAsset: 'assets/images/onboarding/equipment_basic.png',
          selected: _equipment == 'Equipo básico',
          onTap: () {
            setState(() {
              _equipment = 'Equipo básico';
              _customEquipmentItems.clear();
              _otherEquipmentController.clear();
            });
          },
        ),

        _option(
          title: 'Sin equipo',
          subtitle: 'Entrenamiento con peso corporal',
          imageAsset: 'assets/images/onboarding/equipment_bodyweight.png',
          selected: _equipment == 'Sin equipo',
          onTap: () {
            setState(() {
              _equipment = 'Sin equipo';
              _customEquipmentItems.clear();
              _otherEquipmentController.clear();
            });
          },
        ),

        _option(
          title: 'Mi equipo',
          subtitle: 'Seleccionar accesorios disponibles',
          imageAsset: 'assets/images/onboarding/equipment_custom.png',
          selected: _equipment == 'Mi equipo',
          onTap: () {
            setState(() {
              _equipment = 'Mi equipo';
            });
          },
        ),

        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: _equipment == 'Mi equipo'
              ? _buildCustomEquipmentSelector()
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildCustomEquipmentSelector() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(
        top: 8,
        bottom: 12,
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFECEFE5),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: const Color(0xFFE0E5D7),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '¿Qué accesorios tienes?',
            style: GoogleFonts.manrope(
              color: AppColors.dark,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            'Selecciona todos los materiales que tienes disponibles.',
            style: GoogleFonts.manrope(
              color: AppColors.secondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 18),

          Wrap(
            spacing: 9,
            runSpacing: 10,
            children: _customEquipmentOptions.map((item) {
              final selected = _customEquipmentItems.contains(item);

              return GestureDetector(
                onTap: () => _toggleCustomEquipment(item),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13,
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.dark
                        : AppColors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: selected
                          ? AppColors.primary
                          : const Color(0xFFE5E8DF),
                      width: selected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        selected
                            ? Icons.check_circle_rounded
                            : Icons.circle_outlined,
                        color: selected
                            ? AppColors.primary
                            : AppColors.secondary,
                        size: 16,
                      ),

                      const SizedBox(width: 7),

                      Text(
                        item,
                        style: GoogleFonts.manrope(
                          color: selected
                              ? AppColors.white
                              : AppColors.secondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

          if (_customEquipmentItems.contains('Otros')) ...[
            const SizedBox(height: 20),

            Text(
              '¿Qué otro equipo tienes?',
              style: GoogleFonts.manrope(
                color: AppColors.dark,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: _otherEquipmentController,
              textCapitalization: TextCapitalization.sentences,
              style: GoogleFonts.manrope(
                color: AppColors.dark,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: 'Ej. Máquina de poleas, TRX...',
                hintStyle: GoogleFonts.manrope(
                  color: const Color(0xFF9EAD9C),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                filled: true,
                fillColor: AppColors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: AppColors.secondary,
                    width: 1.3,
                  ),
                ),
              ),
            ),
          ],

          const SizedBox(height: 16),

          Row(
            children: [
              const Icon(
                Icons.inventory_2_outlined,
                color: AppColors.secondary,
                size: 17,
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  '${_customEquipmentItems.length} accesorios seleccionados',
                  style: GoogleFonts.manrope(
                    color: AppColors.secondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // PASO 6: RESTRICCIONES

  Widget _buildRestrictions() {
    const restrictions = [
      'Lesión de rodilla',
      'Dolor de espalda',
      'Lesión de hombro',
      'Problemas cardíacos',
      'Embarazo',
      'Asma',
      'Ninguna',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: restrictions.map((item) {
            final selected = _restrictions.contains(item);

            return GestureDetector(
              onTap: () => _toggleRestriction(item),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 17,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.dark
                      : AppColors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: selected
                        ? AppColors.primary
                        : const Color(0xFFF0F0EC),
                    width: selected ? 1.5 : 1,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x08000000),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  item,
                  style: GoogleFonts.manrope(
                    color: selected
                        ? AppColors.primary
                        : AppColors.secondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 38),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: const Color(0xFFECEBE1),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: const Color(0xFFE0DED2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nota médica',
                style: GoogleFonts.manrope(
                  color: const Color(0xFF9EB49D),
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: .5,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                'Nuestra IA filtrará los ejercicios basándose en estas condiciones para garantizar un entrenamiento seguro y eficiente.',
                style: GoogleFonts.manrope(
                  color: AppColors.dark,
                  fontSize: 15,
                  height: 1.6,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // CONTENIDO SEGÚN EL PASO ACTUAL

  Widget _buildContent() {
    switch (_currentStep) {
      case 0:
        return _buildObjective();

      case 1:
        return _buildLevel();

      case 2:
        return _buildPhysicalProfile();

      case 3:
        return _buildAvailability();

      case 4:
        return _buildEquipment();

      case 5:
        return _buildRestrictions();

      default:
        return const SizedBox.shrink();
    }
  }

  // INTERFAZ PRINCIPAL

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // BOTÓN REGRESAR

            Padding(
              padding: const EdgeInsets.fromLTRB(
                24,
                18,
                24,
                0,
              ),
              child: Row(
                children: [
                  Material(
                    color: AppColors.white,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: _goBack,
                      child: const SizedBox(
                        width: 48,
                        height: 48,
                        child: Icon(
                          Icons.chevron_left_rounded,
                          color: AppColors.dark,
                          size: 27,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // CONTENIDO DESLIZABLE

            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(
                  28,
                  0,
                  28,
                  26,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OnboardingStepHeader(
                      step: _currentStep + 1,
                      totalSteps: _totalSteps,
                      title: _stepTitles[_currentStep],
                      description: _stepDescriptions[_currentStep],
                    ),

                    const SizedBox(height: 38),

                    _buildContent(),
                  ],
                ),
              ),
            ),

            // BOTÓN CONTINUAR

            Padding(
              padding: const EdgeInsets.fromLTRB(
                28,
                8,
                28,
                24,
              ),
              child: OnboardingNavigation(
                onContinue: _continue,
                isLastStep: _currentStep == _totalSteps - 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}