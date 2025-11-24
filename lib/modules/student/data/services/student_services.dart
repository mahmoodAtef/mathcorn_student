import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:math_corn/modules/student/data/models/student.dart';

abstract class BaseStudentServices {
  Future<StudentProfile> getProfile();

  Future<void> updateProfile(StudentProfile student);

  Future<void> deleteProfile({required String email, required String password});

  Future<void> addCourseToCart(String courseId);

  Future<void> removeCourseFromCart(String courseId);
}

class StudentServices extends BaseStudentServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<StudentProfile> getProfile() async {
    String uid = _auth.currentUser!.uid;
    DocumentSnapshot snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .get();
    Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;
    return StudentProfile.fromJson(data);
  }

  @override
  Future<void> updateProfile(StudentProfile student) async {
    await _firestore
        .collection('users')
        .doc(student.uid)
        .update(student.toJson());
  }

  @override
  Future<void> deleteProfile({
    required String email,
    required String password,
  }) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    Future.wait([
      _firestore.collection('users').doc(_auth.currentUser!.uid).delete(),
      _auth.currentUser!.delete(),
    ]).catchError((error) => throw error);

    await _auth.signOut();
  }

  @override
  Future<void> addCourseToCart(String courseId) async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      'cart': FieldValue.arrayUnion([courseId]),
    });
  }

  @override
  Future<void> removeCourseFromCart(String courseId) async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      'cart': FieldValue.arrayRemove([courseId]),
    });
  }
}
