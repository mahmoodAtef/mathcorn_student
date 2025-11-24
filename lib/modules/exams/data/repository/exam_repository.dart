import 'package:math_corn/modules/exams/data/models/exam.dart';
import 'package:math_corn/modules/exams/data/services/exam_services.dart';

class ExamRepository {
  final ExamServices _examServices;

  ExamRepository(this._examServices);

  Future<Exam> getExam(String examId) async {
    return _examServices.getExam(examId);
  }
}
