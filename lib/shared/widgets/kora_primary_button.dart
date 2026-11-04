import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';

class KoraPrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool enabled;
  final double height;

  const KoraPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.enabled = true,
    this.height = 56,
  });

  @override
  State<KoraPrimaryButton> createState() => _KoraPrimaryButtonState();
}

class _KoraPrimaryButtonState extends State<KoraPrimaryButton> {
  bool _isHovered = false;

  bool get _isEnabled =>
      widget.enabled && !widget.isLoading && widget.onPressed != null;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: _isEnabled
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) {
        if (_isEnabled) {
          setState(() => _isHovered = true);
        }
      },
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.025 : 1.0,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: _isHovered
                ? [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.28),
                blurRadius: 22,
                spreadRadius: 1,
              ),
            ]
                : [],
          ),
          child: SizedBox(
            width: double.infinity,
            height: widget.height,
            child: ElevatedButton(
              onPressed: _isEnabled ? widget.onPressed : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.dark,
                disabledBackgroundColor:
                AppColors.primary.withValues(alpha: 0.5),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: widget.isLoading
                        ? const SizedBox(
                      width: 23,
                      height: 23,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: AppColors.dark,
                      ),
                    )
                        : Text(
                      widget.label,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.manrope(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  if (widget.icon != null && !widget.isLoading)
                    Positioned(
                      right: 0,
                      child: AnimatedSlide(
                        offset: _isHovered
                            ? const Offset(0.12, 0)
                            : Offset.zero,
                        duration: const Duration(milliseconds: 180),
                        child: Container(
                          width: widget.height - 8,
                          height: widget.height - 8,
                          decoration: const BoxDecoration(
                            color: AppColors.dark,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            widget.icon,
                            color: Colors.white,
                            size: 25,
                          ),
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
}