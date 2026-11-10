import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/localization/app_translations.dart';
import '../../../core/ui/mood_icon_painter.dart';
import '../../../core/ui/scenic_thumbnail.dart';
import '../../../core/ui/twilight_scaffold.dart';
import '../../../domain/models/journal_entry.dart';
import '../../../domain/models/mood_type.dart';
import '../../journal/bloc/journal_cubit.dart';
import '../../journal/bloc/journal_state.dart';
import 'entry_detail_screen.dart';
import 'widgets/reflections_calendar_card.dart';

/// "Geçmişim" (My History & Reflections Calendar) screen with search, mood/date filters, and calendar toggle.
class HistoryScreen extends StatefulWidget {
  final void Function(JournalEntry entry) onEditEntry;

  const HistoryScreen({super.key, required this.onEditEntry});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool _showCalendar = false;
  DateTime _selectedCalendarDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<JournalCubit>().state;
    final cubit = context.read<JournalCubit>();
    final entries = state.filteredEntries;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.warmWhite : AppColors.lightText;
    final mutedColor = isDark ? AppColors.darkMuted : AppColors.lightMuted;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  AppTranslations.tr(context, 'nav_history'),
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ),
              IconButton(
                onPressed: () => setState(() => _showCalendar = !_showCalendar),
                icon: Icon(
                  _showCalendar
                      ? Icons.view_agenda_outlined
                      : Icons.calendar_month_rounded,
                  color: AppColors.brightLavender,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            onChanged: cubit.setSearchQuery,
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search_rounded, color: mutedColor),
              hintText: AppTranslations.tr(context, 'search_hint'),
              hintStyle: TextStyle(color: mutedColor),
              filled: true,
              fillColor: (isDark ? AppColors.darkSurfaceElevated : Colors.white)
                  .withValues(alpha: 0.8),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              border: OutlineInputBorder(
                borderRadius: AppSpacing.pillRadius,
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _filterChip(
                  context,
                  cubit,
                  DateFilter.all,
                  'filter_all',
                  state.dateFilter,
                ),
                _filterChip(
                  context,
                  cubit,
                  DateFilter.today,
                  'filter_today',
                  state.dateFilter,
                ),
                _filterChip(
                  context,
                  cubit,
                  DateFilter.week,
                  'filter_week',
                  state.dateFilter,
                ),
                _filterChip(
                  context,
                  cubit,
                  DateFilter.month,
                  'filter_month',
                  state.dateFilter,
                ),
                ...MoodType.values.map((m) {
                  final active = state.moodFilter == m;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: GestureDetector(
                      onTap: () => cubit.setMoodFilter(active ? null : m),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: active
                              ? m.color.withValues(alpha: 0.28)
                              : Colors.white.withValues(alpha: 0.06),
                          borderRadius: AppSpacing.pillRadius,
                          border: Border.all(
                            color: active ? m.color : Colors.transparent,
                          ),
                        ),
                        child: Text(
                          AppTranslations.tr(context, m.translationKey),
                          style: TextStyle(
                            color: active ? textColor : mutedColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          if (_showCalendar &&
              MediaQuery.viewInsetsOf(context).bottom == 0) ...[
            const SizedBox(height: AppSpacing.sm),
            ReflectionsMonthlyCalendar(
              selectedDate: _selectedCalendarDate,
              onSelectDate: (d) => setState(() => _selectedCalendarDate = d),
              entryDates: state.entries.map((e) => e.createdAt).toList(),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: entries.isEmpty
                ? Center(
                    child: Text(
                      AppTranslations.tr(context, 'empty_history'),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: mutedColor),
                    ),
                  )
                : ListView.separated(
                    itemCount: entries.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final entry = entries[index];
                      return FrostedGlassCard(
                        padding: const EdgeInsets.all(12),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => EntryDetailScreen(
                              entry: entry,
                              onEdit: () {
                                Navigator.of(context).pop();
                                widget.onEditEntry(entry);
                              },
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            ScenicThumbnail(
                              variant: entry.scenicVariant,
                              size: 54,
                            ),
                            const SizedBox(width: 14),
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
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    DateFormat('dd MMMM yyyy')
                                        .format(entry.createdAt),
                                    style: TextStyle(
                                      color: mutedColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (entry.mood != null)
                              MoodIconAvatar(mood: entry.mood!, size: 36),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(
    BuildContext context,
    JournalCubit cubit,
    DateFilter filter,
    String labelKey,
    DateFilter current,
  ) {
    final active = filter == current;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => cubit.setDateFilter(filter),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: active ? AppColors.lavenderButtonGradient : null,
            color: active ? null : Colors.white.withValues(alpha: 0.08),
            borderRadius: AppSpacing.pillRadius,
          ),
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
