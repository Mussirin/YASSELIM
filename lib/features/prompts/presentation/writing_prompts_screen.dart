import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/localization/app_translations.dart';
import '../../../core/localization/locale_cubit.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/ui/twilight_scaffold.dart';
import '../../../domain/models/journal_entry.dart';
import '../../journal/bloc/journal_cubit.dart';

/// Dedicated "Writing Prompts" (Screen 06) carousel and quick draft box.
class WritingPromptsScreen extends StatefulWidget {
  final void Function(String promptText, String initialDraft) onStartWithPrompt;

  const WritingPromptsScreen({super.key, required this.onStartWithPrompt});

  @override
  State<WritingPromptsScreen> createState() => _WritingPromptsScreenState();
}

class _WritingPromptsScreenState extends State<WritingPromptsScreen> {
  final TextEditingController _draftCtrl = TextEditingController();
  final FocusNode _draftFocus = FocusNode();
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _draftCtrl.addListener(_onWriteStateChanged);
    _draftFocus.addListener(_onWriteStateChanged);
  }

  void _onWriteStateChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _draftCtrl.removeListener(_onWriteStateChanged);
    _draftFocus.removeListener(_onWriteStateChanged);
    _draftCtrl.dispose();
    _draftFocus.dispose();
    super.dispose();
  }

  Future<void> _onPrimaryButtonTap(String promptText) async {
    final draft = _draftCtrl.text.trim();
    if (draft.isNotEmpty) {
      final now = DateTime.now();
      final entry = JournalEntry(
        id: 'entry_${now.microsecondsSinceEpoch}',
        title: promptText,
        content: draft,
        createdAt: now,
        updatedAt: now,
        scenicVariant: _index % 4,
      );
      await context.read<JournalCubit>().saveEntry(entry);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppTranslations.tr(context, 'entry_saved'))),
      );
      Navigator.of(context).pop();
      return;
    }

    if (!_draftFocus.hasFocus) {
      _draftFocus.requestFocus();
    } else {
      Navigator.of(context).pop();
      widget.onStartWithPrompt(promptText, draft);
    }
  }

  void _step(int delta) {
    final len = AppTranslations.prompts.length;
    setState(() {
      _index = (_index + delta + len) % len;
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LocaleCubit>().state.languageCode;
    final prompt = AppTranslations.prompts[_index];
    final promptText = prompt.textFor(lang);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.warmWhite : AppColors.lightText;
    final mutedColor = isDark ? AppColors.darkMuted : AppColors.lightMuted;
    final isKeyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;
    final isWriting =
        _draftFocus.hasFocus ||
        isKeyboardOpen ||
        _draftCtrl.text.trim().isNotEmpty;

    return TwilightScaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(AppTranslations.tr(context, 'prompts_title')),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = isKeyboardOpen || constraints.maxHeight < 440;
          return Padding(
            padding: EdgeInsets.fromLTRB(20, 4, 20, isCompact ? 8 : 20),
            child: Column(
              children: [
                Expanded(
                  child: FrostedGlassCard(
                    padding: EdgeInsets.all(isCompact ? 12 : 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                prompt.categoryFor(lang).toUpperCase(),
                                style: const TextStyle(
                                  color: AppColors.premiumGold,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.8,
                                ),
                              ),
                            ),
                            if (isCompact)
                              Text(
                                '${_index + 1} / ${AppTranslations.prompts.length}',
                                style: TextStyle(
                                  color: mutedColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: isCompact ? 4 : 10),
                        Text(
                          promptText,
                          maxLines: isCompact ? 2 : 4,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.editorialQuote(
                            color: textColor,
                            fontSize: isCompact ? 14 : 18,
                          ),
                        ),
                        SizedBox(height: isCompact ? 8 : 16),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.darkSurfaceElevated
                                  : Colors.white,
                              borderRadius: AppSpacing.mediumRadius,
                              border: Border.all(
                                color: isDark
                                    ? AppColors.darkBorder
                                    : AppColors.lightBorder,
                              ),
                            ),
                            child: TextField(
                              controller: _draftCtrl,
                              focusNode: _draftFocus,
                              maxLines: null,
                              expands: true,
                              textAlignVertical: TextAlignVertical.top,
                              cursorColor: AppColors.brightLavender,
                              style: TextStyle(
                                color: isDark
                                    ? Colors.white
                                    : AppColors.lightText,
                                fontSize: 15,
                                height: 1.5,
                              ),
                              decoration: InputDecoration(
                                filled: false,
                                isCollapsed: true,
                                hintText: AppTranslations.tr(
                                  context,
                                  'entry_body_hint',
                                ),
                                hintStyle: TextStyle(color: mutedColor),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: isCompact ? 8 : 16),
                        GestureDetector(
                          onTap: () => _onPrimaryButtonTap(promptText),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              vertical: isCompact ? 10 : 14,
                            ),
                            decoration: BoxDecoration(
                              gradient: AppColors.lavenderButtonGradient,
                              borderRadius: AppSpacing.pillRadius,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              isWriting
                                  ? AppTranslations.tr(context, 'save_btn')
                                  : '${AppTranslations.tr(context, 'start_writing')} ✨',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (!isCompact) ...[
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () => _step(-1),
                        icon: const Icon(Icons.chevron_left_rounded, size: 28),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          '${_index + 1} / ${AppTranslations.prompts.length}',
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => _step(1),
                        icon: const Icon(Icons.chevron_right_rounded, size: 28),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
