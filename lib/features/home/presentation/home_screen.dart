import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/localization/app_translations.dart';
import '../../../core/localization/locale_cubit.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/ui/mood_icon_painter.dart';
import '../../../core/ui/scenic_thumbnail.dart';
import '../../../core/ui/twilight_scaffold.dart';
import '../../../domain/models/journal_entry.dart';
import '../../history/presentation/widgets/reflections_calendar_card.dart';
import '../../journal/bloc/journal_cubit.dart';
import '../../journal/bloc/journal_state.dart';
import '../../premium/bloc/premium_cubit.dart';
import '../../prompts/presentation/writing_prompts_screen.dart';

/// Main Home Sanctuary screen matching Reference Images 1, 2 & Screen 05.
class HomeScreen extends StatefulWidget {
  final void Function({
    JournalEntry? entry,
    String? initialPrompt,
    String? initialContent,
  })
  onOpenEditor;
  final VoidCallback onViewAllHistory;
  final VoidCallback onOpenLetters;

  const HomeScreen({
    super.key,
    required this.onOpenEditor,
    required this.onViewAllHistory,
    required this.onOpenLetters,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int _promptIndex = 0;
  DateTime _selectedDate = DateTime.now();

  void _openPromptsModal(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => WritingPromptsScreen(
          onStartWithPrompt: (promptText, draft) {
            widget.onOpenEditor(
              initialPrompt: promptText,
              initialContent: draft,
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LocaleCubit>().state.languageCode;
    final journalState = context.watch<JournalCubit>().state;
    final isPremium = context.watch<PremiumCubit>().state.isPremium;
    final prompt = AppTranslations.prompts[_promptIndex];
    final recent = journalState.entries.take(3).toList();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.warmWhite : AppColors.lightText;
    final mutedColor = isDark ? AppColors.darkMuted : AppColors.lightMuted;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TwilightLakeHeaderBanner(
            title: '${AppTranslations.tr(context, 'welcome_back')} 👋',
            subtitle: DateFormat('EEEE, d MMMM').format(_selectedDate),
            height: 138,
          ),
          const SizedBox(height: AppSpacing.md),
          HorizontalWeekStrip(
            selectedDate: _selectedDate,
            onSelectDate: (d) => setState(() => _selectedDate = d),
            entryDates: journalState.entries.map((e) => e.createdAt).toList(),
          ),
          const SizedBox(height: AppSpacing.md),
          _buildActionButtons(context),
          const SizedBox(height: AppSpacing.md),
          _buildStatsRow(context, journalState, textColor, mutedColor),
          const SizedBox(height: AppSpacing.md),
          FrostedGlassCard(
            onTap: () => _openPromptsModal(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.lightbulb_rounded,
                      color: AppColors.premiumGold,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${AppTranslations.tr(context, 'daily_reflection')} ✨',
                      style: const TextStyle(
                        color: AppColors.brightLavender,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 18,
                      color: mutedColor,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '"${prompt.textFor(lang)}"',
                  style: AppTypography.editorialQuote(
                    color: textColor,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _buildRecentSection(context, recent, textColor, mutedColor),
          if (!isPremium) ...[
            const SizedBox(height: AppSpacing.md),
            Center(
              child: Text(
                AppTranslations.tr(context, 'ad_banner_label'),
                style: TextStyle(
                  color: mutedColor.withValues(alpha: 0.7),
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatsRow(
    BuildContext context,
    JournalState state,
    Color textColor,
    Color mutedColor,
  ) {
    Widget statTile(
      String icon,
      String value,
      String label, {
      VoidCallback? onTap,
    }) {
      return Expanded(
        child: FrostedGlassCard(
          onTap: onTap,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Column(
            children: [
              Text(
                '$icon $value',
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: mutedColor, fontSize: 11),
              ),
            ],
          ),
        ),
      );
    }

    return Row(
      children: [
        statTile(
          '🔥',
          '${state.currentStreak}',
          AppTranslations.tr(context, 'day_streak'),
        ),
        const SizedBox(width: 10),
        statTile(
          '📘',
          '${state.entries.length}',
          AppTranslations.tr(context, 'entries_count'),
          onTap: widget.onViewAllHistory,
        ),
        const SizedBox(width: 10),
        statTile(
          '✉️',
          '${state.letters.length}',
          AppTranslations.tr(context, 'letters_count'),
          onTap: widget.onOpenLetters,
        ),
      ],
    );
  }

  Widget _buildRecentSection(
    BuildContext context,
    List<JournalEntry> recent,
    Color textColor,
    Color mutedColor,
  ) {
    return FrostedGlassCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                AppTranslations.tr(context, 'recent_entries'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              GestureDetector(
                onTap: widget.onViewAllHistory,
                child: Text(
                  '${AppTranslations.tr(context, 'view_all')} ›',
                  style: const TextStyle(
                    color: AppColors.brightLavender,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (recent.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: Text(
                AppTranslations.tr(context, 'empty_history'),
                textAlign: TextAlign.center,
                style: TextStyle(color: mutedColor, fontSize: 13),
              ),
            )
          else
            ...recent.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(top: 10),
                child: InkWell(
                  borderRadius: AppSpacing.mediumRadius,
                  onTap: () => widget.onOpenEditor(entry: entry),
                  child: Row(
                    children: [
                      ScenicThumbnail(variant: entry.scenicVariant, size: 48),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              DateFormat('dd MMM yyyy • HH:mm')
                                  .format(entry.createdAt),
                              style: TextStyle(color: mutedColor, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      if (entry.mood != null)
                        MoodIconAvatar(mood: entry.mood!, size: 32)
                      else
                        const Icon(
                          Icons.auto_awesome,
                          size: 18,
                          color: AppColors.premiumGold,
                        ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => widget.onOpenEditor(),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                gradient: AppColors.lavenderButtonGradient,
                borderRadius: AppSpacing.pillRadius,
                boxShadow: AppSpacing.lavenderGlow(),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.edit_note_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${AppTranslations.tr(context, 'start_writing')} ✨',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: widget.onOpenLetters,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: AppSpacing.pillRadius,
              border: Border.all(
                color: AppColors.brightLavender.withValues(alpha: 0.35),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.mail_outline_rounded,
                  color: AppColors.brightLavender,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  AppTranslations.tr(context, 'write_letter'),
                  style: const TextStyle(
                    color: AppColors.brightLavender,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
