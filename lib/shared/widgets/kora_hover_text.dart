import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';

class KoraHoverText extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final double fontSize;
  final FontWeight fontWeight;

  const KoraHoverText({
    super.key,
    required this.text,
    required this.onTap,
    this.fontSize = 15,
    this.fontWeight = FontWeight.w900,
  });

  @override
  State<KoraHoverText> createState() => _KoraHoverTextState();
}

class _KoraHoverTextState extends State<KoraHoverText> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? 1.04 : 1.0,
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.text,
                style: GoogleFonts.manrope(
                  color: AppColors.primary,
                  fontSize: widget.fontSize,
                  fontWeight: widget.fontWeight,
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                height: 2,
                width: _isHovered ? widget.text.length * 8.0 : 0,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}