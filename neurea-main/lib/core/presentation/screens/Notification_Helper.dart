// ignore_for_file: avoid_print

import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationHelper {
  static Future<bool> _isEnabled(String type) async {
    final prefs = await SharedPreferences.getInstance();
    switch (type) {
      case 'reminder':
        return prefs.getBool('notif_daily_checkin') ?? true;
      case 'appointment':
        return prefs.getBool('notif_therapist_sessions') ?? true;
      case 'wellness':
        return prefs.getBool('notif_ai_encouragement') ?? true;
      case 'general':
        return prefs.getBool('notif_updates_offers') ?? false;
      default:
        return true;
    }
  }

  static Future<void> _insert({
    required String userId,
    required String title,
    required String description,
    required String type,
  }) async {
    await Supabase.instance.client.from('notifications').insert({
      'user_id': userId,
      'title': title,
      'description': description,
      'type': type,
      'is_read': false,
    });
  }

  static Future<void> send({
    required String title,
    required String description,
    required String type,
  }) async {
    try {
      if (!await _isEnabled(type)) return;
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;
      await _insert(
        userId: user.id,
        title: title,
        description: description,
        type: type,
      );
    } catch (e) {
      print('Notification error: $e');
    }
  }

  static Future<void> sendOnceToday({
    required String title,
    required String description,
    required String type,
  }) async {
    try {
      if (!await _isEnabled(type)) return;
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;

      final today = DateTime.now();
      final startOfDay = DateTime(
        today.year,
        today.month,
        today.day,
      ).toUtc().toIso8601String();

      final existing = await Supabase.instance.client
          .from('notifications')
          .select()
          .eq('user_id', user.id)
          .eq('title', title)
          .gte('created_at', startOfDay);

      if ((existing as List).isNotEmpty) return;

      await _insert(
        userId: user.id,
        title: title,
        description: description,
        type: type,
      );
    } catch (e) {
      print('Notification error: $e');
    }
  }
}
