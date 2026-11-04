
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';

class OnboardingOptionCard extends StatelessWidget {
  const OnboardingOptionCard({
    super.key,
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onTap,
    this.imageAsset,
    this.icon = Icons.fitness_center_rounded,
    this.compact = false,
  });

  final String title;
  final String description;
  final String? imageAsset;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final imageSize = compact ? 48.0 : 64.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.dark : Colors.white,
        borderRadius: BorderRadius.circular(38),
        border: Border.all(
          color: isSelected
              ? AppColors.primary
              : const Color(0xFFF0F0EC),
          width: isSelected ? 1.7 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isSelected ? 0.09 : 0.025,
            ),
            blurRadius: isSelected ? 18 : 5,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(38),
          onTap: onTap,
          child: SizedBox(
            height: compact ? 82 : 112,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 12,
              ),
              child: Row(
                children: [
                  ClipOval(
                    child: imageAsset != null
                        ? Image.asset(
                      imageAsset!,
                      width: imageSize,
                      height: imageSize,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                      errorBuilder: (_, __, ___) {
                        return _iconFallback(imageSize);
                      },
                    )
                        : _iconFallback(imageSize),
                  ),
                  const SizedBox(width: 17),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.manrope(
                            color: isSelected
                                ? Colors.white
                                : AppColors.dark,
                            fontSize: compact ? 14 : 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.manrope(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.secondary,
                            fontSize: compact ? 11 : 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 33,
                    height: 33,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : const Color(0xFFF1F0E9),
                        width: isSelected ? 8 : 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _iconFallback(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: AppColors.secondary,
        size: size * 0.45,
      ),
    );
  }
}