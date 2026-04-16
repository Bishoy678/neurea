// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountNotification extends StatefulWidget {
  const AccountNotification({super.key});

  @override
  State<AccountNotification> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<AccountNotification> {
  bool dailyCheckin = true;
  bool therapistSessions = true;
  bool aiEncouragement = true;
  bool updatesOffers = false;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      dailyCheckin = prefs.getBool('notif_daily_checkin') ?? true;
      therapistSessions = prefs.getBool('notif_therapist_sessions') ?? true;
      aiEncouragement = prefs.getBool('notif_ai_encouragement') ?? true;
      updatesOffers = prefs.getBool('notif_updates_offers') ?? false;
    });
  }

  Future<void> _savePref(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Color(0xFF5C2D91),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose which notifications you want to receive to stay on track with your mental wellness journey.',
              style: TextStyle(fontSize: 13, color: Colors.grey, height: 1.5),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _notifTile(
                    icon: Icons.nightlight_round,
                    title: 'Daily Check-in',
                    subtitle: 'Reminders to log your daily mood.',
                    value: dailyCheckin,
                    onChanged: (v) {
                      setState(() => dailyCheckin = v);
                      _savePref('notif_daily_checkin', v);
                    },
                  ),
                  _divider(),
                  _notifTile(
                    icon: Icons.nightlight_round,
                    title: 'Therapist Sessions',
                    subtitle: 'Alerts for your upcoming appointments.',
                    value: therapistSessions,
                    onChanged: (v) {
                      setState(() => therapistSessions = v);
                      _savePref('notif_therapist_sessions', v);
                    },
                  ),
                  _divider(),
                  _notifTile(
                    icon: Icons.nightlight_round,
                    title: 'AI Encouragement',
                    subtitle: 'Motivating messages from your AI companion.',
                    value: aiEncouragement,
                    onChanged: (v) {
                      setState(() => aiEncouragement = v);
                      _savePref('notif_ai_encouragement', v);
                    },
                  ),
                  _divider(),
                  _notifTile(
                    icon: Icons.nightlight_round,
                    title: 'Updates & Offers',
                    subtitle: 'New features and Neurea Pro discounts.',
                    value: updatesOffers,
                    onChanged: (v) {
                      setState(() => updatesOffers = v);
                      _savePref('notif_updates_offers', v);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 90,
            color: Colors.white,
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  icon: Image.asset("assets/Home.png", height: 45),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: Image.asset("assets/Explore.png", height: 45),
                  label: "Explore",
                ),
                const BottomNavigationBarItem(
                  icon: Opacity(opacity: 0, child: Icon(Icons.add)),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: Image.asset("assets/Therapist.png", height: 45),
                  label: "Therapist",
                ),
                BottomNavigationBarItem(
                  icon: Image.asset("assets/Account.png", height: 45),
                  label: "Account",
                ),
              ],
            ),
          ),
          Positioned(
            top: -15,
            left: MediaQuery.of(context).size.width / 2 - 28,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: const Color(0xff6b4eff),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                size: 28,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _notifTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade400, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFF5C2D91),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey.shade300,
          ),
        ],
      ),
    );
  }

  Widget _divider() => Divider(
    height: 1,
    indent: 52,
    endIndent: 16,
    color: Colors.grey.shade100,
  );
}
