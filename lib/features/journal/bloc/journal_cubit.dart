import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/journal_repository.dart';
import '../../../domain/models/journal_entry.dart';
import '../../../domain/models/mood_type.dart';
import '../../../domain/models/unsent_letter.dart';
import 'journal_state.dart';

/// Manages journal entries, unsent letters, search/filter state, and statistics.
class JournalCubit extends Cubit<JournalState> {
  final JournalRepository repository;

  JournalCubit({required this.repository}) : super(const JournalState()) {
    loadAll();
  }

  void loadAll() {
    emit(
      state.copyWith(
        entries: repository.loadEntries(),
        letters: repository.loadLetters(),
      ),
    );
  }

  Future<void> saveEntry(JournalEntry entry) async {
    final updated = await repository.saveEntry(entry);
    emit(state.copyWith(entries: updated));
  }

  Future<void> deleteEntry(String id) async {
    final updated = await repository.deleteEntry(id);
    emit(state.copyWith(entries: updated));
  }

  Future<void> saveLetter(UnsentLetter letter) async {
    final updated = await repository.saveLetter(letter);
    emit(state.copyWith(letters: updated));
  }

  Future<void> deleteLetter(String id) async {
    final updated = await repository.deleteLetter(id);
    emit(state.copyWith(letters: updated));
  }

  void setSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void setDateFilter(DateFilter filter) {
    emit(state.copyWith(dateFilter: filter));
  }

  void setMoodFilter(MoodType? mood) {
    emit(state.copyWith(moodFilter: mood, clearMoodFilter: mood == null));
  }

  void setStatsPeriod(String period) {
    emit(state.copyWith(statsPeriod: period));
  }

  String exportJson({String lang = 'tr'}) =>
      repository.exportAsBookText(lang: lang);

  Future<void> clearAllData() async {
    await repository.deleteAllData();
    emit(state.copyWith(entries: const [], letters: const []));
  }
}
