abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final bool isResend;
  
  AuthSuccess({this.isResend = false});
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class AuthSignedOut extends AuthState {}