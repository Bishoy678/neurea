abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final bool isResend;
  final String? message;
  
  AuthSuccess({this.isResend = false, this.message});
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class AuthSignedOut extends AuthState {}