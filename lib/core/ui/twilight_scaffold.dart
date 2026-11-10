import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

/// Shared Peaceful Twilight scaffold with atmospheric sky gradient and subtle starfield.
class TwilightScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;

  const TwilightScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.bottomNavigationBar,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: isDark
              ? AppColors.twilightSkyGradient
              : AppColors.lightSkyGradient,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (isDark)
              const IgnorePointer(
                child: CustomPaint(painter: _StarfieldPainter()),
              ),
            SafeArea(child: body),
          ],
        ),
      ),
    );
  }
}

class _StarfieldPainter extends CustomPainter {
  const _StarfieldPainter();

  static const List<Offset> _stars = [
    Offset(0.12, 0.08),
    Offset(0.84, 0.11),
    Offset(0.28, 0.19),
    Offset(0.68, 0.24),
    Offset(0.91, 0.34),
    Offset(0.09, 0.42),
    Offset(0.45, 0.14),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.warmWhite.withValues(alpha: 0.28);
    for (int i = 0; i < _stars.length; i++) {
      final pos = Offset(_stars[i].dx * size.width, _stars[i].dy * size.height);
      canvas.drawCircle(pos, (i.isEven ? 1.4 : 1.0), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Elevated twilight surface card with subtle lavender border and soft shadow.
class FrostedGlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? borderColor;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;

  const FrostedGlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.borderColor,
    this.backgroundColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radius = borderRadius ?? AppSpacing.cardRadius;
    final bg =
        backgroundColor ??
        (isDark
            ? AppColors.darkSurface.withValues(alpha: 0.88)
            : AppColors.lightSurface);
    final border =
        borderColor ?? (isDark ? AppColors.darkBorder : AppColors.lightBorder);

    final content = Padding(
      padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
      child: child,
    );

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: radius,
        border: Border.all(color: border, width: 1.1),
        boxShadow: AppSpacing.softShadow(isDark: isDark),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: onTap == null
            ? content
            : InkWell(borderRadius: radius, onTap: onTap, child: content),
      ),
    );
  }
}
