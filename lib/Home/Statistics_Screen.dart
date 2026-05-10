// ignore_for_file: deprecated_member_use
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neurea/cubit/mood/mood_cubit.dart';
import 'package:neurea/cubit/mood/mood_state.dart';

class StatisticsView extends StatefulWidget {
  const StatisticsView({super.key});

  @override
  State<StatisticsView> createState() => _StatisticsViewState();
}

class _StatisticsViewState extends State<StatisticsView> {
  late final MoodCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = MoodCubit()..loadMoodHistory();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(value: _cubit, child: const _StatisticsBody());
  }
}

class _StatisticsBody extends StatelessWidget {
  const _StatisticsBody();

  static const _purple = Color(0xFF7A2BAF);
  static const _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  static const _defaultChartData = [
    _MoodData('Mon', 68),
    _MoodData('Tue', 74),
    _MoodData('Wed', 65),
    _MoodData('Thu', 80),
    _MoodData('Fri', 78),
    _MoodData('Sat', 85),
    _MoodData('Sun', 93),
  ];

  double _moodValue(String mood) {
    switch (mood.toLowerCase()) {
      case 'joyful':
        return 100;
      case 'happy':
        return 80;
      case 'moderate':
        return 60;
      case 'sad':
        return 40;
      case 'angry':
        return 20;
      default:
        return 50;
    }
  }

  List<_MoodData> _buildChartData(List<Map<String, dynamic>> history) {
    if (history.isEmpty) return _defaultChartData;
    return history
        .take(7)
        .toList()
        .reversed
        .toList()
        .asMap()
        .entries
        .map(
          (e) => _MoodData(
            e.key < _days.length ? _days[e.key] : 'Day ${e.key + 1}',
            _moodValue(e.value['mood']?.toString() ?? 'moderate'),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final pad = sw * 0.04;

    return BlocBuilder<MoodCubit, MoodState>(
      builder: (context, state) {
        final history = state is MoodLoaded
            ? state.moodHistory
            : <Map<String, dynamic>>[];
        final streak = state is MoodLoaded ? state.streak : 0;
        final isLoading = state is MoodLoading;

        return Scaffold(
          backgroundColor: const Color(0xFFF8F6FC),
          appBar: _StatisticsAppBar(sw: sw),
        body: isLoading
    ? const Center(child: CircularProgressIndicator(color: _purple))
    : ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(pad, sh * 0.02, pad, sh * 0.03),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionTitle('Mood Trends', sw),
                      SizedBox(height: sh * 0.012),
                      _MoodChart(
                        chartData: _buildChartData(history),
                        sw: sw,
                        sh: sh,
                      ),
                      SizedBox(height: sh * 0.025),
                      _StatsRow(streak: streak, history: history, sw: sw),
                      SizedBox(height: sh * 0.025),
                      _SectionTitle('Your Goals', sw),
                      SizedBox(height: sh * 0.012),
                      _GoalsCard(history: history, sw: sw),
                      SizedBox(height: sh * 0.025),
                      _SectionTitle('AI Insight', sw),
                      SizedBox(height: sh * 0.012),
                      _InsightCard(streak: streak, sw: sw),
                    ],
                  ),
                ),
    ),
        );
      },
    );
  }
}

class _StatisticsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double sw;
  const _StatisticsAppBar({required this.sw});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: sw * 0.045),
        onPressed: () => Navigator.pop(context),
      ),
      title: Column(
        children: [
          Text(
            'Mood Tracking',
            style: TextStyle(
              color: Colors.black,
              fontSize: sw * 0.042,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Weekly Overview',
            style: TextStyle(color: Colors.grey, fontSize: sw * 0.03),
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.tune_rounded, color: Colors.black, size: sw * 0.05),
          onPressed: () {},
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: Colors.grey.shade100),
      ),
    );
  }
}

class _MoodChart extends StatelessWidget {
  final List<_MoodData> chartData;
  final double sw, sh;

  const _MoodChart({
    required this.chartData,
    required this.sw,
    required this.sh,
  });

