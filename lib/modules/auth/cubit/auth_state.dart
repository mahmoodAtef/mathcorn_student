part of 'auth_cubit.dart';

enum AuthStatus {
  initial,
  loading,
  forgotPassword,
  loggedOut,
  authenticated,
  exception,
}

extension AuthStatusX on AuthStatus {
  bool get isInitial => this == AuthStatus.initial;

  bool get isLoading => this == AuthStatus.loading;

  bool get isAuthenticated => this == AuthStatus.authenticated;

  bool get isForgotPassword => this == AuthStatus.forgotPassword;

  bool get isLoggedOut => this == AuthStatus.loggedOut;

  bool get isException => this == AuthStatus.exception;
}

final class AuthState extends Equatable {
  final AuthStatus status;
  final Exception? exception;

  const AuthState({this.status = AuthStatus.initial, this.exception});

  AuthState copyWith({AuthStatus? status, Exception? exception}) {
    return AuthState(
      status: status ?? this.status,
      exception: exception ?? this.exception,
    );
  }

  @override
  List<Object?> get props => [status, exception];
}
