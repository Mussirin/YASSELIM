import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/localization/app_translations.dart';
import '../../../core/ui/mood_icon_painter.dart';
import '../../../core/ui/twilight_scaffold.dart';
import '../../../domain/models/mood_type.dart';
import '../../journal/bloc/journal_cubit.dart';

/// "İstatistikler" (Statistics) screen with period tabs, total entries/chars, dominant mood, and weekly bar chart.
class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  static const _dayKeys = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<JournalCubit>().state;
    final cubit = context.read<JournalCubit>();
    final dominantMood = state.mostCommonMood;
    final counts = state.weeklyActivityCounts;
    final maxCount = counts.fold<int>(1, (a, b) => a > b ? a : b);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.warmWhite : AppColors.lightText;
    final mutedColor = isDark ? AppColors.darkMuted : AppColors.lightMuted;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppTranslations.tr(context, 'nav_stats'),
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _periodTab(
                context,
                cubit,
                'month',
                'stats_this_month',
                state.statsPeriod,
              ),
              const SizedBox(width: 8),
              _periodTab(
                context,
                cubit,
                'year',
                'stats_this_year',
                state.statsPeriod,
              ),
              const SizedBox(width: 8),
              _periodTab(
                context,
                cubit,
                'all',
                'stats_all_time',
                state.statsPeriod,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: FrostedGlassCard(
                  child: Column(
                    children: [
                      Text(
                        '${state.statsEntries.length}',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        AppTranslations.tr(context, 'total_entries'),
                        style: TextStyle(color: mutedColor, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FrostedGlassCard(
                  child: Column(
                    children: [
                      Text(
                        NumberFormat.decimalPattern().format(
                          state.totalCharacters,
                        ),
                        style: TextStyle(
                          color: textColor,
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        AppTranslations.tr(context, 'total_chars'),
                        style: TextStyle(color: mutedColor, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          FrostedGlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppTranslations.tr(context, 'most_common_mood'),
                  style: TextStyle(color: mutedColor, fontSize: 13),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    MoodIconAvatar(
                      mood: dominantMood ?? MoodType.calm,
                      size: 46,
                    ),
                    const SizedBox(width: 14),
                    Text(
                      dominantMood != null
                          ? AppTranslations.tr(
                              context,
                              dominantMood.translationKey,
                            )
                          : AppTranslations.tr(context, 'clear_mood'),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Spacer(),
                    Text(
                      '${state.mostCommonMoodPercent}%',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          FrostedGlassCard(
            child: SizedBox(
              height: 170,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(7, (i) {
                  final factor = (counts[i] / maxCount).clamp(0.14, 1.0);
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 24,
                        height: 115 * factor,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.brightLavender,
                              AppColors.vibrantViolet,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppTranslations.tr(context, _dayKeys[i]),
                        style: TextStyle(color: mutedColor, fontSize: 12),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _periodTab(
    BuildContext context,
    JournalCubit cubit,
    String period,
    String labelKey,
    String current,
  ) {
    final active = period == current;
    return Expanded(
      child: GestureDetector(
        onTap: () => cubit.setStatsPeriod(period),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            gradient: active ? AppColors.lavenderButtonGradient : null,
            color: active ? null : Colors.white.withValues(alpha: 0.08),
            borderRadius: AppSpacing.pillRadius,
          ),
          alignment: Alignment.center,
          child: Text(
            AppTranslations.tr(context, labelKey),
            style: TextStyle(
              color: active ? Colors.white : AppColors.mutedText,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
