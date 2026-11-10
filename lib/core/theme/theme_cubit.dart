import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages Dark (default Peaceful Twilight), Light, and System theme modes.
class ThemeCubit extends Cubit<ThemeMode> {
  static const String _prefKey = 'yasselim_theme_mode';
  final SharedPreferences? _prefs;

  ThemeCubit({SharedPreferences? prefs})
    : _prefs = prefs,
      super(_loadInitial(prefs));

  static ThemeMode _loadInitial(SharedPreferences? prefs) {
    final stored = prefs?.getString(_prefKey);
    if (stored == 'light') return ThemeMode.light;
    if (stored == 'system') return ThemeMode.system;
    return ThemeMode.dark;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    emit(mode);
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.system => 'system',
      ThemeMode.dark => 'dark',
    };
    await _prefs?.setString(_prefKey, value);
  }

  void toggleDarkLight() {
    setThemeMode(state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
  }
}
