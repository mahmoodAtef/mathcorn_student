import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:math_corn/modules/courses/data/models/lecture.dart';

part 'library_state.dart';

class LibraryCubit extends HydratedCubit<LibraryState> {
  LibraryCubit() : super(const LibraryState());

  void getLibrary() {
    // No need for loading state since we're using hydrated_bloc
    // The lectures will be automatically loaded from cache
    emit(state.copyWith(status: LibraryStatus.loaded));
  }

  void addLecture(Lecture lecture) {
    // Check if lecture already exists to avoid duplicates
    if (state.lectures.any((l) => l.id == lecture.id)) {
      emit(state.copyWith(status: LibraryStatus.lectureAlreadyExists));
      return;
    }

    emit(state.copyWith(status: LibraryStatus.adding));

    try {
      final updatedLectures = List<Lecture>.from(state.lectures)..add(lecture);
      emit(
        state.copyWith(
          lectures: updatedLectures,
          status: LibraryStatus.lectureAdded,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: LibraryStatus.failure,
          exception: e is Exception ? e : Exception(e.toString()),
        ),
      );
    }
  }

  void removeLecture(Lecture lecture) {
    emit(state.copyWith(status: LibraryStatus.removing));

    try {
      final updatedLectures = List<Lecture>.from(state.lectures)
        ..removeWhere((l) => l.id == lecture.id);

      emit(
        state.copyWith(
          lectures: updatedLectures,
          status: LibraryStatus.lectureRemoved,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: LibraryStatus.failure,
          exception: e is Exception ? e : Exception(e.toString()),
        ),
      );
    }
  }

  @override
  LibraryState? fromJson(Map<String, dynamic> json) {
    try {
      return LibraryState(
        lectures: List<Lecture>.from(
          (json['lectures'] as List?)?.map((x) => Lecture.fromJson(x)) ?? [],
        ),
        status: LibraryStatus.loaded,
      );
    } catch (e) {
      // Return initial state if deserialization fails
      return const LibraryState();
    }
  }

  @override
  Map<String, dynamic>? toJson(LibraryState state) {
    return {'lectures': state.lectures.map((e) => e.toJson()).toList()};
  }
}
