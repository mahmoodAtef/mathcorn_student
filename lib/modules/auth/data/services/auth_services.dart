import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:math_corn/modules/auth/data/models/student_creation_form.dart';
import 'package:math_corn/modules/student/data/models/student.dart';

abstract class BaseAuthServices {
  Future<void> loginWithEmailAndPassword(String email, String password);

  Future<void> registerWithEmailAndPassword(StudentCreationForm creationForm);

  Future<void> logout();

  Future<void> forgotPassword(String email);
}

class AuthServices implements BaseAuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> loginWithEmailAndPassword(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> registerWithEmailAndPassword(
    StudentCreationForm creationForm,
  ) async {
    final userCredential = await _createUser(creationForm);
    if (userCredential.user != null) {
      await _createUserProfileAndUpdateStats(
        userCredential.user!.uid,
        creationForm,
      );
    }
  }

  Future<UserCredential> _createUser(StudentCreationForm creationForm) {
    return _auth.createUserWithEmailAndPassword(
      email: creationForm.email,
      password: creationForm.password,
    );
  }

  Future<void> _createUserProfileAndUpdateStats(
    String uid,
    StudentCreationForm creationForm,
  ) async {
    var batch = _firestore.batch();
    batch.set(
      _firestore.collection('users').doc(uid),
      StudentProfile.fromCreationForm(uid, creationForm).toJson(),
    );
    batch.set(_firestore.collection("statistiscs").doc("statistics"), {
      "totalUsers": FieldValue.increment(1),
      "newUsers": FieldValue.increment(1),
      creationForm.gradeId: FieldValue.increment(1),
    });
    await batch.commit();
  }

  @override
  Future<void> forgotPassword(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> logout() {
    return _auth.signOut();
  }
}
