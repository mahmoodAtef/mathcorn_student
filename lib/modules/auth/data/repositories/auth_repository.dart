import 'package:math_corn/modules/auth/data/services/auth_services.dart';

import '../models/student_creation_form.dart';

class AuthRepository {
  final AuthServices _authServices;

  AuthRepository(this._authServices);

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    await _authServices.loginWithEmailAndPassword(email, password);
  }

  Future<void> forgotPassword(String email) async {
    await _authServices.forgotPassword(email);
  }

  Future<void> logout() async {
    await _authServices.logout();
  }

  Future<void> registerWithEmailAndPassword(
    StudentCreationForm creationForm,
  ) async {
    await _authServices.registerWithEmailAndPassword(creationForm);
  }
}
