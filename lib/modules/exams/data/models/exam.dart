import 'package:equatable/equatable.dart';
import 'package:math_corn/modules/exams/data/models/question.dart';

class Exam extends Equatable {
  final String id;
  final String title;
  final String? description;
  final List<Question> questions;
  final int totalPoints;
  final int duration;

  const Exam({
    required this.id,
    required this.title,
    this.description,
    required this.duration,
    required this.questions,
    required this.totalPoints,
  });

  factory Exam.fromMap(Map<String, dynamic> map) {
    return Exam(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'],
      questions: List<Question>.from(
        map['questions'].map((x) => Question.fromMap(x)),
      ),
      duration: map['duration'] as int,
      totalPoints: map['totalPoints'] as int,
    );
  }

  @override
  List<Object?> get props => [id];
}
