// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';

const kPurple = Color(0xFF7B2FBE);

class BreathingExercisesScreen extends StatelessWidget {
  const BreathingExercisesScreen({super.key});

  static const List<Map<String, String>> _items = [
    {
      'title': 'Breathing Exercises',
      'desc': 'Calm your mind and reduce stress. Calm your mind and reduce stress.',
    },
    {
      'title': 'Breathing Exercises',
      'desc': 'Calm your mind and reduce stress. Calm your mind and reduce stress.',
    },
    {
      'title': 'Breathing Exercises',
      'desc': 'Calm your mind and reduce stress. Calm your mind and reduce stress.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Breathing Exercises',
          style: TextStyle(
            color: kPurple,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87, size: 18),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: _items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, i) => _VideoCard(
            title: _items[i]['title']!,
            description: _items[i]['desc']!,
          ),
        ),
      ),
    );
  }
}

class _VideoCard extends StatelessWidget {
  final String title;
  final String description;

  const _VideoCard({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/focusing.png',
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 180,
                    width: double.infinity,
                    color: const Color(0xFF3D2A05),
                    child: const Icon(Icons.self_improvement,
                        color: Colors.white54, size: 60),
                  ),
                ),
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.play_arrow, color: kPurple, size: 30),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}