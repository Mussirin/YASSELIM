import 'package:equatable/equatable.dart';

/// Original bilingual writing prompt for daily reflection.
class WritingPrompt extends Equatable {
  final String id;
  final String textEn;
  final String textTr;
  final String categoryEn;
  final String categoryTr;

  const WritingPrompt({
    required this.id,
    required this.textEn,
    required this.textTr,
    required this.categoryEn,
    required this.categoryTr,
  });

  String textFor(String languageCode) => languageCode == 'tr' ? textTr : textEn;

  String categoryFor(String languageCode) =>
      languageCode == 'tr' ? categoryTr : categoryEn;

  @override
  List<Object?> get props => [id, textEn, textTr, categoryEn, categoryTr];
}
