import 'package:equatable/equatable.dart';

import '../../../domain/models/journal_entry.dart';
import '../../../domain/models/mood_type.dart';
import '../../../domain/models/unsent_letter.dart';

/// Date filtering options for the journal list and search view.
enum DateFilter { all, today, week, month }

/// Immutable state for journal entries, unsent letters, filters, and statistics.
class JournalState extends Equatable {
  final List<JournalEntry> entries;
  final List<UnsentLetter> letters;
  final String searchQuery;
  final DateFilter dateFilter;
  final MoodType? moodFilter;
  final String statsPeriod;

  const JournalState({
    this.entries = const [],
    this.letters = const [],
    this.searchQuery = '',
    this.dateFilter = DateFilter.all,
    this.moodFilter,
    this.statsPeriod = 'month',
  });

  JournalState copyWith({
    List<JournalEntry>? entries,
    List<UnsentLetter>? letters,
    String? searchQuery,
    DateFilter? dateFilter,
    MoodType? moodFilter,
    bool clearMoodFilter = false,
    String? statsPeriod,
  }) {
    return JournalState(
      entries: entries ?? this.entries,
      letters: letters ?? this.letters,
      searchQuery: searchQuery ?? this.searchQuery,
      dateFilter: dateFilter ?? this.dateFilter,
      moodFilter: clearMoodFilter ? null : (moodFilter ?? this.moodFilter),
      statsPeriod: statsPeriod ?? this.statsPeriod,
    );
  }

  List<JournalEntry> get filteredEntries {
    final now = DateTime.now();
    final query = searchQuery.trim().toLowerCase();

    return entries.where((entry) {
      if (moodFilter != null && entry.mood != moodFilter) return false;

      if (dateFilter != DateFilter.all) {
        final diff = now.difference(entry.createdAt);
        final sameDay =
            entry.createdAt.year == now.year &&
            entry.createdAt.month == now.month &&
            entry.createdAt.day == now.day;
        if (dateFilter == DateFilter.today && !sameDay) return false;
        if (dateFilter == DateFilter.week && diff.inDays > 7) return false;
        if (dateFilter == DateFilter.month && diff.inDays > 30) return false;
      }

      if (query.isNotEmpty) {
        final matchesTitle = entry.title.toLowerCase().contains(query);
        final matchesContent = entry.content.toLowerCase().contains(query);
        final matchesTag = entry.tags.any(
          (t) => t.toLowerCase().contains(query),
        );
        if (!matchesTitle && !matchesContent && !matchesTag) return false;
      }
      return true;
    }).toList();
  }

  int get currentStreak {
    if (entries.isEmpty) return 0;
    final uniqueDays =
        entries
            .map(
              (e) => DateTime(
                e.createdAt.year,
                e.createdAt.month,
                e.createdAt.day,
              ),
            )
            .toSet()
            .toList()
          ..sort((a, b) => b.compareTo(a));

    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    final diffFromToday = today.difference(uniqueDays.first).inDays;
    if (diffFromToday > 1) return 0;

    var streak = 1;
    for (var i = 0; i < uniqueDays.length - 1; i++) {
      if (uniqueDays[i].difference(uniqueDays[i + 1]).inDays == 1) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }

  List<JournalEntry> get statsEntries {
    final now = DateTime.now();
    if (statsPeriod == 'month') {
      return entries
          .where((e) => now.difference(e.createdAt).inDays <= 30)
          .toList();
    }
    if (statsPeriod == 'year') {
      return entries
          .where((e) => now.difference(e.createdAt).inDays <= 365)
          .toList();
    }
    return entries;
  }

  int get totalCharacters =>
      statsEntries.fold(0, (sum, e) => sum + e.characterCount);

  MoodType? get mostCommonMood {
    final counts = <MoodType, int>{};
    for (final entry in statsEntries) {
      final mood = entry.mood;
      if (mood != null) counts[mood] = (counts[mood] ?? 0) + 1;
    }
    if (counts.isEmpty) return null;
    return counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }

  int get mostCommonMoodPercent {
    final dominant = mostCommonMood;
    if (dominant == null) return 0;
    final tagged = statsEntries.where((e) => e.mood != null).toList();
    if (tagged.isEmpty) return 0;
    final matches = tagged.where((e) => e.mood == dominant).length;
    return ((matches / tagged.length) * 100).round();
  }

  List<int> get weeklyActivityCounts {
    final counts = List<int>.filled(7, 0);
    for (final entry in statsEntries) {
      final index = (entry.createdAt.weekday - 1).clamp(0, 6);
      counts[index]++;
    }
    return counts;
  }

  @override
  List<Object?> get props => [
    entries,
    letters,
    searchQuery,
    dateFilter,
    moodFilter,
    statsPeriod,
  ];
}
