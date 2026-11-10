import 'package:equatable/equatable.dart';

/// Original multi-language writing prompt for daily reflection.
class WritingPrompt extends Equatable {
  final String id;
  final Map<String, String> texts;
  final Map<String, String> categories;

  const WritingPrompt({
    required this.id,
    required this.texts,
    required this.categories,
  });

  String get textEn => texts['en'] ?? '';
  String get textTr => texts['tr'] ?? '';
  String get categoryEn => categories['en'] ?? '';
  String get categoryTr => categories['tr'] ?? '';

  String textFor(String languageCode) =>
      texts[languageCode] ?? texts['en'] ?? '';

  String categoryFor(String languageCode) =>
      categories[languageCode] ?? categories['en'] ?? '';

  @override
  List<Object?> get props => [id, texts, categories];
}
