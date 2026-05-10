// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neurea/Home/Explore_Screen.dart';
import 'package:neurea/core/presentation/screens/chatbot_welcome_screen.dart';
import 'package:neurea/core/presentation/screens/notifications_screen.dart';
import 'package:neurea/cubit/mood/mood_cubit.dart';
import 'package:neurea/cubit/mood/mood_state.dart';
import 'package:neurea/Home/Statistics_Screen.dart';
import 'package:neurea/core/presentation/screens/Notification_Helper.dart';
import 'package:neurea/core/presentation/screens/profile_screen.dart';
import 'package:neurea/therapists/presentation/screens/therapists_list_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreenDaily extends StatefulWidget {
  const HomeScreenDaily({super.key});

  @override
  State<HomeScreenDaily> createState() => _HomeScreenDailyState();
}

class _HomeScreenDailyState extends State<HomeScreenDaily> {
  final _moodCubit = MoodCubit();
  int _currentIndex = 0;
  bool _checkinShown = false;
  String _firstName = '';

  @override
  void initState() {
    super.initState();
    _moodCubit.loadMoodHistory();
    _loadUserName();
    _checkMissedCheckin();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showDailyCheckin());
  }

  @override
  void dispose() {
    _moodCubit.close();
    super.dispose();
  }

  Future<void> _loadUserName() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;

      final profile = await Supabase.instance.client
          .from('profiles')
          .select('first_name')
          .eq('id', user.id)
          .maybeSingle();

      String name = '';

      if (profile != null &&
          profile['first_name'] != null &&
          profile['first_name'].toString().isNotEmpty) {
        name = profile['first_name'].toString();
      } else {
        final meta = user.userMetadata;
        final rawName =
            meta?['first_name'] ?? meta?['given_name'] ?? meta?['name'] ?? '';
        name = rawName.toString().isNotEmpty
            ? rawName.toString().split(' ').first
            : 'there';
      }

      if (mounted) setState(() => _firstName = name);
    } catch (_) {}
  }

  Future<void> _checkMissedCheckin() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) return;

      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);

      final result = await Supabase.instance.client
          .from('mood_checkins')
          .select()
          .eq('user_id', userId)
          .gte('created_at', startOfDay.toIso8601String())
          .limit(1);

      if (result.isEmpty) {
        await NotificationHelper.sendOnceToday(
          title: 'Daily Check-in Reminder 🌟',
          description:
              "You haven't logged your mood today. Take a moment to check in with yourself!",
          type: 'reminder',
        );
      }
    } catch (_) {}
  }

  Future<void> _showDailyCheckin() async {
    if (!mounted || _checkinShown) return;
    _checkinShown = true;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _DailyCheckinSheet(moodCubit: _moodCubit),
    );

    if (mounted) _moodCubit.loadMoodHistory();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      BlocProvider.value(
        value: _moodCubit,
        child: _HomeContent(firstName: _firstName),
      ),
      const ExploreScreen(),
      const SizedBox(), 
      const TherapistsListScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: _BottomNav(
        currentIndex: _currentIndex,
        onTap: (i) {
          if (i != 2) setState(() => _currentIndex = i);
        },
        onCenterTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ChatbotWelcomeScreen()),
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onCenterTap;

  const _BottomNav({
    required this.currentIndex,
    required this.onTap,
    required this.onCenterTap,
  });

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final navH = sh * 0.09;
    final btnSize = sw * 0.13;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: navH,
          color: Colors.white,
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: onTap,
            selectedItemColor: const Color(0xFF7A2BAF),
            unselectedItemColor: Colors.grey,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            elevation: 0,
            selectedLabelStyle: TextStyle(
              fontSize: sw * 0.028,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: TextStyle(fontSize: sw * 0.028),
            items: [
              BottomNavigationBarItem(
                icon: Image.asset('assets/Home.png', height: sw * 0.065),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Image.asset('assets/Explore.png', height: sw * 0.065),
                label: 'Explore',
              ),
              const BottomNavigationBarItem(
                icon: Opacity(opacity: 0, child: Icon(Icons.add, size: 26)),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Image.asset('assets/Therapist.png', height: sw * 0.065),
                label: 'Therapist',
              ),
              BottomNavigationBarItem(
                icon: Image.asset('assets/Account.png', height: sw * 0.065),
                label: 'Account',
              ),
            ],
          ),
        ),
        Positioned(
          top: -(btnSize * 0.42),
          left: sw / 2 - btnSize / 2,
          child: GestureDetector(
            onTap: onCenterTap,
            child: Container(
              width: btnSize,
              height: btnSize,
              decoration: BoxDecoration(
                color: const Color(0xff6b4eff),
                borderRadius: BorderRadius.circular(sw * 0.04),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff6b4eff).withOpacity(0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.auto_awesome_rounded,
                size: sw * 0.06,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DailyCheckinSheet extends StatefulWidget {
  final MoodCubit moodCubit;
  const _DailyCheckinSheet({required this.moodCubit});

  @override
  State<_DailyCheckinSheet> createState() => _DailyCheckinSheetState();
}

class _DailyCheckinSheetState extends State<_DailyCheckinSheet> {
  int? _selectedMood;

  static const _moods = [
    {'label': 'Joyful', 'asset': 'assets/joyful_check in.png'},
    {'label': 'Happy', 'asset': 'assets/happy_check in.png'},
    {'label': 'Moderate', 'asset': 'assets/Moderate deliy check in.png'},
    {'label': 'Sad', 'asset': 'assets/Sad_check in.png'},
    {'label': 'Angry', 'asset': 'assets/Angry_check in.png'},
  ]; 

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return BlocProvider.value(
      value: widget.moodCubit,
      child: BlocConsumer<MoodCubit, MoodState>(
        listener: (ctx, state) {
          if (state is MoodSaved && Navigator.canPop(ctx)) Navigator.pop(ctx);
          if (state is MoodError) {
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (ctx, state) {
          final isLoading = state is MoodLoading;

          return AnimatedPadding(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.only(bottom: bottomInset),
            child: Container(
              padding: EdgeInsets.fromLTRB(
                sw * 0.06,
                sh * 0.015,
                sw * 0.06,
                sh * 0.03,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SheetHandle(sw: sw, sh: sh),
                  SizedBox(height: sh * 0.025),
                  Text(
                    'Daily Check-in',
                    style: TextStyle(
                      fontSize: sw * 0.052,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: sh * 0.005),
                  Text(
                    'How is your mood right now?',
                    style: TextStyle(
                      fontSize: sw * 0.037,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: sh * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      _moods.length,
                      (i) => _MoodOption(
                        label: _moods[i]['label']!,
                        asset: _moods[i]['asset']!,
                        isSelected: _selectedMood == i,
                        onTap: () => setState(() => _selectedMood = i),
                        sw: sw,
                        sh: sh,
                      ),
                    ),
                  ),
                  SizedBox(height: sh * 0.025),
                  _PrimaryButton(
                    label: 'Continue',
                    isLoading: isLoading,
                    onPressed: _selectedMood == null
                        ? null
                        : () => ctx.read<MoodCubit>().saveMood(
                            _moods[_selectedMood!]['label']!,
                          ),
                    sh: sh,
                    sw: sw,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  final double sw, sh;
  const _SheetHandle({required this.sw, required this.sh});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: sw * 0.1,
        height: sh * 0.005,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

class _MoodOption extends StatelessWidget {
  final String label;
  final String asset;
  final bool isSelected;
  final VoidCallback onTap;
  final double sw, sh;

  const _MoodOption({
    required this.label,
    required this.asset,
    required this.isSelected,
    required this.onTap,
    required this.sw,
    required this.sh,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.all(sw * 0.015),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? const Color(0xFF7A2BAF).withOpacity(0.08)
                  : Colors.transparent,
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF7A2BAF)
                    : Colors.transparent,
                width: 2,
              ),
            ),
            child: Image.asset(asset, width: sw * 0.09, height: sw * 0.09),
          ),
          SizedBox(height: sh * 0.007),
          Text(
            label,
            style: TextStyle(
              fontSize: sw * 0.028,
              color: isSelected ? const Color(0xFF7A2BAF) : Colors.black54,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback? onPressed;
  final double sw, sh;

  const _PrimaryButton({
    required this.label,
    required this.isLoading,
    required this.onPressed,
    required this.sw,
    required this.sh,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: sh * 0.065,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF7A2BAF),
          disabledBackgroundColor: Colors.grey.shade200,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: sw * 0.042,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  final String firstName;
  const _HomeContent({required this.firstName});

  String get _greeting {
    final h = DateTime.now().hour;
    final name = firstName.isNotEmpty ? firstName : 'there';
    if (h >= 5 && h < 12) return 'Good Morning, $name';
    if (h >= 12 && h < 17) return 'Good Afternoon, $name';
    if (h >= 17 && h < 21) return 'Good Evening, $name';
    return 'Good Night, $name';
  }

  String _monthName(int m) => const [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ][m - 1];

  IconData _moodIcon(String? mood) {
    switch (mood) {
      case 'Joyful': return Icons.sentiment_very_satisfied;
      case 'Happy': return Icons.sentiment_satisfied_alt;
      case 'Moderate': return Icons.sentiment_neutral;
      case 'Sad': return Icons.sentiment_dissatisfied;
      case 'Angry': return Icons.sentiment_very_dissatisfied;
      default: return Icons.sentiment_neutral;
    }
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final pad = sw * 0.045;
    final now = DateTime.now();

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: pad, vertical: sh * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${now.day} ${_monthName(now.month)}',
                      style: TextStyle(fontSize: sw * 0.03, color: Colors.grey.shade500),
                    ),
                    Text(
                      _greeting,
                      style: TextStyle(
                        fontSize: sw * 0.046,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF7A2BAF),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _IconButton(
                      icon: Icons.notifications_outlined,
                      sw: sw,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const NotificationScreen()),
                      ),
                    ),
                    SizedBox(width: sw * 0.01),
                    _IconButton(
                      icon: Icons.bar_chart_outlined,
                      sw: sw,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const StatisticsView()),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: sh * 0.02),
            _MoodInsightCard(sw: sw),
            SizedBox(height: sh * 0.025),
            Text('Your mood today!', style: TextStyle(fontSize: sw * 0.038, fontWeight: FontWeight.w600)),
            SizedBox(height: sh * 0.012),
            BlocBuilder<MoodCubit, MoodState>(
              builder: (_, state) {
                final todayMood = state is MoodLoaded ? state.todayMood : null;
                return _TodayMoodBadge(mood: todayMood, icon: _moodIcon(todayMood), sw: sw);
              },
            ),
            SizedBox(height: sh * 0.03),
            Text('Recommendations', style: TextStyle(fontSize: sw * 0.038, fontWeight: FontWeight.w600)),
            SizedBox(height: sh * 0.02),
            Row(
              children: [
                Expanded(
                  child: _RecommendCard(
                    icon: Icons.auto_awesome_outlined,
                    title: 'AI Chatbot',
                    subtitle: '24/7 AI-powered support chat',
                    sw: sw,
                    sh: sh,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ChatbotWelcomeScreen()),
                    ),
                  ),
                ),
                SizedBox(width: sw * 0.03),
                Expanded(
                  child: _RecommendCard(
                    icon: Icons.search,
                    title: 'Find Therapist',
                    subtitle: 'Search and book professional sessions',
                    sw: sw,
                    sh: sh,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TherapistsListScreen()),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: sh * 0.018),
            Row(
              children: [
                Expanded(
                  child: _RecommendCard(
                    icon: Icons.mood,
                    title: 'Mood Tracking',
                    subtitle: 'Log your feelings and view trends',
                    sw: sw,
                    sh: sh,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const StatisticsView()),
                    ),
                  ),
                ),
                SizedBox(width: sw * 0.03),
                Expanded(
                  child: _VideoCard(
                    sh: sh,
                    sw: sw,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ExploreScreen()),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double sw;

  const _IconButton({required this.icon, required this.onTap, required this.sw});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(sw * 0.02),
        decoration: BoxDecoration(
          color: const Color(0xFFF3EDF7),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.black54, size: sw * 0.05),
      ),
    );
  }
}

class _MoodInsightCard extends StatelessWidget {
  final double sw;
  const _MoodInsightCard({required this.sw});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(sw * 0.04),
      decoration: BoxDecoration(
        color: const Color(0xFFF3EDF7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: sw * 0.11,
            height: sw * 0.11,
            decoration: BoxDecoration(
              color: const Color(0xFF7A2BAF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.sentiment_satisfied_alt, color: Colors.white, size: sw * 0.055),
          ),
          SizedBox(width: sw * 0.03),
          Expanded(
            child: Text(
              "You've been happier this week.\nKeep going! Tap to see details",
              style: TextStyle(fontSize: sw * 0.033, color: Colors.black87, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _TodayMoodBadge extends StatelessWidget {
  final String? mood;
  final IconData icon;
  final double sw;

  const _TodayMoodBadge({required this.mood, required this.icon, required this.sw});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: sw * 0.04, vertical: sw * 0.025),
      decoration: BoxDecoration(
        color: const Color(0xFFF3EDF7),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFF7A2BAF), size: sw * 0.05),
          SizedBox(width: sw * 0.02),
          Text(
            mood ?? 'No check-in yet',
            style: TextStyle(
              color: const Color(0xFF7A2BAF),
              fontWeight: FontWeight.w600,
              fontSize: sw * 0.038,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final double sw, sh;

  const _RecommendCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.sw,
    required this.sh,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(sw * 0.035),
        decoration: BoxDecoration(
          color: const Color(0xFFF3EDF7),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(sw * 0.02),
              decoration: BoxDecoration(
                color: const Color(0xFF7A2BAF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: const Color(0xFF7A2BAF), size: sw * 0.045),
            ),
            SizedBox(height: sh * 0.012),
            Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: sw * 0.033)),
            SizedBox(height: sh * 0.005),
            Text(subtitle, style: TextStyle(fontSize: sw * 0.028, color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }
}

class _VideoCard extends StatelessWidget {
  final VoidCallback onTap;
  final double sw, sh;

  const _VideoCard({required this.onTap, required this.sw, required this.sh});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Image.asset(
              'assets/Motivation Video.png',
              height: sh * 0.175,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Container(
              height: sh * 0.175,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.55)],
                ),
              ),
            ),
            Center(
              child: Icon(Icons.play_circle_fill, color: Colors.white, size: sw * 0.11),
            ),
            Positioned(
              bottom: sh * 0.01,
              left: sw * 0.02,
              child: Text(
                'Motivation Video',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: sw * 0.03),
              ),
            ),
          ],
        ),
      ),
    );
  }
}