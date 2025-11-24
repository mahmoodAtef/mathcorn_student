import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:math_corn/modules/auth/data/models/student_creation_form.dart';

import '../data/repositories/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthState());

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      await _authRepository.loginWithEmailAndPassword(email, password);
      emit(state.copyWith(status: AuthStatus.authenticated));
    } on Exception catch (error) {
      emit(state.copyWith(status: AuthStatus.exception, exception: error));
    }
  }

  Future<void> registerWithEmailAndPassword(
    StudentCreationForm studentCreationForm,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      await _authRepository.registerWithEmailAndPassword(studentCreationForm);
      emit(state.copyWith(status: AuthStatus.authenticated));
    } on Exception catch (error) {
      emit(state.copyWith(status: AuthStatus.exception, exception: error));
    }
  }

  Future<void> forgotPassword(String email) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      await _authRepository.forgotPassword(email);
      emit(state.copyWith(status: AuthStatus.forgotPassword));
    } on Exception catch (error) {
      emit(state.copyWith(status: AuthStatus.exception, exception: error));
    }
  }

  Future<void> logout() async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      await _authRepository.logout();
      emit(state.copyWith(status: AuthStatus.authenticated));
    } on Exception catch (error) {
      emit(state.copyWith(status: AuthStatus.exception, exception: error));
    }
  }
}
