import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neurea/Service/Auth_Service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      await AuthService.signIn(email: email, password: password);
      emit(AuthSuccess(isResend: false));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> loginWithGoogle() async {
    emit(AuthLoading());
    try {
      await AuthService.signInWithGoogle();
      emit(AuthSuccess(isResend: false));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String gender,
    required String phone,
  }) async {
    emit(AuthLoading());
    try {
      await AuthService.signUp(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        gender: gender,
        phone: phone,
      );
      emit(AuthSuccess(isResend: false));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> forgotPassword(String email) async {
    emit(AuthLoading());
    try {
      await AuthService.resetPassword(email);
      emit(AuthSuccess(isResend: false));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> resendOTP({required String email}) async {
    emit(AuthLoading());
    try { 
      await AuthService.resendOTP(email: email);
      emit(AuthSuccess(isResend: true));  
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> verifyOTP({required String email, required String token}) async {
    emit(AuthLoading());
    try {
      await AuthService.verifyOTP(email: email, token: token);
      emit(AuthSuccess(isResend: false));  
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> updatePassword(String newPassword) async {
    emit(AuthLoading());
    try {
      await AuthService.updatePassword(newPassword);
      emit(AuthSuccess(isResend: false));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    try {
      await AuthService.signOut();
      emit(AuthSignedOut());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}