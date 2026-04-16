import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:neurea/core/presentation/screens/Privacy_Policy_Screen.dart';
import 'package:neurea/features/auth/presentation/views/signup_view.dart';
import 'package:neurea/features/login_view.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: const Alignment(0, 1.1),
            child: Image.asset(
              "assets/welcome.png",
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x88B59DD8), Color(0x003F006E)],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 110, 20, 30),
            child: Column(
              children: [
                const Text(
                  'Good to have you here!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'We\'re here to help you navigate your thoughts. Start your day with a quick check-in, explore our calming exercises, or chat with your AI assistant to find clarity in the chaos.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1.40,
                    ),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  height: 65,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginView()),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2D2D2D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'I already have an account',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 65,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SignupView()),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7A2BAF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Let\'s get Started',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Check our ',
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.3,
                          color: Color(0xFF3C3C3C),
                        ),
                      ),
                      TextSpan(
                        text: 'privacy policy',
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.3,
                          color: Color(0xFF3C3C3C),
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PrivacyPolicyScreen(),
                            ),
                          ),
                      ),
                      const TextSpan(
                        text: ' for data\nprocessing details.',
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.3,
                          color: Color(0xFF3C3C3C),
                        ),
                      ),
                    ],
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
