import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/localization/app_translations.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/ui/twilight_scaffold.dart';
import '../../../core/ui/yasselim_logo.dart';

/// Brand welcome & splash screen matching the "YASSELIM — Your Private Space" design.
class SplashScreen extends StatelessWidget {
  final VoidCallback onGetStarted;

  const SplashScreen({super.key, required this.onGetStarted});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.warmWhite : AppColors.lightText;
    final mutedColor = isDark ? AppColors.darkMuted : AppColors.lightMuted;

    return TwilightScaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xxl,
          vertical: AppSpacing.xl,
        ),
        child: Column(
          children: [
            const Spacer(),
            const YasselimLogo(size: 88, showCard: false),
            const SizedBox(height: AppSpacing.lg),
            Text(
              AppTranslations.tr(context, 'app_name'),
              style: AppTypography.brandTitle(color: textColor, fontSize: 32),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              AppTranslations.tr(context, 'brand_subtitle'),
              style: TextStyle(
                color: mutedColor,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 3.2,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            const SplashMountainArtwork(height: 190),
            const SizedBox(height: AppSpacing.xl),
            Text(
              AppTranslations.tr(context, 'tagline'),
              textAlign: TextAlign.center,
              style: AppTypography.editorialQuote(
                color: textColor.withValues(alpha: 0.9),
                fontSize: 16,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: onGetStarted,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: AppColors.lavenderButtonGradient,
                  borderRadius: AppSpacing.pillRadius,
                  boxShadow: AppSpacing.lavenderGlow(),
                ),
                alignment: Alignment.center,
                child: Text(
                  AppTranslations.tr(context, 'splash_cta'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }
}
