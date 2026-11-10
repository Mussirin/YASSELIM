import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

/// The 8 core moods defined in the YASSELIM specification.
enum MoodType {
  happy,
  calm,
  sad,
  anxious,
  angry,
  hopeful,
  grateful,
  neutral;

  Color get color => switch (this) {
    MoodType.happy => AppColors.moodHappy,
    MoodType.calm => AppColors.moodCalm,
    MoodType.sad => AppColors.moodSad,
    MoodType.anxious => AppColors.moodAnxious,
    MoodType.angry => AppColors.moodAngry,
    MoodType.hopeful => AppColors.moodHopeful,
    MoodType.grateful => AppColors.moodGrateful,
    MoodType.neutral => AppColors.moodNeutral,
  };

  String get translationKey => 'mood_$name';

  static MoodType? fromString(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    for (final mood in MoodType.values) {
      if (mood.name == raw) return mood;
    }
    return null;
  }
}
