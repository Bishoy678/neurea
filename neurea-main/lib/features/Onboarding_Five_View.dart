// ignore_for_file: control_flow_in_finally
import 'package:flutter/material.dart';
import 'package:neurea/core/presentation/screens/Notification_Helper.dart'
    show NotificationHelper;
import 'package:neurea/features/auth/presentation/views/daily_checkin_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OnboardingFiveView extends StatefulWidget {
  final String mainGoal;
  final String additionalGoal;
  final String currentFeeling;
  final String dailyRhythm;

  const OnboardingFiveView({
    super.key,
    required this.mainGoal,
    required this.additionalGoal,
    required this.currentFeeling,
    required this.dailyRhythm,
  });

  @override
  State<OnboardingFiveView> createState() => _OnboardingFiveViewState();
}

class _OnboardingFiveViewState extends State<OnboardingFiveView> {
  int? selected;
  bool _isLoading = false;

  final options = [
    'Yes, my therapist invited me',
    'Yes, organization gave me access',
    'Yes, I already created an account',
    'No, I\'m new here',
  ];

  Future<void> _next() async {
    if (selected == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an option first'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        await Supabase.instance.client.from('onboarding_answers').upsert({
          'user_id': user.id,
          'main_goal': widget.mainGoal,
          'additional_goal': widget.additionalGoal,
          'current_feeling': widget.currentFeeling,
          'daily_rhythm': widget.dailyRhythm,
          'account_status': options[selected!],
        });
        await NotificationHelper.send(
          title: 'Welcome to Neurea! 🎉',
          description:
              'You\'ve completed your setup. Your mental wellness journey starts now!',
          type: 'achievement',
        );
      }

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DailyCheckinView()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              _buildHeader(5),
              const SizedBox(height: 30),
              const Text(
                'Do you already have an account?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              ...List.generate(options.length, (i) => _buildOption(i)),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: (_isLoading || selected == null) ? null : _next,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selected == null
                        ? Colors.grey.shade400
                        : const Color(0xFF2D2D2D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Next',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 30),
              _buildBottomBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption(int i) {
    return GestureDetector(
      onTap: () => setState(() => selected = i),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected == i
              ? const Color(0xFFD1C4E9)
              : const Color(0xFFEDE7F6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected == i ? const Color(0xFF7A2BAF) : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(options[i], style: const TextStyle(fontSize: 15)),
            ),
            Icon(
              selected == i
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: const Color(0xFF7A2BAF),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(int filledCount) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFEDE7F6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.arrow_back,
              size: 20,
              color: Color(0xFF7A2BAF),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Row(
            children: List.generate(
              5,
              (i) => Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  height: 4,
                  decoration: BoxDecoration(
                    color: i < filledCount
                        ? const Color(0xFF7A2BAF)
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Column(
      children: [
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
    );
  }
}
