import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Custom vector illustrations for the 3 YASSELIM Onboarding slides.
class OnboardingArtwork extends StatelessWidget {
  final int pageIndex;
  final double size;

  const OnboardingArtwork({super.key, this.pageIndex = 0, this.size = 200});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _OnboardingPainter(pageIndex: pageIndex)),
    );
  }
}

class _OnboardingPainter extends CustomPainter {
  final int pageIndex;
  const _OnboardingPainter({required this.pageIndex});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);

    // Ambient soft twilight halo
    canvas.drawCircle(
      center,
      w * 0.44,
      Paint()
        ..shader = RadialGradient(
          colors: [
            AppColors.lavender.withValues(alpha: 0.24),
            AppColors.premiumGold.withValues(alpha: 0.08),
            Colors.transparent,
          ],
        ).createShader(Rect.fromCircle(center: center, radius: w * 0.44)),
    );

    // Decorative botanical leaves on left and right
    final leafPaint = Paint()
      ..color = AppColors.lavender.withValues(alpha: 0.35)
      ..style = PaintingStyle.fill;
    final leftLeaf = Path()
      ..moveTo(w * 0.22, h * 0.70)
      ..quadraticBezierTo(w * 0.08, h * 0.56, w * 0.16, h * 0.42)
      ..quadraticBezierTo(w * 0.26, h * 0.54, w * 0.22, h * 0.70);
    final rightLeaf = Path()
      ..moveTo(w * 0.78, h * 0.70)
      ..quadraticBezierTo(w * 0.92, h * 0.56, w * 0.84, h * 0.42)
      ..quadraticBezierTo(w * 0.74, h * 0.54, w * 0.78, h * 0.70);
    canvas.drawPath(leftLeaf, leafPaint);
    canvas.drawPath(rightLeaf, leafPaint);

    // Open 3D perspective journal pages at base
    final bookBase = Path()
      ..moveTo(w * 0.50, h * 0.76)
      ..quadraticBezierTo(w * 0.32, h * 0.70, w * 0.16, h * 0.74)
      ..lineTo(w * 0.22, h * 0.56)
      ..quadraticBezierTo(w * 0.36, h * 0.54, w * 0.50, h * 0.60)
      ..quadraticBezierTo(w * 0.64, h * 0.54, w * 0.78, h * 0.56)
      ..lineTo(w * 0.84, h * 0.74)
      ..quadraticBezierTo(w * 0.68, h * 0.70, w * 0.50, h * 0.76)
      ..close();
    canvas.drawPath(
      bookBase,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.softLavender, Color(0xFF9F8EE0)],
        ).createShader(Offset.zero & size),
    );
    canvas.drawLine(
      Offset(w * 0.50, h * 0.60),
      Offset(w * 0.50, h * 0.76),
      Paint()
        ..color = AppColors.midnightPurple.withValues(alpha: 0.45)
        ..strokeWidth = 2,
    );

    if (pageIndex == 0) {
      // Glowing heart rising from the open journal ("Kendine ait bir alan")
      final heart = Path()
        ..moveTo(w * 0.50, h * 0.52)
        ..cubicTo(w * 0.30, h * 0.38, w * 0.32, h * 0.22, w * 0.44, h * 0.26)
        ..quadraticBezierTo(w * 0.50, h * 0.29, w * 0.50, h * 0.33)
        ..quadraticBezierTo(w * 0.50, h * 0.29, w * 0.56, h * 0.26)
        ..cubicTo(w * 0.68, h * 0.22, w * 0.70, h * 0.38, w * 0.50, h * 0.52)
        ..close();
      canvas.drawPath(
        heart,
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.premiumGold, AppColors.brightLavender],
          ).createShader(Offset.zero & size)
          ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 6),
      );
    } else if (pageIndex == 1) {
      // Quill feather writing over the journal
      final quill = Path()
        ..moveTo(w * 0.44, h * 0.56)
        ..quadraticBezierTo(w * 0.48, h * 0.30, w * 0.72, h * 0.18)
        ..quadraticBezierTo(w * 0.66, h * 0.44, w * 0.44, h * 0.56);
      canvas.drawPath(quill, Paint()..color = AppColors.premiumGold);
      canvas.drawCircle(
        Offset(w * 0.36, h * 0.32),
        4,
        Paint()..color = AppColors.softLavender,
      );
    } else {
      // Privacy shield emblem above journal
      final shield = Path()
        ..moveTo(w * 0.50, h * 0.20)
        ..lineTo(w * 0.66, h * 0.27)
        ..quadraticBezierTo(w * 0.66, h * 0.45, w * 0.50, h * 0.54)
        ..quadraticBezierTo(w * 0.34, h * 0.45, w * 0.34, h * 0.27)
        ..close();
      canvas.drawPath(shield, Paint()..color = AppColors.brightLavender);
      canvas.drawCircle(
        Offset(w * 0.50, h * 0.36),
        w * 0.04,
        Paint()..color = AppColors.deepNightNavy,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _OnboardingPainter oldDelegate) =>
      oldDelegate.pageIndex != pageIndex;
}
