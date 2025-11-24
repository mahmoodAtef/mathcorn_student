import 'package:math_corn/modules/student/data/models/student.dart';
import 'package:math_corn/modules/student/data/services/student_services.dart';

class StudentRepository {
  final StudentServices services;

  StudentRepository(this.services);

  StudentProfile? student;

  Future<StudentProfile> getProfile({bool refresh = false}) async {
    if (student == null || refresh) {
      student = await services.getProfile();
    }
    return student!;
  }

  Future<void> updateProfile({required StudentProfile student}) async {
    await services.updateProfile(student);
    this.student = student;
  }

  Future<void> deleteProfile({
    required String email,
    required String password,
  }) async {
    await services.deleteProfile(email: email, password: password);

    student = null;
  }

  Future<StudentProfile> addCourseToCart(String courseId) async {
    await services.addCourseToCart(courseId);
    List<String> cart = student?.cart ?? [];
    cart.add(courseId);
    student = student?.copyWith(cart: cart);
    return student!;
  }

  Future<StudentProfile> removeCourseFromCart(String courseId) async {
    await services.removeCourseFromCart(courseId);
    List<String> cart = student?.cart ?? [];
    cart.remove(courseId);
    student = student?.copyWith(cart: cart);
    return student!;
  }

  StudentProfile addCoursesToOnGoing(List<String> coursesId) {
    List<String> onGoing = student?.onGoing ?? [];
    onGoing.addAll(coursesId);
    student = student?.copyWith(onGoing: onGoing, cart: []);
    return student!;
  }
}
