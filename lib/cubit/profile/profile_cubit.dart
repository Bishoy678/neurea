import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:neurea/core/presentation/screens/Notification_Helper.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  final _supabase = Supabase.instance.client;

  Future<void> loadProfile() async {
    if (isClosed) return;
    emit(ProfileLoading());
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        if (isClosed) return;
        return emit(ProfileError('User not logged in'));
      }

      final email = user.email ?? '';
      String name = user.userMetadata?['full_name'] ?? '';
      if (name.isEmpty) name = email.split('@').first;

      final data = await _supabase
          .from('profiles')
          .select('photo_url')
          .eq('id', user.id)
          .maybeSingle();

      final photoUrl = data?['photo_url'] as String? ?? '';

      if (isClosed) return;
      emit(ProfileLoaded(name: name, email: email, photoUrl: photoUrl));
    } catch (e) {
      if (isClosed) return;
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> updateProfile({
    required String firstName,
    required String lastName,
  }) async {
    if (isClosed) return;
    emit(ProfileLoading());
    try {
      await _supabase.auth.updateUser(
        UserAttributes(
          data: {
            'full_name': '$firstName $lastName',
            'first_name': firstName,
            'last_name': lastName,
          },
        ),
      );
      
      await NotificationHelper.send(
        title: 'Profile Updated ✅',
        description: 'Your profile has been successfully updated!',
        type: 'general',
      );
      
      if (isClosed) return;
      emit(ProfileUpdated());
      await loadProfile();
    } catch (e) {
      if (isClosed) return;
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> pickAndUploadImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked == null) return;

    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        if (isClosed) return;
        emit(ProfileError('User not logged in'));
        return;
      }

      final uid = user.id;
      final file = File(picked.path);
      final filePath = '$uid/avatar.jpg';

      try {
        await _supabase.storage.from('avatars').remove(['$uid/avatar.jpg']);
      } catch (_) {}

      await _supabase.storage
          .from('avatars')
          .upload(
            filePath,
            file,
            fileOptions: const FileOptions(
              upsert: true,
              contentType: 'image/jpeg',
            ),
          );

      final url = _supabase.storage.from('avatars').getPublicUrl(filePath);
      
      await _supabase.from('profiles').upsert({'id': uid, 'photo_url': url});

      await NotificationHelper.send(
        title: 'Profile Picture Updated 📸',
        description: 'Your profile picture has been successfully updated!',
        type: 'general',
      );

      await loadProfile();
    } on StorageException catch (e) {
      if (isClosed) return;
      if (e.statusCode == '403') {
        emit(
          ProfileError('Permission denied. Check Supabase Storage policies.'),
        );
      } else {
        emit(ProfileError('Storage error: ${e.message}'));
      }
    } catch (e) {
      if (isClosed) return;
      emit(ProfileError(e.toString()));
    }
  }
} 
