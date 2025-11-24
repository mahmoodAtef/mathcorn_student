import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:math_corn/modules/courses/data/models/course.dart';
import 'package:math_corn/modules/courses/data/reposiory/courses_repository.dart';
import 'package:math_corn/modules/courses/data/serives/courses_services.dart';

import '../../../core/services/dep_injection.dart';

part 'courses_state.dart';

class CoursesCubit extends Cubit<CoursesState> {
  final CoursesRepository repository;

  CoursesCubit(this.repository) : super(CoursesState());

  @override
  @override
  close() async {
    super.close();
    sl.resetLazySingleton<CoursesRepository>();
    sl.resetLazySingleton<CoursesServices>();
  }

  Future<void> getCourses({
    bool forceRefresh = false,
    required String grade,
  }) async {
    if (state.isInitial || forceRefresh) {
      emit(state.copyWith(status: CoursesStatus.loading));
      try {
        final courses = await repository.getCourses(
          forceRefresh: forceRefresh,
          grade: grade,
        );
        emit(state.copyWith(status: CoursesStatus.success, courses: courses));
      } on Exception catch (e) {
        emit(state.copyWith(status: CoursesStatus.failure, exception: e));
      }
    }
  }
}
