import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/localization/app_translations.dart';
import '../../../core/ui/twilight_scaffold.dart';
import '../../../core/ui/yasselim_logo.dart';
import '../bloc/premium_cubit.dart';

/// "YASSELIM Premium" one-time ad-free upgrade screen matching the UI kit.
class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PremiumCubit>().state;
    final cubit = context.read<PremiumCubit>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.warmWhite : AppColors.lightText;
    final mutedColor = isDark ? AppColors.darkMuted : AppColors.lightMuted;

    return TwilightScaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          children: [
            const Spacer(),
            FrostedGlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                children: [
                  const GoldenCrownBadge(size: 72),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    AppTranslations.tr(context, 'premium_title'),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displaySmall
                        ?.copyWith(color: textColor),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    AppTranslations.tr(context, 'premium_subtitle'),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: mutedColor, fontSize: 15),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  _benefitRow(context, 'premium_benefit_1', textColor),
                  const SizedBox(height: 12),
                  _benefitRow(context, 'premium_benefit_2', textColor),
                  const SizedBox(height: 12),
                  _benefitRow(context, 'premium_benefit_3', textColor),
                ],
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: state.isPremium
                  ? null
                  : () => cubit.purchaseOneTimePremium(),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: AppColors.premiumGoldGradient,
                  borderRadius: AppSpacing.pillRadius,
                ),
                alignment: Alignment.center,
                child: Text(
                  state.isPremium
                      ? AppTranslations.tr(context, 'premium_active_badge')
                      : AppTranslations.tr(context, 'premium_upgrade_btn'),
                  style: const TextStyle(
                    color: AppColors.deepNightNavy,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => cubit.restorePurchase(),
                  child: Text(
                    AppTranslations.tr(context, 'premium_restore_btn'),
                    style: TextStyle(color: mutedColor, fontSize: 13),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    AppTranslations.tr(context, 'premium_maybe_later'),
                    style: TextStyle(color: mutedColor, fontSize: 13),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _benefitRow(BuildContext context, String key, Color textColor) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            color: AppColors.premiumGold,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_rounded,
            size: 16,
            color: AppColors.deepNightNavy,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            AppTranslations.tr(context, key),
            style: TextStyle(
              color: textColor,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
