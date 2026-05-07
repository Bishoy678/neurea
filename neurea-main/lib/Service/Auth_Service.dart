// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class AuthService {
//   AuthService._();

//   static final _db = Supabase.instance.client;

//   static const _googleClientId =
//       '545653821238-32ahgf38pode9j1t396hdfq3pk2eomfu.apps.googleusercontent.com';

//   static Future<String> signUp({
//     required String email,
//     required String password,
//     required String firstName,
//     required String lastName,
//     required String gender,
//     required String phone,
//   }) async {
//     final existingPhone = await _db
//         .from('profiles')
//         .select('id')
//         .eq('phone', phone)
//         .maybeSingle();

//     if (existingPhone != null) {
//       throw Exception('This phone number is already registered');
//     }

//     final res = await _db.auth.signUp(email: email, password: password);
//     if (res.user == null) throw Exception('Sign up failed');

//     await _db.from('profiles').upsert({
//       'id': res.user!.id,
//       'first_name': firstName,
//       'last_name': lastName,
//       'gender': gender,
//       'phone': phone,
//       'email': email,
//     });

//     await _db.auth.signInWithPassword(email: email, password: password);

//     return res.user!.id;
//   }

//   static Future<AuthResponse> signIn({
//     required String email,
//     required String password,
//   }) async {
//     final response = await _db.auth.signInWithPassword(
//       email: email,
//       password: password,
//     );

//     final profile = await _db
//         .from('profiles')
//         .select('id')
//         .eq('id', response.user!.id)
//         .maybeSingle();

//     if (profile == null) {
//       await _db.auth.signOut();
//       throw Exception('This email is not registered');
//     }

//     return response;
//   }

//   static Future<AuthResponse> signInWithGoogle() async {
//     await _createGoogleSignIn().signOut();

//     final googleUser = await _createGoogleSignIn().signIn();
//     if (googleUser == null) throw Exception('Google sign-in cancelled');

//     final auth = await googleUser.authentication;
//     if (auth.idToken == null) throw Exception('No ID token received');

//     final response = await _db.auth.signInWithIdToken(
//       provider: OAuthProvider.google,
//       idToken: auth.idToken!,
//       accessToken: auth.accessToken,
//     );

//     final profile = await _db
//         .from('profiles')
//         .select('id')
//         .eq('id', response.user!.id)
//         .maybeSingle();

//     if (profile == null) {
//       await _db.from('profiles').upsert({
//         'id': response.user!.id,
//         'email': googleUser.email,
//         'first_name': googleUser.displayName?.split(' ').first ?? '',
//         'last_name': googleUser.displayName?.split(' ').last ?? '',
//       });
//     } else {
//       await _db
//           .from('profiles')
//           .update({'email': googleUser.email})
//           .eq('id', response.user!.id);
//     }

//     return response;
//   }

//   static Future<void> resetPassword(String email) async {
//     final user = await _db
//         .from('profiles')
//         .select('id')
//         .eq('email', email)
//         .maybeSingle();

//     if (user == null) {
//       throw Exception('This email is not registered');
//     }

//     await _db.auth.resetPasswordForEmail(email);
//   }

//   static Future<void> resendOTP({required String email}) async {
//     try {
//       await _db.auth.resetPasswordForEmail(email);
//     } catch (e) {
//       throw Exception('Failed to resend OTP: ${e.toString()}');
//     }
//   }

//   static Future<AuthResponse> verifyOTP({
//     required String email,
//     required String token,
//   }) => _db.auth.verifyOTP(email: email, token: token, type: OtpType.recovery);

//   static Future<UserResponse> updatePassword(String newPassword) async {
//     final response = await _db.auth.updateUser(
//       UserAttributes(password: newPassword),
//     );

//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('saved_password');

//     return response;
//   }

//   static Future<void> signOut() async {
//     try {

//       final prefs = await SharedPreferences.getInstance();
//       await prefs.remove('saved_email');
//       await prefs.remove('saved_password');

