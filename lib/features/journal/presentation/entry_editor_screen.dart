import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/localization/app_translations.dart';
import '../../../core/ui/mood_icon_painter.dart';
import '../../../core/ui/scenic_thumbnail.dart';
import '../../../core/ui/twilight_scaffold.dart';
import '../../../domain/models/journal_entry.dart';
import '../../../domain/models/mood_type.dart';
import '../bloc/journal_cubit.dart';
import 'widgets/mood_selector_sheet.dart';

/// Distraction-free journal editor ("Yeni Yazı") — NEVER displays any ads.
class EntryEditorScreen extends StatefulWidget {
  final JournalEntry? existingEntry;
  final String? initialPrompt;
  final String? initialContent;

  const EntryEditorScreen({
    super.key,
    this.existingEntry,
    this.initialPrompt,
    this.initialContent,
  });

  @override
  State<EntryEditorScreen> createState() => _EntryEditorScreenState();
}

class _EntryEditorScreenState extends State<EntryEditorScreen> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _bodyCtrl;
  MoodType? _selectedMood;
  late List<String> _selectedTags;
  int _scenicVariant = 0;
  bool _dirty = false;

  static const _presetTagKeys = [
    'tag_happiness',
    'tag_stress',
    'tag_hope',
    'tag_love',
    'tag_peace',
  ];

  @override
  void initState() {
    super.initState();
    final e = widget.existingEntry;
    _titleCtrl = TextEditingController(text: e?.title ?? '');
    _bodyCtrl = TextEditingController(
      text: e?.content ?? widget.initialContent ?? '',
    );
    _selectedMood = e?.mood;
    _selectedTags = List<String>.from(e?.tags ?? const []);
    _scenicVariant = e?.scenicVariant ?? 0;
    _titleCtrl.addListener(_markDirty);
    _bodyCtrl.addListener(_markDirty);
  }

  void _markDirty() => setState(() => _dirty = true);

  @override
  void dispose() {
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final rawTitle = _titleCtrl.text.trim();
    final rawBody = _bodyCtrl.text.trim();
    if (rawTitle.isEmpty && rawBody.isEmpty) return;

    final now = DateTime.now();
    final entry = JournalEntry(
      id: widget.existingEntry?.id ?? 'entry_${now.microsecondsSinceEpoch}',
      title: rawTitle.isEmpty
          ? (widget.initialPrompt ??
                AppTranslations.tr(context, 'new_entry_title'))
          : rawTitle,
      content: rawBody,
      createdAt: widget.existingEntry?.createdAt ?? now,
      updatedAt: now,
      mood: _selectedMood,
      tags: _selectedTags,
      scenicVariant: _scenicVariant,
    );
    await context.read<JournalCubit>().saveEntry(entry);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.warmWhite : AppColors.lightText;
    final mutedColor = isDark ? AppColors.darkMuted : AppColors.lightMuted;
    final titleKey = widget.existingEntry == null
        ? 'new_entry_title'
        : 'edit_entry_title';

    return TwilightScaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(AppTranslations.tr(context, titleKey)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.initialPrompt ??
                  AppTranslations.tr(context, 'editor_question'),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurfaceElevated : Colors.white,
                borderRadius: AppSpacing.cardRadius,
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _titleCtrl,
                    cursorColor: AppColors.brightLavender,
                    style: TextStyle(
                      color: isDark ? Colors.white : AppColors.lightText,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      filled: false,
                      hintText: AppTranslations.tr(context, 'entry_title_hint'),
                      hintStyle: TextStyle(color: mutedColor),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                  Divider(
                    height: 12,
                    color: isDark
                        ? AppColors.darkBorder
                        : const Color(0x226652B5),
                  ),
                  TextField(
                    controller: _bodyCtrl,
                    maxLines: 6,
                    maxLength: 2000,
                    cursorColor: AppColors.brightLavender,
                    style: TextStyle(
                      color: isDark ? Colors.white : AppColors.lightText,
                      fontSize: 15,
                      height: 1.5,
                    ),
                    decoration: InputDecoration(
                      filled: false,
                      hintText: AppTranslations.tr(context, 'entry_body_hint'),
                      hintStyle: TextStyle(color: mutedColor),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      counterStyle: TextStyle(color: mutedColor),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Text(
                  AppTranslations.tr(context, 'todays_mood'),
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () async {
                    final picked = await MoodSelectorSheet.show(
                      context,
                      current: _selectedMood,
                    );
                    setState(() => _selectedMood = picked);
                  },
                  child: Text(AppTranslations.tr(context, 'view_all')),
                ),
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: MoodType.values.map((m) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: MoodIconAvatar(
                      mood: m,
                      isSelected: _selectedMood == m,
                      onTap: () => setState(
                        () => _selectedMood = _selectedMood == m ? null : m,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              AppTranslations.tr(context, 'tags_optional'),
              style: TextStyle(color: mutedColor, fontSize: 13),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ..._presetTagKeys.map((key) {
                  final label = AppTranslations.tr(context, key);
                  final selected = _selectedTags.contains(label);
                  return ChoiceChip(
                    label: Text(label),
                    selected: selected,
                    onSelected: (_) => setState(() {
                      selected
                          ? _selectedTags.remove(label)
                          : _selectedTags.add(label);
                    }),
                  );
                }),
                ...List.generate(4, (idx) {
                  return GestureDetector(
                    onTap: () => setState(() => _scenicVariant = idx),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: _scenicVariant == idx
                              ? AppColors.brightLavender
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: ScenicThumbnail(variant: idx, size: 32),
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            GestureDetector(
              onTap: _save,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: AppColors.lavenderButtonGradient,
                  borderRadius: AppSpacing.pillRadius,
                  boxShadow: AppSpacing.lavenderGlow(),
                ),
                alignment: Alignment.center,
                child: Text(
                  AppTranslations.tr(context, 'save_btn'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            if (_dirty) const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
