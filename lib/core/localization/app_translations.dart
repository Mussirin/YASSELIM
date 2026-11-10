import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/writing_prompt.dart';
import 'languages/ar_strings.dart';
import 'languages/de_strings.dart';
import 'languages/en_strings.dart';
import 'languages/es_strings.dart';
import 'languages/fr_strings.dart';
import 'languages/ja_strings.dart';
import 'languages/pt_strings.dart';
import 'languages/ru_strings.dart';
import 'languages/tr_strings.dart';
import 'languages/zh_strings.dart';
import 'locale_cubit.dart';
import 'prompts_data.dart';

/// Multi-language localization resolver (10 global languages) and original writing prompts.
abstract final class AppTranslations {
  static const Map<String, Map<String, String>> _dictionaries = {
    'tr': kTrStrings,
    'en': kEnStrings,
    'es': kEsStrings,
    'de': kDeStrings,
    'fr': kFrStrings,
    'pt': kPtStrings,
    'ru': kRuStrings,
    'zh': kZhStrings,
    'ja': kJaStrings,
    'ar': kArStrings,
  };

  static String tr(BuildContext context, String key) {
    final lang =
        Localizations.maybeLocaleOf(context)?.languageCode ??
        context.read<LocaleCubit>().state.languageCode;
    return byLocale(lang, key);
  }

  static String byLocale(String lang, String key) {
    final map = _dictionaries[lang] ?? kEnStrings;
    return map[key] ?? kEnStrings[key] ?? key;
  }

  static const List<WritingPrompt> prompts = kGlobalWritingPrompts;
}
