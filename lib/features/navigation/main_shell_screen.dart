import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/app_colors.dart';
import '../../core/localization/app_translations.dart';
import '../../core/ui/twilight_scaffold.dart';
import '../../domain/models/journal_entry.dart';
import '../history/presentation/history_screen.dart';
import '../home/presentation/home_screen.dart';
import '../journal/presentation/entry_editor_screen.dart';
import '../letters/presentation/letters_screen.dart';
import '../security/bloc/security_cubit.dart';
import '../security/presentation/pin_lock_screen.dart';
import '../settings/presentation/settings_screen.dart';
import '../statistics/presentation/statistics_screen.dart';

/// Main 5-tab bottom navigation shell for YASSELIM.
class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _currentIndex = 0;

  void _openEditor({
    JournalEntry? entry,
    String? initialPrompt,
    String? initialContent,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => EntryEditorScreen(
          existingEntry: entry,
          initialPrompt: initialPrompt,
          initialContent: initialContent,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final securityState = context.watch<SecurityCubit>().state;
    if (securityState.isPinEnabled && securityState.isLocked) {
      return const PinLockScreen();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pages = <Widget>[
      HomeScreen(
        onOpenEditor: _openEditor,
        onViewAllHistory: () => setState(() => _currentIndex = 1),
        onOpenLetters: () => setState(() => _currentIndex = 2),
      ),
      HistoryScreen(onEditEntry: (entry) => _openEditor(entry: entry)),
      const LettersScreen(),
      const StatisticsScreen(),
      const SettingsScreen(),
    ];

    return TwilightScaffold(
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkSurface.withValues(alpha: 0.94)
              : AppColors.lightSurface.withValues(alpha: 0.96),
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: isDark
                ? AppColors.brightLavender
                : AppColors.lightPrimary,
            unselectedItemColor: isDark
                ? AppColors.darkMuted
                : AppColors.lightMuted,
            selectedFontSize: 11.5,
            unselectedFontSize: 11,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home_rounded),
                label: AppTranslations.tr(context, 'nav_home'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.auto_stories_rounded),
                label: AppTranslations.tr(context, 'nav_history'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.mail_outline_rounded),
                label: AppTranslations.tr(context, 'nav_letters'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.bar_chart_rounded),
                label: AppTranslations.tr(context, 'nav_stats'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.settings_rounded),
                label: AppTranslations.tr(context, 'nav_settings'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
