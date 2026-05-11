import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:neurea/Home/Home_Screen_daily.dart';
import 'package:neurea/core/presentation/screens/Notification_Helper.dart';
import 'package:neurea/cubit/profile/profile_cubit.dart';
import 'package:neurea/features/splash_screen_view.dart';
import 'package:neurea/therapists/presentation/screens/therapist_details_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app_links/app_links.dart';
import 'package:timezone/data/latest.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  await Supabase.initialize(
    url: 'https://krtdxjudgjkxkbcpgmwk.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtydGR4anVkZ2preGtiY3BnbXdrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE2MTUxMDIsImV4cCI6MjA4NzE5MTEwMn0._aKjmHWv9dTzR1BML79I4Dz-rXTDffVD849Dub_UG-s',
  );

  tz.initializeTimeZones();
  await NotificationHelper.initialize();
  await NotificationHelper.scheduleAllNotifications();

  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initSettings = InitializationSettings(
    android: androidSettings,
  );
  await flutterLocalNotificationsPlugin.initialize(initSettings);
  _checkLastOpenDate();
  runApp(const Neurea());
}

Future<void> _checkLastOpenDate() async {
  try {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final now = DateTime.now();
    final response = await Supabase.instance.client
        .from('user_activity')
        .select('last_open')
        .eq('user_id', user.id)
        .maybeSingle();

    if (response != null && response['last_open'] != null) {
      final lastOpen = DateTime.parse(response['last_open'] as String);
      final diff = now.difference(lastOpen).inDays;

      if (diff >= 3) {
        await NotificationHelper.send(
          title: 'We miss you! 👋',
          description:
              "You haven't opened Neurea in $diff days. Come back and check in!",
          type: 'reminder',
        );
      }
    }

    await Supabase.instance.client.from('user_activity').upsert({
      'user_id': user.id,
      'last_open': now.toIso8601String(),
    });
  } catch (e) {
    // ignore: avoid_print
    print('Activity check error: $e');
  }
}

class Neurea extends StatefulWidget {
  const Neurea({super.key});

  @override
  State<Neurea> createState() => _NeureaState();
}

class _NeureaState extends State<Neurea> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  late final AppLinks _appLinks;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }

  Future<void> _initDeepLinks() async {
    _appLinks = AppLinks();
    _appLinks.uriLinkStream.listen(_handleDeepLink);

    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      _handleDeepLink(initialUri);
    }
  }

  Future<void> _handleDeepLink(Uri uri) async {
    if (uri.toString().startsWith('io.supabase.neurea://login-callback')) {
      try {
        await Supabase.instance.client.auth.getSessionFromUrl(uri);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _navigatorKey.currentState?.pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const HomeScreenDaily()),
            (route) => false,
          );
        });
      } catch (e) {
        // ignore: avoid_print
        print('Deep link error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProfileCubit()..loadProfile()),
      ],
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        debugShowCheckedModeBanner: false,
        home: const SplashScreenView(),
        onGenerateRoute: (settings) {
          if (settings.name == '/therapist_details') {
            final therapist = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => TherapistDetailsScreen(therapist: therapist),
            );
          }
          return null;
        },
      ),
    );
  }
}
