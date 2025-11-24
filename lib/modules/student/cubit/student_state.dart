part of 'student_cubit.dart';

enum StudentStatus { initial, loading, gotProfile, error }

class StudentState extends Equatable {
  final StudentProfile? student;
  final Exception? exception;
  final StudentStatus status;
  const StudentState({
    this.student,
    this.exception,
    this.status = StudentStatus.initial,
  });

  StudentState copyWith({
    StudentProfile? student,
    Exception? exception,
    StudentStatus? status,
  }) {
    return StudentState(
      student: student ?? this.student,
      exception: exception ?? this.exception,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [student, exception, status];
}

extension StudentStatusX on StudentState {
  bool get isInitial => status == StudentStatus.initial;
  bool get isLoading => status == StudentStatus.loading;
  bool get isGotProfile => status == StudentStatus.gotProfile;
  bool get isError => status == StudentStatus.error;
}
