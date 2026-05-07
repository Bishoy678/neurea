import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neurea/core/presentation/screens/Notification_Helper.dart';
import 'package:neurea/cubit/mood/mood_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MoodCubit extends Cubit<MoodState> {
  MoodCubit() : super(MoodInitial());

  void _safeEmit(MoodState state) {
    if (!isClosed) emit(state);
  }

  Future<void> loadMoodHistory() async {
     _safeEmit(MoodLoading());
  try {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      _safeEmit(MoodError('User not logged in'));  
      return;
    }

      final response = await Supabase.instance.client
          .from('mood_checkins')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      final moodHistory = List<Map<String, dynamic>>.from(response);
      _safeEmit(
        MoodLoaded(
          moodHistory: moodHistory,
          streak: _calculateStreak(moodHistory),
          todayMood: _getTodayMood(moodHistory),
        ),
      );
    } catch (e) {
      _safeEmit(MoodError(e.toString()));
    }
  }

  Future<void> saveMood(String mood) async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) return;

      await Supabase.instance.client.from('mood_checkins').insert({
        'user_id': userId,
        'mood': mood,
        'created_at': DateTime.now().toIso8601String(),
      });

      if (mood == 'Sad' || mood == 'Angry') {
        await NotificationHelper.send(
          title: "We're Here for You 💙",
          description:
              "It seems you're feeling $mood today. Remember, it's okay to seek support.",
          type: 'wellness',
        );
      }

      final currentUserId = Supabase.instance.client.auth.currentUser?.id;
      if (currentUserId == null) {
        _safeEmit(MoodSaved());
        return;
      }

      final response = await Supabase.instance.client
          .from('mood_checkins')
          .select()
          .eq('user_id', currentUserId)
          .order('created_at', ascending: false);

      final moodHistory = List<Map<String, dynamic>>.from(response);
      final streak = _calculateStreak(moodHistory);

      if (streak == 7) {
        await NotificationHelper.send(
          title: '7-Day Streak! 🔥',
          description:
              "Amazing! You've completed 7 days of check-ins in a row!",
          type: 'achievement',
        );
      }

      await NotificationHelper.sendOnceToday(
        title: 'Daily Check-in Complete ✅',
        description: "Great job! You've completed your daily mood check-in.",
        type: 'wellness',
      );

      _safeEmit(MoodSaved());

      _safeEmit(
        MoodLoaded(
          moodHistory: moodHistory,
          streak: streak,
          todayMood: _getTodayMood(moodHistory),
        ),
      );
    } catch (e) {
      _safeEmit(MoodError(e.toString()));
    }
  }

  int _calculateStreak(List<Map<String, dynamic>> moodHistory) {
    if (moodHistory.isEmpty) return 0;

    int streak = 0;
    DateTime checkDate = DateTime.now();

    for (final entry in moodHistory) {
      try {
       
        final raw = entry['created_at'];
        if (raw == null) continue;

        final moodDate = DateTime.parse(raw.toString()).toLocal();
       
        final checkDay = DateTime(
          checkDate.year,
          checkDate.month,
          checkDate.day,
        );
        final moodDay = DateTime(moodDate.year, moodDate.month, moodDate.day);
        final diff = checkDay.difference(moodDay).inDays;

        if (diff == 0) {
        
          continue;
        } else if (diff == 1) {
          streak++;
          checkDate = moodDate;
        } else {
          break;
        }
      } catch (_) {
        
        continue;
      }
    }

    if (_getTodayMood(moodHistory) != null) streak++;

    return streak;
  }

  String? _getTodayMood(List<Map<String, dynamic>> moodHistory) {
    if (moodHistory.isEmpty) return null;

    try {
      final today = DateTime.now();
      final raw = moodHistory.first['created_at'];
      if (raw == null) return null;

      final latest = DateTime.parse(raw.toString()).toLocal();

      if (latest.year == today.year &&
          latest.month == today.month &&
          latest.day == today.day) {
        return moodHistory.first['mood']?.toString();
      }
    } catch (_) {}

    return null;
  }
}
