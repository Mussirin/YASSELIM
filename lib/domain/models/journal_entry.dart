import 'package:equatable/equatable.dart';

import 'mood_type.dart';

/// Represents a private journal entry stored locally on the device.
class JournalEntry extends Equatable {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final MoodType? mood;
  final List<String> tags;
  final int scenicVariant;

  const JournalEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.mood,
    this.tags = const [],
    this.scenicVariant = 0,
  });

  int get characterCount => content.length;

  JournalEntry copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    MoodType? mood,
    bool clearMood = false,
    List<String>? tags,
    int? scenicVariant,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      mood: clearMood ? null : (mood ?? this.mood),
      tags: tags ?? this.tags,
      scenicVariant: scenicVariant ?? this.scenicVariant,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'mood': mood?.name,
    'tags': tags,
    'scenicVariant': scenicVariant,
  };

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    final created =
        DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now();
    final updated =
        DateTime.tryParse(json['updatedAt'] as String? ?? '') ?? created;
    return JournalEntry(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      createdAt: created,
      updatedAt: updated,
      mood: MoodType.fromString(json['mood'] as String?),
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          const [],
      scenicVariant: (json['scenicVariant'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    content,
    createdAt,
    updatedAt,
    mood,
    tags,
    scenicVariant,
  ];
}
