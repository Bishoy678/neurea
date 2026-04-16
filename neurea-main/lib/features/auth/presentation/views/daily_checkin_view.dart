// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:neurea/core/presentation/screens/Notification_Helper.dart';
import 'package:neurea/cubit/mood/mood_cubit.dart';
import 'package:neurea/cubit/mood/mood_state.dart';
import 'package:neurea/main.dart';
import 'package:neurea/features/login_view.dart'; 
import 'package:timezone/timezone.dart' as tz;

class DailyCheckinView extends StatelessWidget {
  const DailyCheckinView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MoodCubit(),
      child: const _DailyCheckinBody(),
    );
  }
}

class _DailyCheckinBody extends StatefulWidget {
  const _DailyCheckinBody();

  @override
  State<_DailyCheckinBody> createState() => _DailyCheckinBodyState();
}

class _DailyCheckinBodyState extends State<_DailyCheckinBody> {
  TimeOfDay _selectedTime = const TimeOfDay(hour: 8, minute: 0);
  String _period = 'AM';

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        _period = picked.hour < 12 ? 'AM' : 'PM';
      });
    }
  }

  Future<void> _scheduleNotification() async {
    await flutterLocalNotificationsPlugin.cancel(0);
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'daily_checkin',
          'Daily Check-in',
          channelDescription: 'Daily check-in reminder',
          importance: Importance.high,
          priority: Priority.high,
        );
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Daily Check-in 🌿',
      'Time for your daily check-in!',
      scheduledDate,
      const NotificationDetails(android: androidDetails),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  String _formatTime() {
    final hour = _selectedTime.hourOfPeriod == 0
        ? 12
        : _selectedTime.hourOfPeriod;
    final minute = _selectedTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute  |  $_period';
  }

  Future<void> _onSave() async {
    await _scheduleNotification();
    await NotificationHelper.send(
      title: 'Reminder Set! ⏰',
      description:
          'Your daily check-in reminder is set for ${_formatTime()} every day.',
      type: 'reminder',
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reminder set for ${_formatTime()} daily!'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MoodCubit, MoodState>(
      listener: (context, state) {
        if (state is MoodError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(elevation: 0),
        body: SafeArea(
          child: ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text(
                    'Remind me when its bedtime',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Sleep is a love letter to your mental health.',
                    style: TextStyle(fontSize: 17),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Image.asset('assets/alarm_clock.png', fit: BoxFit.contain),
                        Positioned(
                          bottom: 0,
                          child: Image.asset(
                            'assets/Line 10.png',
                            width: 200,
                            height: 1.5,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GestureDetector(
                      onTap: _pickTime,
                      child: TextField(
                        enabled: false,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: const Icon(
                            Icons.access_time,
                            color: Colors.black87,
                          ),
                          suffixIcon: const Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Colors.grey,
                            ),
                          ),
                          hintText: _formatTime(),
                          hintStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE4F0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.pink),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'You can always change this later in your app Settings',
                              style: TextStyle(fontSize: 15, color: Colors.black87),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _onSave,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7A2BAF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Finish',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    width: 150,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}