import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/localization/app_translations.dart';
import '../../../core/localization/locale_cubit.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/theme_cubit.dart';
import '../../../core/ui/twilight_scaffold.dart';
import '../../journal/bloc/journal_cubit.dart';
import '../../premium/bloc/premium_cubit.dart';
import '../../premium/presentation/premium_screen.dart';
import '../../security/bloc/security_cubit.dart';
import '../../security/presentation/pin_lock_screen.dart';
import 'about_yasselim_screen.dart';
import 'widgets/language_selector_sheet.dart';

/// "Ayarlar" (Settings) screen — strictly no user account/login row (100% offline-first).
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeCubit>().state;
    final locale = context.watch<LocaleCubit>().state;
    final secState = context.watch<SecurityCubit>().state;
    final isPremium = context.watch<PremiumCubit>().state.isPremium;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mutedColor = isDark ? AppColors.darkMuted : AppColors.lightMuted;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppTranslations.tr(context, 'nav_settings'),
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            AppTranslations.tr(context, 'settings_app_section'),
            style: TextStyle(
              color: mutedColor,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          FrostedGlassCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    AppTranslations.tr(context, 'settings_dark_mode'),
                  ),
                  value: themeMode != ThemeMode.light,
                  activeThumbColor: AppColors.brightLavender,
                  onChanged: (_) =>
                      context.read<ThemeCubit>().toggleDarkLight(),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(AppTranslations.tr(context, 'settings_language')),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        LocaleCubit.nativeNameFor(locale.languageCode),
                        style: const TextStyle(
                          color: AppColors.brightLavender,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.expand_more_rounded,
                        color: AppColors.brightLavender,
                        size: 20,
                      ),
                    ],
                  ),
                  onTap: () => LanguageSelectorSheet.show(context),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(AppTranslations.tr(context, 'settings_app_lock')),
                  value: secState.isPinEnabled,
                  activeThumbColor: AppColors.brightLavender,
                  onChanged: (val) async {
                    if (val) {
                      await Navigator.of(context).push(
                        MaterialPageRoute<bool>(
                          builder: (_) =>
                              const PinLockScreen(isSetupMode: true),
                        ),
                      );
                    } else {
                      await context.read<SecurityCubit>().disablePin();
                    }
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(AppTranslations.tr(context, 'settings_export')),
                  trailing: const Icon(Icons.download_rounded, size: 20),
                  onTap: () => _showExportDialog(context),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    AppTranslations.tr(context, 'settings_delete_all'),
                    style: const TextStyle(color: AppColors.danger),
                  ),
                  onTap: () => context.read<JournalCubit>().clearAllData(),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            AppTranslations.tr(context, 'settings_premium_section'),
            style: TextStyle(
              color: mutedColor,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          FrostedGlassCard(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const PremiumScreen()),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.workspace_premium_rounded,
                  color: AppColors.premiumGold,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    isPremium
                        ? AppTranslations.tr(context, 'premium_active_badge')
                        : AppTranslations.tr(context, 'settings_ad_free'),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          FrostedGlassCard(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const AboutYasselimScreen(),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.shield_outlined,
                  color: AppColors.brightLavender,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(AppTranslations.tr(context, 'settings_about')),
                ),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Center(
            child: Text(
              'YASSELIM v1.0.0',
              style: TextStyle(color: mutedColor, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  void _showExportDialog(BuildContext context) {
    final lang = context.read<LocaleCubit>().state.languageCode;
    final bookText = context.read<JournalCubit>().exportJson(lang: lang);
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
          AppTranslations.tr(context, 'settings_export'),
          style: AppTypography.brandTitle(
            color: textColor,
            fontSize: 18,
          ).copyWith(letterSpacing: 1.2, fontWeight: FontWeight.w700),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: SelectableText(
              bookText,
              style: TextStyle(color: textColor, fontSize: 14, height: 1.65),
            ),
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: bookText));
              if (ctx.mounted) {
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppTranslations.tr(context, 'export_copied')),
                  ),
                );
              }
            },
            icon: const Icon(Icons.copy_rounded, size: 18),
            label: Text(AppTranslations.tr(context, 'export_copy_btn')),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(AppTranslations.tr(context, 'export_close_btn')),
          ),
        ],
      ),
    );
  }
}
