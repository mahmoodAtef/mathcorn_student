part of 'exam_cubit.dart';

enum ExamStatus { initial, loading, success, failure, submitted }

class ExamState extends Equatable {
  final Exam? exam;
  final int? totalPoints;
  final bool? isPassed;
  final Exception? exception;
  final ExamStatus status;

  const ExamState({
    this.exam,
    this.totalPoints,
    this.isPassed,
    this.exception,
    this.status = ExamStatus.initial,
  });

  ExamState copyWith({
    Exam? exam,
    int? totalPoints,
    bool? isPassed,
    Exception? exception,
    ExamStatus? status,
  }) {
    return ExamState(
      exam: exam ?? this.exam,
      totalPoints: totalPoints ?? this.totalPoints,
      isPassed: isPassed ?? this.isPassed,
      exception: exception ?? this.exception,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [exam, totalPoints, isPassed, exception, status];
}

extension ExamStateX on ExamState {
  bool get isInitial => status == ExamStatus.initial;

  bool get isLoading => status == ExamStatus.loading;

  bool get isSuccess => status == ExamStatus.success;

  bool get isFailure => status == ExamStatus.failure;

  bool get isSubmitted => status == ExamStatus.submitted;
}
