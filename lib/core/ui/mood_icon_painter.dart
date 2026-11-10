import 'package:flutter/material.dart';

import '../../domain/models/mood_type.dart';
import '../constants/app_colors.dart';

/// Custom expressive vector avatar for each of the 8 YASSELIM moods.
class MoodIconAvatar extends StatelessWidget {
  final MoodType mood;
  final bool isSelected;
  final double size;
  final VoidCallback? onTap;

  const MoodIconAvatar({
    super.key,
    required this.mood,
    this.isSelected = false,
    this.size = 44,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = mood.color;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected
              ? baseColor.withValues(alpha: 0.28)
              : (isDark
                    ? AppColors.darkSurfaceElevated
                    : AppColors.lightSurfaceElevated),
          border: Border.all(
            color: isSelected ? baseColor : baseColor.withValues(alpha: 0.35),
            width: isSelected ? 2.0 : 1.2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: baseColor.withValues(alpha: 0.38),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: CustomPaint(
          painter: _MoodFacePainter(
            mood: mood,
            color: isSelected ? baseColor : baseColor.withValues(alpha: 0.88),
          ),
        ),
      ),
    );
  }
}

class _MoodFacePainter extends CustomPainter {
  final MoodType mood;
  final Color color;

  const _MoodFacePainter({required this.mood, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.055
      ..strokeCap = StrokeCap.round;
    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Eyes
    if (mood == MoodType.calm || mood == MoodType.grateful) {
      final leftEye = Path()
        ..moveTo(w * 0.30, h * 0.42)
        ..quadraticBezierTo(w * 0.35, h * 0.36, w * 0.40, h * 0.42);
      final rightEye = Path()
        ..moveTo(w * 0.60, h * 0.42)
        ..quadraticBezierTo(w * 0.65, h * 0.36, w * 0.70, h * 0.42);
      canvas.drawPath(leftEye, stroke);
      canvas.drawPath(rightEye, stroke);
    } else {
      canvas.drawCircle(Offset(w * 0.35, h * 0.40), w * 0.045, fill);
      canvas.drawCircle(Offset(w * 0.65, h * 0.40), w * 0.045, fill);
    }

    // Angry eyebrows or Hopeful sparkle
    if (mood == MoodType.angry) {
      canvas.drawLine(
        Offset(w * 0.28, h * 0.30),
        Offset(w * 0.42, h * 0.35),
        stroke,
      );
      canvas.drawLine(
        Offset(w * 0.72, h * 0.30),
        Offset(w * 0.58, h * 0.35),
        stroke,
      );
    } else if (mood == MoodType.hopeful) {
      canvas.drawCircle(Offset(w * 0.75, h * 0.26), w * 0.03, fill);
    }

    // Mouth expression
    final mouth = Path();
    switch (mood) {
      case MoodType.happy:
      case MoodType.hopeful:
      case MoodType.grateful:
        mouth
          ..moveTo(w * 0.34, h * 0.58)
          ..quadraticBezierTo(w * 0.50, h * 0.72, w * 0.66, h * 0.58);
      case MoodType.calm:
        mouth
          ..moveTo(w * 0.38, h * 0.60)
          ..quadraticBezierTo(w * 0.50, h * 0.67, w * 0.62, h * 0.60);
      case MoodType.sad:
      case MoodType.angry:
        mouth
          ..moveTo(w * 0.35, h * 0.66)
          ..quadraticBezierTo(w * 0.50, h * 0.54, w * 0.65, h * 0.66);
      case MoodType.anxious:
        mouth
          ..moveTo(w * 0.34, h * 0.62)
          ..quadraticBezierTo(w * 0.42, h * 0.56, w * 0.50, h * 0.62)
          ..quadraticBezierTo(w * 0.58, h * 0.68, w * 0.66, h * 0.62);
      case MoodType.neutral:
        mouth
          ..moveTo(w * 0.36, h * 0.62)
          ..lineTo(w * 0.64, h * 0.62);
    }
    canvas.drawPath(mouth, stroke);
  }

  @override
  bool shouldRepaint(covariant _MoodFacePainter oldDelegate) =>
      oldDelegate.mood != mood || oldDelegate.color != color;
}
