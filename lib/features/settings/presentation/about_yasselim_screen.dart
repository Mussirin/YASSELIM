import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/localization/app_translations.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/ui/twilight_scaffold.dart';
import '../../../core/ui/yasselim_logo.dart';

/// Dedicated "About YASSELIM" screen (Screen 15) with brand story, legal/medical disclaimer, and OSS licenses.
class AboutYasselimScreen extends StatelessWidget {
  const AboutYasselimScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.warmWhite : AppColors.lightText;
    final mutedColor = isDark ? AppColors.darkMuted : AppColors.lightMuted;

    return TwilightScaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(AppTranslations.tr(context, 'settings_about')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          children: [
            const YasselimLogo(size: 76, showCard: false),
            const SizedBox(height: AppSpacing.md),
            Text(
              AppTranslations.tr(context, 'about_header_title'),
              style: Theme.of(context).textTheme.headlineMedium
                  ?.copyWith(color: textColor),
            ),
            const SizedBox(height: 6),
            Text(
              AppTranslations.tr(context, 'about_header_motto'),
              style: AppTypography.editorialQuote(
                color: AppColors.brightLavender,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            FrostedGlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppTranslations.tr(context, 'privacy_disclaimer_title'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    AppTranslations.tr(context, 'privacy_disclaimer_body'),
                    style: TextStyle(
                      color: textColor.withValues(alpha: 0.9),
                      fontSize: 14,
                      height: 1.55,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            FrostedGlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.privacy_tip_outlined,
                      color: AppColors.brightLavender,
                    ),
                    title: Text(
                      AppTranslations.tr(context, 'privacy_policy_row'),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => _showInfoDialog(
                      context,
                      AppTranslations.tr(context, 'privacy_policy_title'),
                      AppTranslations.tr(context, 'privacy_policy_full'),
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.description_outlined,
                      color: AppColors.brightLavender,
                    ),
                    title: Text(
                      AppTranslations.tr(context, 'terms_of_use_row'),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => _showInfoDialog(
                      context,
                      AppTranslations.tr(context, 'terms_of_use_title'),
                      AppTranslations.tr(context, 'terms_of_use_full'),
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.code_rounded,
                      color: AppColors.brightLavender,
                    ),
                    title: Text(AppTranslations.tr(context, 'licenses_btn')),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => showLicensePage(
                      context: context,
                      applicationName: 'YASSELIM',
                      applicationVersion: '1.0.0',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Text(
              AppTranslations.tr(context, 'version_label'),
              style: TextStyle(color: mutedColor, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context, String title, String body) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.lightText;

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark
            ? AppColors.darkSurfaceElevated
            : AppColors.lightSurface,
        shape: RoundedRectangleBorder(borderRadius: AppSpacing.cardRadius),
        title: Text(
          title,
          style: TextStyle(
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: SingleChildScrollView(
          child: Text(
            body,
            style: TextStyle(color: textColor, fontSize: 14, height: 1.6),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(AppTranslations.tr(context, 'export_close_btn')),
          ),
        ],
      ),
    );
  }
}
