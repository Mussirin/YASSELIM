import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages English ('en') and Turkish ('tr') app locale with local persistence.
class LocaleCubit extends Cubit<Locale> {
  static const String _prefKey = 'yasselim_locale_code';
  final SharedPreferences? _prefs;

  LocaleCubit({SharedPreferences? prefs, Locale? initialLocale})
    : _prefs = prefs,
      super(initialLocale ?? _loadInitial(prefs));

  static Locale _loadInitial(SharedPreferences? prefs) {
    final stored = prefs?.getString(_prefKey);
    if (stored == 'en') return const Locale('en');
    if (stored == 'tr') return const Locale('tr');
    return const Locale('tr');
  }

  Future<void> setLocale(Locale locale) async {
    emit(locale);
    await _prefs?.setString(_prefKey, locale.languageCode);
  }

  void toggleLanguage() {
    final next = state.languageCode == 'tr'
        ? const Locale('en')
        : const Locale('tr');
    setLocale(next);
  }
}
