import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/ui/mood_icon_painter.dart';
import '../../../core/ui/scenic_thumbnail.dart';
import '../../../core/ui/twilight_scaffold.dart';
import '../../../domain/models/journal_entry.dart';
import '../../journal/bloc/journal_cubit.dart';
import 'widgets/reflections_calendar_card.dart';

/// Detailed reader view for a single journal entry (Screen 08) with scenic lake banner, edit, and delete actions.
class EntryDetailScreen extends StatelessWidget {
  final JournalEntry entry;
  final VoidCallback onEdit;

  const EntryDetailScreen({
    super.key,
    required this.entry,
    required this.onEdit,
  });

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
        actions: [
          IconButton(onPressed: onEdit, icon: const Icon(Icons.edit_outlined)),
          IconButton(
            onPressed: () async {
              await context.read<JournalCubit>().deleteEntry(entry.id);
              if (context.mounted) Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: AppColors.danger,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TwilightLakeHeaderBanner(
              title: entry.title,
              subtitle: DateFormat('dd MMMM yyyy • HH:mm')
                  .format(entry.createdAt),
              height: 140,
            ),
            const SizedBox(height: AppSpacing.md),
            FrostedGlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ScenicThumbnail(variant: entry.scenicVariant, size: 52),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.title,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat('dd MMMM yyyy • HH:mm')
                                  .format(entry.createdAt),
                              style: TextStyle(color: mutedColor, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      if (entry.mood != null)
                        MoodIconAvatar(mood: entry.mood!, size: 42),
                    ],
                  ),
                  if (entry.tags.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: entry.tags
                          .map(
                            (tag) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.brightLavender.withValues(
                                  alpha: 0.16,
                                ),
                                borderRadius: AppSpacing.pillRadius,
                              ),
                              child: Text(
                                '#$tag',
                                style: const TextStyle(
                                  color: AppColors.brightLavender,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    entry.content,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      height: 1.65,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