//       final user = _db.auth.currentUser;
//       if (user != null) {
//         await _db.auth.signOut();
//       }
//     } catch (e) {
//       print('Sign out error: $e');

//       try {
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.remove('saved_email');
//         await prefs.remove('saved_password');
//       } catch (innerError) {
//         print('Failed to clear preferences: $innerError');
//       }
//       rethrow;
//     }
//   }

//   static GoogleSignIn _createGoogleSignIn() => GoogleSignIn(
//     serverClientId: _googleClientId,
//     forceCodeForRefreshToken: true,
//   );
// }
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  AuthService._();

  static final _db = Supabase.instance.client;

  static const _googleClientId =
      '545653821238-32ahgf38pode9j1t396hdfq3pk2eomfu.apps.googleusercontent.com';

  static const String _djangoLoginUrl =
      'https://djangograduationprojectfinalversion-production.up.railway.app/api/login/';
  static const String _djangoChatbotUrl =
      'https://djangograduationprojectfinalversion-production.up.railway.app/api/chatbot/';

  static Future<String?> _getDjangoToken({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_djangoLoginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String accessToken = data['access'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('django_access_token', accessToken);

        print('✅ Django Token obtained successfully');
        return accessToken;
      } else {
        print('⚠️ Failed to get Django token: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('❌ Error getting Django token: $e');
      return null;
    }
  }

  static Future<String?> getStoredDjangoToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('django_access_token');
  }

  static Future<void> _clearDjangoToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('django_access_token');
  }

  static Future<String> sendChatMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse(_djangoChatbotUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message': message}),
      );

      print('📡 Chat API Status: ${response.statusCode}');
      print('📦 Chat API Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['reply'] ??
            data['response'] ??
            data['bot_response'] ??
            data['message'] ??
            'I understand. Could you tell me more?';
      } else {
        return '⚠️ Error: ${response.statusCode}. Please try again.';
      }
    } catch (e) {
      return '⚠️ Connection error. Please check your internet.';
    }
  }

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
      'email': email,
    });

    await _db.auth.signInWithPassword(email: email, password: password);

    await _getDjangoToken(email: email, password: password);

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

    await _getDjangoToken(email: email, password: password);
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
      await _db.from('profiles').upsert({
        'id': response.user!.id,
        'email': googleUser.email,
        'first_name': googleUser.displayName?.split(' ').first ?? '',
        'last_name': googleUser.displayName?.split(' ').last ?? '',
      });
    } else {
      await _db
          .from('profiles')
          .update({'email': googleUser.email})
          .eq('id', response.user!.id);
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedPassword = prefs.getString('saved_password');
      if (savedPassword != null) {
        await _getDjangoToken(email: googleUser.email, password: savedPassword);
      }
    } catch (e) {
      print('⚠️ Could not get Django token for Google user: $e');
    }

    return response;
  }

  static Future<void> resetPassword(String email) async {
    final user = await _db
        .from('profiles')
        .select('id')
        .eq('email', email)
        .maybeSingle();

    if (user == null) {
      throw Exception('This email is not registered');
    }

    await _db.auth.resetPasswordForEmail(email);
  }

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

  static Future<UserResponse> updatePassword(String newPassword) async {
    final response = await _db.auth.updateUser(
      UserAttributes(password: newPassword),
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('saved_password');

    return response;
  }

  static Future<void> signOut() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('saved_email');
      await prefs.remove('saved_password');
      await prefs.remove('django_access_token');

      final user = _db.auth.currentUser;
      if (user != null) {
        await _db.auth.signOut();
      }
    } catch (e) {
      print('Sign out error: $e');
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('saved_email');
        await prefs.remove('saved_password');
        await prefs.remove('django_access_token');
      } catch (innerError) {
        print('Failed to clear preferences: $innerError');
      }
      rethrow;
    }
  }

  static GoogleSignIn _createGoogleSignIn() => GoogleSignIn(
    serverClientId: _googleClientId,
    forceCodeForRefreshToken: true,
  );
}
