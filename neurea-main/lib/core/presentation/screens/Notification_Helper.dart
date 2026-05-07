// ignore_for_file: avoid_print

import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _localNotifications.initialize(initSettings);
    
    await scheduleAllNotifications();
  }

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


  static Future<void> _sendLocalNotification({
    required String title,
    required String body,
    int? id,
  }) async {
    final notificationId = id ?? DateTime.now().millisecondsSinceEpoch.remainder(100000);
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'neurea_channel',
      'Neurea Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );
    const NotificationDetails details = NotificationDetails(android: androidDetails);
    await _localNotifications.show(
      notificationId,
      title,
      body,
      details,
    );
  }

  static Future<void> _scheduleLocalNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    final tz.TZDateTime tzScheduledTime = tz.TZDateTime.from(
      scheduledTime,
      tz.local,
    );
    
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'neurea_scheduled_channel',
      'Scheduled Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );
    const NotificationDetails details = NotificationDetails(android: androidDetails);
    
    await _localNotifications.zonedSchedule(
      id,
      title,
      body,
      tzScheduledTime,
      details,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  
  static Future<void> scheduleAllNotifications() async {
    await scheduleDailySleepReminder();
    await scheduleAppointmentReminders();
  }

  
  static Future<void> scheduleDailySleepReminder() async {
    final now = DateTime.now();
    var scheduledTime = DateTime(now.year, now.month, now.day, 23, 0); // 11:00 PM
    
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }
    
    await _scheduleLocalNotification(
      id: 1001,
      title: 'Time to Sleep 😴',
      body: 'It\'s getting late. Make sure to get enough rest for a better tomorrow!',
      scheduledTime: scheduledTime,
    );
  }


  static Future<void> sendAppointmentReminder({
    required String therapistName,
    required DateTime appointmentDate,
    required String appointmentTime,
  }) async {
  
    await send(
      title: 'Appointment Booked! 📅',
      description: 'Your session with $therapistName has been booked for $appointmentTime.',
      type: 'appointment',
    );
    
    
    final reminderTime = appointmentDate.subtract(const Duration(hours: 1));
    if (reminderTime.isAfter(DateTime.now())) {
      await _scheduleLocalNotification(
        id: appointmentDate.millisecondsSinceEpoch.remainder(100000),
        title: 'Upcoming Session Reminder ⏰',
        body: 'Your session with $therapistName starts in 1 hour at $appointmentTime.',
        scheduledTime: reminderTime,
      );
    }
  }

 
  static Future<void> scheduleAppointmentReminders() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;
      
      final appointments = await Supabase.instance.client
          .from('payments')
          .select()
          .eq('user_id', user.id)
          .eq('status', 'completed');
      
      for (var appointment in appointments) {
    
        final appointmentDate = DateTime.parse(appointment['appointment_date'] ?? '');
        final appointmentTime = appointment['appointment_time'] ?? '';
        
        if (appointmentDate.isAfter(DateTime.now())) {
          final reminderTime = appointmentDate.subtract(const Duration(hours: 1));
          
          if (reminderTime.isAfter(DateTime.now())) {
            await _scheduleLocalNotification(
              id: appointmentDate.millisecondsSinceEpoch.remainder(100000),
              title: 'Session Reminder 🎯',
              body: 'Your session with ${appointment['therapist_name'] ?? 'your therapist'} is tomorrow at $appointmentTime.',
              scheduledTime: reminderTime,
            );
          }
        }
      }
    } catch (e) {
      print('Error scheduling appointment reminders: $e');
    }
  }


  static Future<void> sendSubscriptionUpdateNotification({
    required String planName,
    required String expiryDate,
  }) async {
    await send(
      title: 'Subscription Update 💎',
      description: 'Your $planName plan will expire on $expiryDate. Renew now to continue enjoying premium features!',
      type: 'general',
    );
  }


  static Future<void> cancelAllScheduledNotifications() async {
    await _localNotifications.cancelAll();
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
      
      await _sendLocalNotification(
        title: title,
        body: description,
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
      
      await _sendLocalNotification(
        title: title,
        body: description,
      );
    } catch (e) {
      print('Notification error: $e');
    }
  }
} 