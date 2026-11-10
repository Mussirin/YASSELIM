import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Metadata for a supported application language.
class SupportedLanguage {
  final String code;
  final String nativeName;
  final String englishName;
  final String badge;

  const SupportedLanguage({
    required this.code,
    required this.nativeName,
    required this.englishName,
    required this.badge,
  });
}

/// Manages 10 global app locales with local persistence.
class LocaleCubit extends Cubit<Locale> {
  static const String _prefKey = 'yasselim_locale_code';
  final SharedPreferences? _prefs;

  static const List<SupportedLanguage> supportedLanguages = [
    SupportedLanguage(
      code: 'tr',
      nativeName: 'Türkçe',
      englishName: 'Turkish',
      badge: 'TR',
    ),
    SupportedLanguage(
      code: 'en',
      nativeName: 'English',
      englishName: 'English',
      badge: 'EN',
    ),
    SupportedLanguage(
      code: 'es',
      nativeName: 'Español',
      englishName: 'Spanish',
      badge: 'ES',
    ),
    SupportedLanguage(
      code: 'de',
      nativeName: 'Deutsch',
      englishName: 'German',
      badge: 'DE',
    ),
    SupportedLanguage(
      code: 'fr',
      nativeName: 'Français',
      englishName: 'French',
      badge: 'FR',
    ),
    SupportedLanguage(
      code: 'pt',
      nativeName: 'Português',
      englishName: 'Portuguese',
      badge: 'PT',
    ),
    SupportedLanguage(
      code: 'ru',
      nativeName: 'Русский',
      englishName: 'Russian',
      badge: 'RU',
    ),
    SupportedLanguage(
      code: 'zh',
      nativeName: '中文 (简体)',
      englishName: 'Chinese',
      badge: 'ZH',
    ),
    SupportedLanguage(
      code: 'ja',
      nativeName: '日本語',
      englishName: 'Japanese',
      badge: 'JA',
    ),
    SupportedLanguage(
      code: 'ar',
      nativeName: 'العربية',
      englishName: 'Arabic',
      badge: 'AR',
    ),
  ];

  static final List<Locale> supportedLocales = supportedLanguages
      .map((lang) => Locale(lang.code))
      .toList(growable: false);

  LocaleCubit({SharedPreferences? prefs, Locale? initialLocale})
    : _prefs = prefs,
      super(initialLocale ?? _loadInitial(prefs));

  static Locale _loadInitial(SharedPreferences? prefs) {
    final stored = prefs?.getString(_prefKey);
    if (stored != null &&
        supportedLanguages.any((lang) => lang.code == stored)) {
      return Locale(stored);
    }
    return const Locale('tr');
  }

  static String nativeNameFor(String languageCode) {
    for (final lang in supportedLanguages) {
      if (lang.code == languageCode) return lang.nativeName;
    }
    return 'English';
  }

  Future<void> setLocale(Locale locale) async {
    emit(locale);
    await _prefs?.setString(_prefKey, locale.languageCode);
  }

  void toggleLanguage() {
    final currentIndex = supportedLanguages.indexWhere(
      (lang) => lang.code == state.languageCode,
    );
    final nextIndex = (currentIndex + 1) % supportedLanguages.length;
    setLocale(Locale(supportedLanguages[nextIndex].code));
  }
}
