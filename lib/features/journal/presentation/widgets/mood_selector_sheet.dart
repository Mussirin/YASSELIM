import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/localization/app_translations.dart';
import '../../../../core/ui/mood_icon_painter.dart';
import '../../../../domain/models/mood_type.dart';

/// Modal bottom sheet allowing the user to select or clear one of the 8 core moods.
class MoodSelectorSheet extends StatelessWidget {
  final MoodType? selectedMood;

  const MoodSelectorSheet({super.key, this.selectedMood});

  static Future<MoodType?> show(
    BuildContext context, {
    MoodType? current,
  }) async {
    final result = await showModalBottomSheet<Object?>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => MoodSelectorSheet(selectedMood: current),
    );
    if (result == 'clear') return null;
    if (result is MoodType) return result;
    return current;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurface;
    final textColor = isDark ? AppColors.warmWhite : AppColors.lightText;
    final mutedColor = isDark ? AppColors.darkMuted : AppColors.lightMuted;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.lg,
        AppSpacing.xl,
        AppSpacing.xxl,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: mutedColor.withValues(alpha: 0.4),
                borderRadius: AppSpacing.pillRadius,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              AppTranslations.tr(context, 'mood_sheet_title'),
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(color: textColor),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              AppTranslations.tr(context, 'mood_sheet_subtitle'),
              style: TextStyle(
                color: mutedColor,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Wrap(
              spacing: AppSpacing.lg,
              runSpacing: AppSpacing.lg,
              alignment: WrapAlignment.center,
              children: MoodType.values.map((mood) {
                final isSelected = mood == selectedMood;
                return SizedBox(
                  width: 72,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MoodIconAvatar(
                        mood: mood,
                        isSelected: isSelected,
                        size: 52,
                        onTap: () => Navigator.of(context).pop(mood),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        AppTranslations.tr(context, mood.translationKey),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: isSelected ? mood.color : mutedColor,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextButton(
              onPressed: () => Navigator.of(context).pop('clear'),
              child: Text(
                AppTranslations.tr(context, 'clear_mood'),
                style: TextStyle(color: mutedColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
