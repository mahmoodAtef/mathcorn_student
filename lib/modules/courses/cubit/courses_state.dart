part of 'courses_cubit.dart';

enum CoursesStatus { initial, loading, success, failure }

extension CoursesStatusX on CoursesState {
  bool get isInitial => status == CoursesStatus.initial;

  bool get isLoading => status == CoursesStatus.loading;

  bool get isSuccess => status == CoursesStatus.success;

  bool get isFailure => status == CoursesStatus.failure;
}

class CoursesState extends Equatable {
  final CoursesStatus status;
  final List<Course>? courses;
  final Exception? exception;

  const CoursesState({
    this.status = CoursesStatus.initial,
    this.courses,
    this.exception,
  });

  CoursesState copyWith({
    CoursesStatus? status,
    List<Course>? courses,
    Exception? exception,
  }) {
    return CoursesState(
      status: status ?? this.status,
      courses: courses ?? this.courses,
      exception: exception ?? this.exception,
    );
  }

  @override
  List<Object?> get props => [status, courses, exception];
}
