import 'package:equatable/equatable.dart';

class Question extends Equatable {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String? image;
  final int? points;

  const Question({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    this.image,
    this.points,
  });

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'] as String,
      question: map['question'] as String,
      options: (map['options'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      correctAnswerIndex: map['correctAnswerIndex'] as int,
      image: map['image'] as String?,
      points: map['points'] as int?,
    );
  }

  @override
  List<Object?> get props => [id];
}
