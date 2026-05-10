import 'dart:async';
import 'package:flutter/material.dart';
import 'package:neurea/features/auth/presentation/views/welcome_view.dart';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({super.key});

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const WelcomeView()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8D4E8),
      body: Column(
        children: [
          const Spacer(flex: 2),
          Container(
            height: 125.84,
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage("assets/LOGOزز 1.png")),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Untangle Your Thoughts....',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF3E225C),
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(flex: 3),
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
    );
  }
}
