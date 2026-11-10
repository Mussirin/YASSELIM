import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Procedural scenic nature thumbnail for journal cards and photo attachments.
class ScenicThumbnail extends StatelessWidget {
  final int variant;
  final double size;

  const ScenicThumbnail({super.key, this.variant = 0, this.size = 56});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _ScenicThumbnailPainter(variant: variant % 4),
        ),
      ),
    );
  }
}

class _ScenicThumbnailPainter extends CustomPainter {
  final int variant;
  const _ScenicThumbnailPainter({required this.variant});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final rect = Offset.zero & size;

    final skyColors = switch (variant) {
      0 => const [Color(0xFF3E2C5E), Color(0xFFD68A59), Color(0xFF282249)],
      1 => const [Color(0xFF1F244D), Color(0xFF4F4387), Color(0xFF191936)],
      2 => const [Color(0xFF181732), Color(0xFF3A2F6B), Color(0xFF221D42)],
      _ => const [Color(0xFF14283D), Color(0xFF3B6978), Color(0xFF1A1936)],
    };

    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: skyColors,
        ).createShader(rect),
    );

    if (variant == 0) {
      // Sunset sun over calm sea
      canvas.drawCircle(
        Offset(w * 0.5, h * 0.46),
        w * 0.20,
        Paint()..color = AppColors.premiumGold,
      );
      canvas.drawRect(
        Rect.fromLTWH(0, h * 0.62, w, h * 0.38),
        Paint()..color = const Color(0xFF1E1A3B),
      );
      canvas.drawLine(
        Offset(w * 0.30, h * 0.75),
        Offset(w * 0.70, h * 0.75),
        Paint()
          ..color = AppColors.premiumGold.withValues(alpha: 0.6)
          ..strokeWidth = 2,
      );
    } else if (variant == 1) {
      // Snow-capped twilight peak
      final peak = Path()
        ..moveTo(0, h)
        ..lineTo(w * 0.45, h * 0.28)
        ..lineTo(w * 0.72, h * 0.62)
        ..lineTo(w * 0.85, h * 0.45)
        ..lineTo(w, h)
        ..close();
      canvas.drawPath(peak, Paint()..color = const Color(0xFF221E42));
      canvas.drawCircle(
        Offset(w * 0.76, h * 0.24),
        2.0,
        Paint()..color = AppColors.warmWhite,
      );
    } else if (variant == 2) {
      // Crescent moon over night hills
      canvas.drawCircle(
        Offset(w * 0.65, h * 0.30),
        w * 0.14,
        Paint()..color = AppColors.softLavender,
      );
      final hills = Path()
        ..moveTo(0, h * 0.72)
        ..quadraticBezierTo(w * 0.35, h * 0.52, w * 0.70, h * 0.70)
        ..quadraticBezierTo(w * 0.85, h * 0.60, w, h * 0.68)
        ..lineTo(w, h)
        ..lineTo(0, h)
        ..close();
      canvas.drawPath(hills, Paint()..color = const Color(0xFF15132B));
    } else {
      // Starry aurora wave above silhouettes
      final aurora = Path()
        ..moveTo(0, h * 0.42)
        ..quadraticBezierTo(w * 0.5, h * 0.20, w, h * 0.38);
      canvas.drawPath(
        aurora,
        Paint()
          ..color = AppColors.moodCalm.withValues(alpha: 0.65)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ScenicThumbnailPainter oldDelegate) =>
      oldDelegate.variant != variant;
}
