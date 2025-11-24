import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:math_corn/core/debugging/loggable.dart';
import 'package:math_corn/modules/exams/data/models/exam.dart';
import 'package:math_corn/modules/exams/data/repository/exam_repository.dart';

part 'exam_state.dart';

class ExamCubit extends Cubit<ExamState> {
  final ExamRepository _repository;

  ExamCubit(this._repository) : super(const ExamState());

  Future<void> getExam(String examId) async {
    logInfo(examId);
    emit(state.copyWith(status: ExamStatus.loading));
    try {
      final exam = await _repository.getExam(examId);
      logInfo(exam.toString());
      emit(state.copyWith(exam: exam, status: ExamStatus.success));
    } on Exception catch (e) {
      logError(e.toString());
      emit(state.copyWith(exception: e, status: ExamStatus.failure));
    }
  }

  Future<void> submitExam(List<int> answers) async {
    Exam exam = state.exam!;
    int userTotalPoints = 0;
    for (int i = 0; i < exam.questions.length; i++) {
      if (answers[i] == exam.questions[i].correctAnswerIndex) {
        userTotalPoints += exam.questions[i].points ?? 1;
      }
    }
    bool isPassed = userTotalPoints >= exam.totalPoints / 2;
    emit(
      state.copyWith(
        status: ExamStatus.submitted,
        isPassed: isPassed,
        totalPoints: userTotalPoints,
      ),
    );
  }
}
