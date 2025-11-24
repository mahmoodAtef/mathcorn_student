part of 'library_cubit.dart';

enum LibraryStatus {
  initial,
  loaded,
  adding,
  lectureAdded,
  lectureAlreadyExists,
  removing,
  lectureRemoved,
  failure,
}

extension LibraryStatusX on LibraryState {
  bool get isInitial => status == LibraryStatus.initial;

  bool get isLoaded => status == LibraryStatus.loaded;

  bool get isAdding => status == LibraryStatus.adding;

  bool get isLectureAdded => status == LibraryStatus.lectureAdded;

  bool get isLectureAlreadyExists =>
      status == LibraryStatus.lectureAlreadyExists;

  bool get isRemoving => status == LibraryStatus.removing;

  bool get isLectureRemoved => status == LibraryStatus.lectureRemoved;

  bool get isFailure => status == LibraryStatus.failure;

  bool get isProcessing => isAdding || isRemoving;

  bool get isEmpty => lectures.isEmpty;
}

class LibraryState extends Equatable {
  final List<Lecture> lectures;
  final LibraryStatus status;
  final Exception? exception;

  const LibraryState({
    this.lectures = const [],
    this.status = LibraryStatus.initial,
    this.exception,
  });

  LibraryState copyWith({
    List<Lecture>? lectures,
    LibraryStatus? status,
    Exception? exception,
  }) {
    return LibraryState(
      lectures: lectures ?? this.lectures,
      status: status ?? this.status,
      exception: exception,
    );
  }

  @override
  List<Object?> get props => [lectures, status, exception];
}
