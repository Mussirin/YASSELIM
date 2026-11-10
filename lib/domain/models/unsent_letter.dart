import 'package:equatable/equatable.dart';

/// Represents a private unsent letter stored locally on the device.
class UnsentLetter extends Equatable {
  final String id;
  final String recipient;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UnsentLetter({
    required this.id,
    this.recipient = '',
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  UnsentLetter copyWith({
    String? id,
    String? recipient,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UnsentLetter(
      id: id ?? this.id,
      recipient: recipient ?? this.recipient,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'recipient': recipient,
    'title': title,
    'content': content,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory UnsentLetter.fromJson(Map<String, dynamic> json) {
    final created =
        DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now();
    final updated =
        DateTime.tryParse(json['updatedAt'] as String? ?? '') ?? created;
    return UnsentLetter(
      id: json['id'] as String? ?? '',
      recipient: json['recipient'] as String? ?? '',
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      createdAt: created,
      updatedAt: updated,
    );
  }

  @override
  List<Object?> get props => [
    id,
    recipient,
    title,
    content,
    createdAt,
    updatedAt,
  ];
}
