import 'package:math_corn/modules/courses/data/models/course.dart';
import 'package:math_corn/modules/courses/data/serives/courses_services.dart';

class CoursesRepository {
  final CoursesServices _coursesServices;

  CoursesRepository(this._coursesServices);

  List<Course>? courses;

  Future<List<Course>> getCourses({
    bool forceRefresh = false,
    required String grade,
  }) async {
    if (courses != null && !forceRefresh) {
      return courses!;
    }
    courses = await _coursesServices.getCourses(grade: grade);
    return courses!;
  }
}
