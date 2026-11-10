import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/localization/app_translations.dart';
import '../../../core/ui/twilight_scaffold.dart';
import '../../../domain/models/unsent_letter.dart';
import '../../journal/bloc/journal_cubit.dart';

/// Private "Gönderilmeyecek Mektuplar" (Unsent Letters) sanctuary screen.
class LettersScreen extends StatelessWidget {
  const LettersScreen({super.key});

  Future<void> _openComposer(
    BuildContext context, {
    UnsentLetter? existing,
  }) async {
    final recipientCtrl = TextEditingController(
      text: existing?.recipient ?? '',
    );
    final titleCtrl = TextEditingController(text: existing?.title ?? '');
    final bodyCtrl = TextEditingController(text: existing?.content ?? '');

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inputTextColor = isDark ? Colors.white : AppColors.lightText;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark
          ? AppColors.darkSurfaceElevated
          : AppColors.lightSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetCtx) {
        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            MediaQuery.of(sheetCtx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppTranslations.tr(context, 'new_letter'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: recipientCtrl,
                style: TextStyle(color: inputTextColor, fontSize: 15),
                decoration: InputDecoration(
                  hintText: AppTranslations.tr(context, 'recipient_hint'),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: titleCtrl,
                style: TextStyle(
                  color: inputTextColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  hintText: AppTranslations.tr(context, 'letter_title_hint'),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: bodyCtrl,
                maxLines: 5,
                style: TextStyle(
                  color: inputTextColor,
                  fontSize: 15,
                  height: 1.5,
                ),
                decoration: InputDecoration(
                  hintText: AppTranslations.tr(context, 'letter_body_hint'),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.vibrantViolet,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    if (titleCtrl.text.trim().isEmpty &&
                        bodyCtrl.text.trim().isEmpty) {
                      return;
                    }
                    final now = DateTime.now();
                    final letter = UnsentLetter(
                      id:
                          existing?.id ??
                          'letter_${now.microsecondsSinceEpoch}',
                      recipient: recipientCtrl.text.trim(),
                      title: titleCtrl.text.trim().isEmpty
                          ? AppTranslations.tr(context, 'new_letter')
                          : titleCtrl.text.trim(),
                      content: bodyCtrl.text.trim(),
                      createdAt: existing?.createdAt ?? now,
                      updatedAt: now,
                    );
                    await context.read<JournalCubit>().saveLetter(letter);
                    if (sheetCtx.mounted) Navigator.of(sheetCtx).pop();
                  },
                  child: Text(AppTranslations.tr(context, 'save_btn')),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final letters = context.watch<JournalCubit>().state.letters;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mutedColor = isDark ? AppColors.darkMuted : AppColors.lightMuted;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppTranslations.tr(context, 'nav_letters'),
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      AppTranslations.tr(context, 'letters_subtitle'),
                      style: TextStyle(color: mutedColor, fontSize: 13),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _openComposer(context),
                icon: const Icon(
                  Icons.add_circle_rounded,
                  color: AppColors.brightLavender,
                  size: 32,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: letters.isEmpty
                ? Center(
                    child: Text(
                      AppTranslations.tr(context, 'empty_letters'),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: mutedColor),
                    ),
                  )
                : ListView.separated(
                    itemCount: letters.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final letter = letters[index];
                      return FrostedGlassCard(
                        onTap: () => _openComposer(context, existing: letter),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.mail_lock_rounded,
                              color: AppColors.premiumGold,
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    letter.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium,
                                  ),
                                  if (letter.recipient.isNotEmpty)
                                    Text(
                                      '→ ${letter.recipient}',
                                      style: TextStyle(
                                        color: mutedColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                  Text(
                                    DateFormat('dd MMM yyyy')
                                        .format(letter.createdAt),
                                    style: TextStyle(
                                      color: mutedColor,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () => context
                                  .read<JournalCubit>()
                                  .deleteLetter(letter.id),
                              icon: const Icon(
                                Icons.delete_outline_rounded,
                                color: AppColors.danger,
                              ),
                            ),
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
}
