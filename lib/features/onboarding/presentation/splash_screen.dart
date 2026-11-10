import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/localization/app_translations.dart';
import '../../../core/localization/locale_cubit.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/ui/twilight_scaffold.dart';
import '../../../core/ui/yasselim_logo.dart';
import '../../settings/presentation/widgets/language_selector_sheet.dart';

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
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                borderRadius: AppSpacing.pillRadius,
                onTap: () => LanguageSelectorSheet.show(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.lavender.withValues(alpha: 0.14),
                    borderRadius: AppSpacing.pillRadius,
                    border: Border.all(
                      color: AppColors.brightLavender.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.language_rounded,
                        size: 16,
                        color: AppColors.brightLavender,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        LocaleCubit.nativeNameFor(
                          context.watch<LocaleCubit>().state.languageCode,
                        ),
                        style: const TextStyle(
                          color: AppColors.brightLavender,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