  @override
  Widget build(BuildContext context) {
    final spots = chartData
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.value))
        .toList();

    return _Card(
      child: SizedBox(
        height: sh * 0.26,
        child: LineChart(
          LineChartData(
            minY: 0,
            maxY: 100,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 25,
              getDrawingHorizontalLine: (_) =>
                  FlLine(color: const Color(0xFFEEEEEE), strokeWidth: 0.5),
            ),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 25,
                  reservedSize: 35,
                  getTitlesWidget: (value, _) => Text(
                    '${value.toInt()}%',
                    style: TextStyle(fontSize: sw * 0.025, color: Colors.grey),
                  ),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, _) {
                    final idx = value.toInt();
                    if (idx < 0 || idx >= chartData.length) {
                      return const SizedBox();
                    }
                    return Text(
                      chartData[idx].day,
                      style: TextStyle(
                        fontSize: sw * 0.028,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: Colors.orange,
                barWidth: 2.5,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                    radius: sw * 0.01,
                    color: Colors.orange,
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  ),
                ),
                belowBarData: BarAreaData(
                  show: true,
                  color: Colors.orange.withOpacity(0.12),
                ),
              ),
            ],
          ),
          duration: Duration.zero,
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final int streak;
  final List<Map<String, dynamic>> history;
  final double sw;

  const _StatsRow({
    required this.streak,
    required this.history,
    required this.sw,
  });

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Row(
        children: [
          Expanded(
            child: _StatTile(
              asset: 'assets/Statistics1.png',
              value: '8.5',
              label: 'Avg. Mood',
              sw: sw,
            ),
          ),
          _VerticalDivider(),
          Expanded(
            child: _StatTile(
              asset: 'assets/Statistics2.png',
              value: '$streak',
              label: 'Sessions',
              sw: sw,
            ),
          ),
          _VerticalDivider(),
          Expanded(
            child: _StatTile(
              asset: 'assets/Statistics3.png',
              value: '${history.length}',
              label: 'Minutes spent',
              sw: sw,
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalsCard extends StatelessWidget {
  final List<Map<String, dynamic>> history;
  final double sw;

  const _GoalsCard({required this.history, required this.sw});

  @override
  Widget build(BuildContext context) {
    final checkinPercent = history.isEmpty
        ? 0.0
        : (history.length / 30).clamp(0.0, 1.0);

    return _Card(
      child: Column(
        children: [
          _GoalItem(
            label: 'Daily Meditation',
            percent: 0.8,
            color: const Color(0xFF7A2BAF),
            sw: sw,
          ),
          _GoalItem(
            label: 'Talking with chat',
            percent: 0.6,
            color: Colors.orange,
            sw: sw,
          ),
          _GoalItem(
            label: 'Mood Check-ins',
            percent: checkinPercent,
            color: Colors.blue,
            sw: sw,
          ),
          _GoalItem(
            label: 'Breathing Exercise',
            percent: 0.4,
            color: Colors.green,
            sw: sw,
          ),
          _GoalItem(
            label: 'Therapist sessions',
            percent: 0.4,
            color: Colors.pink,
            isLast: true,
            sw: sw,
          ),
        ],
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  final int streak;
  final double sw;

  const _InsightCard({required this.streak, required this.sw});

  String get _message => streak >= 7
      ? "Amazing! You've maintained a $streak-day streak. Keep it up!"
      : 'You show improved mood on days with morning meditation. Consider making it a daily habit!';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(sw * 0.04),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7A2BAF), Color(0xFF6b4eff)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(sw * 0.02),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.lightbulb_outline,
              color: Colors.white,
              size: sw * 0.045,
            ),
          ),
          SizedBox(width: sw * 0.03),
          Expanded(
            child: Text(
              _message,
              style: TextStyle(
                fontSize: sw * 0.033,
                color: Colors.white,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MoodData {
  final String day;
  final double value;
  const _MoodData(this.day, this.value);
}

class _SectionTitle extends StatelessWidget {
  final String text;
  final double sw;
  const _SectionTitle(this.text, this.sw);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: sw * 0.04, fontWeight: FontWeight.w700),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(sw * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 40, color: Colors.grey.shade200);
  }
}

class _StatTile extends StatelessWidget {
  final String asset;
  final String value;
  final String label;
  final double sw;

  const _StatTile({
    required this.asset,
    required this.value,
    required this.label,
    required this.sw,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          asset,
          width: sw * 0.07,
          height: sw * 0.07,
          fit: BoxFit.contain,
        ),
        SizedBox(height: sw * 0.015),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: sw * 0.048),
        ),
        SizedBox(height: sw * 0.005),
        Text(
          label,
          style: TextStyle(fontSize: sw * 0.028, color: Colors.grey),
        ),
      ],
    );
  }
}

class _GoalItem extends StatelessWidget {
  final String label;
  final double percent;
  final Color color;
  final bool isLast;
  final double sw;

  const _GoalItem({
    required this.label,
    required this.percent,
    required this.color,
    required this.sw,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : sw * 0.035),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: sw * 0.033,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${(percent * 100).toInt()}%',
                style: TextStyle(
                  fontSize: sw * 0.03,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
          SizedBox(height: sw * 0.015),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percent,
              backgroundColor: Colors.grey.shade100,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: sw * 0.018,
            ),
          ),
        ],
      ),
    );
  }
} 
 