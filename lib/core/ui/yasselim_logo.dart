import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Original procedural vector logo for YASSELIM: Crescent Moon, Quill Feather, and Horizon Wave.
class YasselimLogo extends StatelessWidget {
  final double size;
  final bool showCard;

  const YasselimLogo({super.key, this.size = 84, this.showCard = true});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _YasselimLogoPainter(showCard: showCard)),
    );
  }
}

class _YasselimLogoPainter extends CustomPainter {
  final bool showCard;
  const _YasselimLogoPainter({required this.showCard});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final rect = Offset.zero & size;

    if (showCard) {
      final rrect = RRect.fromRectAndRadius(rect, Radius.circular(w * 0.26));
      final bgPaint = Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF332D5E), Color(0xFF1A1836)],
        ).createShader(rect);
      canvas.drawRRect(rrect, bgPaint);

      final borderPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4
        ..color = AppColors.softLavender.withValues(alpha: 0.35);
      canvas.drawRRect(rrect, borderPaint);
    }

    // Subtle twilight star dots
    final starPaint = Paint()
      ..color = AppColors.warmWhite.withValues(alpha: 0.75);
    canvas.drawCircle(Offset(w * 0.24, h * 0.24), w * 0.016, starPaint);
    canvas.drawCircle(Offset(w * 0.76, h * 0.22), w * 0.013, starPaint);
    canvas.drawCircle(Offset(w * 0.68, h * 0.38), w * 0.011, starPaint);

    // Golden Crescent Moon
    final moonCenter = Offset(w * 0.44, h * 0.46);
    final moonR = w * 0.23;
    final moonPath = Path.combine(
      PathOperation.difference,
      Path()..addOval(Rect.fromCircle(center: moonCenter, radius: moonR)),
      Path()..addOval(
        Rect.fromCircle(
          center: Offset(w * 0.52, h * 0.40),
          radius: moonR * 0.88,
        ),
      ),
    );
    canvas.drawPath(
      moonPath,
      Paint()
        ..color = AppColors.premiumGold
        ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 4),
    );

    // Lavender Feather Quill
    final featherPath = Path()
      ..moveTo(w * 0.34, h * 0.72)
      ..quadraticBezierTo(w * 0.42, h * 0.42, w * 0.72, h * 0.22)
      ..quadraticBezierTo(w * 0.65, h * 0.54, w * 0.40, h * 0.66)
      ..close();
    canvas.drawPath(
      featherPath,
      Paint()
        ..shader = const LinearGradient(
          colors: [AppColors.softLavender, AppColors.vibrantViolet],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ).createShader(rect),
    );

    final spinePaint = Paint()
      ..color = AppColors.warmWhite
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.022
      ..strokeCap = StrokeCap.round;
    final spine = Path()
      ..moveTo(w * 0.30, h * 0.76)
      ..quadraticBezierTo(w * 0.48, h * 0.52, w * 0.70, h * 0.24);
    canvas.drawPath(spine, spinePaint);

    // Horizon Wave at bottom
    final wavePaint = Paint()
      ..color = AppColors.brightLavender.withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.024
      ..strokeCap = StrokeCap.round;
    final wave = Path()
      ..moveTo(w * 0.20, h * 0.79)
      ..quadraticBezierTo(w * 0.38, h * 0.73, w * 0.52, h * 0.79)
      ..quadraticBezierTo(w * 0.66, h * 0.85, w * 0.80, h * 0.78);
    canvas.drawPath(wave, wavePaint);
  }

  @override
  bool shouldRepaint(covariant _YasselimLogoPainter oldDelegate) =>
      oldDelegate.showCard != showCard;
}

/// Twilight mountain, lake reflection, and pine silhouette artwork for the Splash screen.
class SplashMountainArtwork extends StatelessWidget {
  final double height;
  const SplashMountainArtwork({super.key, this.height = 200});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: CustomPaint(painter: _SplashMountainPainter()),
    );
  }
}

class _SplashMountainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Warm twilight horizon glow
    final glowRect = Rect.fromLTWH(0, h * 0.05, w, h * 0.65);
    canvas.drawRect(
      glowRect,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(0, 0.25),
          radius: 0.75,
          colors: [
            AppColors.premiumGold.withValues(alpha: 0.32),
            AppColors.lavender.withValues(alpha: 0.18),
            Colors.transparent,
          ],
        ).createShader(glowRect),
    );

    // Distant mountain range
    final backMtn = Path()
      ..moveTo(0, h * 0.68)
      ..lineTo(w * 0.22, h * 0.34)
      ..lineTo(w * 0.42, h * 0.52)
      ..lineTo(w * 0.68, h * 0.26)
      ..lineTo(w * 0.88, h * 0.48)
      ..lineTo(w, h * 0.38)
      ..lineTo(w, h * 0.72)
      ..lineTo(0, h * 0.72)
      ..close();
    canvas.drawPath(backMtn, Paint()..color = const Color(0xFF28234B));

    // Foreground mountain range
    final frontMtn = Path()
      ..moveTo(0, h * 0.72)
      ..lineTo(w * 0.15, h * 0.48)
      ..lineTo(w * 0.36, h * 0.62)
      ..lineTo(w * 0.54, h * 0.42)
      ..lineTo(w * 0.78, h * 0.60)
      ..lineTo(w, h * 0.46)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(frontMtn, Paint()..color = const Color(0xFF191734));

    // Lake reflection lines
    final linePaint = Paint()
      ..color = AppColors.premiumGold.withValues(alpha: 0.28)
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < 4; i++) {
      final y = h * (0.76 + i * 0.05);
      final span = w * (0.26 - i * 0.04);
      canvas.drawLine(
        Offset(w * 0.5 - span, y),
        Offset(w * 0.5 + span, y),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Golden royal crown badge for YASSELIM Premium screen.
class GoldenCrownBadge extends StatelessWidget {
  final double size;
  const GoldenCrownBadge({super.key, this.size = 68});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _CrownBadgePainter()),
    );
  }
}

class _CrownBadgePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);

    canvas.drawCircle(
      center,
      w * 0.48,
      Paint()..color = AppColors.premiumGold.withValues(alpha: 0.16),
    );
    canvas.drawCircle(
      center,
      w * 0.42,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = AppColors.premiumGold.withValues(alpha: 0.55),
    );

    final crown = Path()
      ..moveTo(w * 0.26, h * 0.64)
      ..lineTo(w * 0.22, h * 0.38)
      ..lineTo(w * 0.38, h * 0.50)
      ..lineTo(w * 0.50, h * 0.30)
      ..lineTo(w * 0.62, h * 0.50)
      ..lineTo(w * 0.78, h * 0.38)
      ..lineTo(w * 0.74, h * 0.64)
      ..close();
    canvas.drawPath(crown, Paint()..color = AppColors.premiumGold);

    final dotPaint = Paint()..color = AppColors.warmWhite;
    for (final angle in [0.0, math.pi / 2, math.pi]) {
      final dx = w * 0.5 + math.cos(angle) * w * 0.28;
      canvas.drawCircle(Offset(dx, h * 0.28), 2.2, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
