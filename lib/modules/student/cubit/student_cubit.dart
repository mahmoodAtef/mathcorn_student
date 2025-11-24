import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:math_corn/modules/student/data/models/student.dart';
import 'package:math_corn/modules/student/data/repository/student_repository.dart';
import 'package:math_corn/modules/student/data/services/student_services.dart';

import '../../../core/services/dep_injection.dart';

part 'student_state.dart';

class StudentCubit extends Cubit<StudentState> {
  final StudentRepository repository;

  StudentCubit(this.repository)
    : super(StudentState(status: StudentStatus.initial));

  @override
  close() async {
    super.close();
    sl.resetLazySingleton<StudentRepository>();
    sl.resetLazySingleton<StudentServices>();
  }

  Future<void> getProfile({bool refresh = false}) async {
    if (!refresh && state.student != null) {
    } else {
      emit(state.copyWith(status: StudentStatus.loading));
      try {
        final student = await repository.getProfile();
        emit(
          state.copyWith(status: StudentStatus.gotProfile, student: student),
        );
      } catch (e) {
        Exception exception = e as Exception;
        emit(state.copyWith(status: StudentStatus.error, exception: exception));
      }
    }
  }

  Future<void> updateProfile({required StudentProfile student}) async {
    emit(state.copyWith(status: StudentStatus.loading));
    try {
      await repository.updateProfile(student: student);
      emit(state.copyWith(status: StudentStatus.gotProfile, student: student));
    } on Exception catch (e) {
      emit(state.copyWith(status: StudentStatus.error, exception: e));
    }
  }

  Future<void> deleteProfile({
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(status: StudentStatus.loading));
    try {
      await repository.deleteProfile(email: email, password: password);
      emit(state.copyWith(status: StudentStatus.gotProfile, student: null));
    } on Exception catch (e) {
      emit(state.copyWith(status: StudentStatus.error, exception: e));
    }
  }

  Future<void> addCourseToCart(String courseId) async {
    emit(state.copyWith(status: StudentStatus.loading));
    try {
      var updatedStudent = await repository.addCourseToCart(courseId);
      emit(
        state.copyWith(
          status: StudentStatus.gotProfile,
          student: updatedStudent,
        ),
      );
    } on Exception catch (e) {
      emit(state.copyWith(status: StudentStatus.error, exception: e));
    }
  }

  Future<void> removeCourseFromCart(String courseId) async {
    emit(state.copyWith(status: StudentStatus.loading));
    try {
      var updatedStudent = await repository.removeCourseFromCart(courseId);
      emit(
        state.copyWith(
          status: StudentStatus.gotProfile,
          student: updatedStudent,
        ),
      );
    } on Exception catch (e) {
      emit(state.copyWith(status: StudentStatus.error, exception: e));
    }
  }

  Future<void> addCoursesToOnGoing(List<String> coursesId) async {
    emit(state.copyWith(status: StudentStatus.loading));
    try {
      var updatedStudent = repository.addCoursesToOnGoing(coursesId);
      emit(
        state.copyWith(
          status: StudentStatus.gotProfile,
          student: updatedStudent,
        ),
      );
    } on Exception catch (e) {
      emit(state.copyWith(status: StudentStatus.error, exception: e));
    }
  }
}
