import 'package:flutter/material.dart';
import 'package:neurea/features/Onboarding_Two_View .dart';

class OnboardingOneView extends StatefulWidget {
  const OnboardingOneView({super.key});

  @override
  State<OnboardingOneView> createState() => _OnboardingOneViewState();
}

class _OnboardingOneViewState extends State<OnboardingOneView> {
  int? selected;
  final options = [
    'Nothing bad has happened',
    'Breakup',
    'Emotional abuse',
    'Physical violence',
    'Moved to new location',
    'Change job',
    'Other',
  ];

  void _next() {
    if (selected == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an option first'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OnboardingTwoView(mainGoal: options[selected!]),
      ),
    );
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
              _buildHeader(),
              const SizedBox(height: 30),
              const Text(
                'Have you had a traumatic experience recently?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              ...List.generate(options.length, (i) => _buildOption(i)),
              const Spacer(),
              _buildNextButton(),
              const SizedBox(height: 30),
              _buildBottomBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
                    color: i == 0
                        ? const Color(0xFF7A2BAF)
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
     
      ],
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

  Widget _buildNextButton() {
    return GestureDetector(
      onTap: _next,
      child: Container(
        height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF2D2D2D),
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Center(
          child: Text(
            'Next',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
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
