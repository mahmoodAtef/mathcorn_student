import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:math_corn/modules/exams/data/models/exam.dart';

class ExamServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Exam> getExam(String examId) async {
    final examSnapshot = await _firestore.collection('exams').doc(examId).get();
    return Exam.fromMap(examSnapshot.data()!);
  }
}
