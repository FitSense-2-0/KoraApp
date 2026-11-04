
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';

class OnboardingNavigation extends StatelessWidget {
  const OnboardingNavigation({
    super.key,
    required this.onContinue,
    required this.isLastStep,
  });

  final VoidCallback onContinue;
  final bool isLastStep;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 80,
      child: FilledButton(
        onPressed: onContinue,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.dark,
          foregroundColor: AppColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isLastStep ? 'Generar mi plan' : 'Continuar',
              style: GoogleFonts.manrope(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: 0,
                color: AppColors.white,
              ),
            ),
            const SizedBox(width: 14),
            Icon(
              isLastStep
                  ? Icons.check_circle_outline_rounded
                  : Icons.chevron_right_rounded,
              size: 27,
              color: isLastStep
                  ? AppColors.primary
                  : AppColors.white,
            ),
          ],
        ),
      ),
    );
  }
}