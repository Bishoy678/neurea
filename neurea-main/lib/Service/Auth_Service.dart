import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  AuthService._();

  static final _db = Supabase.instance.client;

  static const _googleClientId =
      '545653821238-32ahgf38pode9j1t396hdfq3pk2eomfu.apps.googleusercontent.com';

  static Future<String> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String gender,
    required String phone,
  }) async {
    final existingPhone = await _db
        .from('profiles')
        .select('id')
        .eq('phone', phone)
        .maybeSingle();

    if (existingPhone != null) {
      throw Exception('This phone number is already registered');
    }

    final res = await _db.auth.signUp(email: email, password: password);
    if (res.user == null) throw Exception('Sign up failed');

    await _db.from('profiles').upsert({
      'id': res.user!.id,
      'first_name': firstName,
      'last_name': lastName,
      'gender': gender,
      'phone': phone,
    });

    await _db.auth.signInWithPassword(email: email, password: password);

    return res.user!.id;
  }

  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _db.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final profile = await _db
        .from('profiles')
        .select('id')
        .eq('id', response.user!.id)
        .maybeSingle();

    if (profile == null) {
      await _db.auth.signOut();
      throw Exception('This email is not registered');
    }

    return response;
  }

  static Future<AuthResponse> signInWithGoogle() async {
  
    await _createGoogleSignIn().signOut();

    final googleUser = await _createGoogleSignIn().signIn();
    if (googleUser == null) throw Exception('Google sign-in cancelled');

    final auth = await googleUser.authentication;
    if (auth.idToken == null) throw Exception('No ID token received');

    final response = await _db.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: auth.idToken!,
      accessToken: auth.accessToken,
    );

  
    final profile = await _db
        .from('profiles')
        .select('id')
        .eq('id', response.user!.id)
        .maybeSingle();

    if (profile == null) {
      await _db.auth.signOut();
      await _createGoogleSignIn().signOut();
      throw Exception('This Google account is not registered. Please sign up first.');
    }

    return response;
  }

  static Future<void> resetPassword(String email) =>
      _db.auth.resetPasswordForEmail(email);

  static Future<void> resendOTP({required String email}) async {
    try {
      await _db.auth.resetPasswordForEmail(email);
    } catch (e) {
      throw Exception('Failed to resend OTP: ${e.toString()}');
    }
  }

  static Future<AuthResponse> verifyOTP({
    required String email,
    required String token,
  }) => _db.auth.verifyOTP(email: email, token: token, type: OtpType.recovery);

  static Future<UserResponse> updatePassword(String newPassword) =>
      _db.auth.updateUser(UserAttributes(password: newPassword));

  static Future<void> signOut() => _db.auth.signOut();

  static GoogleSignIn _createGoogleSignIn() => GoogleSignIn(
    serverClientId: _googleClientId,
    forceCodeForRefreshToken: true,
  );
}