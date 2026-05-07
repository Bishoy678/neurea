// ignore_for_file: deprecated_member_use, avoid_unnecessary_containers
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neurea/core/presentation/screens/chatbot_conversation_screen.dart';
import 'package:neurea/cubit/profile/profile_cubit.dart';
import 'package:neurea/cubit/profile/profile_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _CardItem {
  final String image;
  final String text;
  const _CardItem({required this.image, required this.text});
}

class ChatbotWelcomeScreen extends StatelessWidget {
  const ChatbotWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit()..loadProfile(),
      child: const _ChatbotWelcomeScreenContent(),
    );
  }
}

class _ChatbotWelcomeScreenContent extends StatefulWidget {
  const _ChatbotWelcomeScreenContent();

  @override
  State<_ChatbotWelcomeScreenContent> createState() => _ChatbotWelcomeScreenContentState();
}

class _ChatbotWelcomeScreenContentState extends State<_ChatbotWelcomeScreenContent> {
  String _firstName = '';
  final TextEditingController _controller = TextEditingController();

  final List<_CardItem> _cards = const [
    _CardItem(
      image: 'assets/chatbot welcome1.png',
      text: 'I am going through an emotional Breakdown',
    ),
    _CardItem(
      image: 'assets/chatbot welcome2.png',
      text: 'Work is making me feel overwhelmed.',
    ),
    _CardItem(
      image: 'assets/chatbot welcome3.png',
      text: 'Help me find positive focus today.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _loadUserName() {
    final profileState = context.read<ProfileCubit>().state;
    if (profileState is ProfileLoaded) {
      String fullName = profileState.name;
      String nameWithoutNumbers = fullName.replaceAll(RegExp(r'[0-9]'), '');
      String firstName = nameWithoutNumbers.trim().split(' ').first;
      setState(() {
        _firstName = firstName;
      });
    } else {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        final metadata = user.userMetadata ?? {};
        String rawName = metadata['first_name']?.toString() ??
            metadata['full_name']?.toString() ??
            user.email?.split('@').first ??
            'there';
        String nameWithoutNumbers = rawName.replaceAll(RegExp(r'[0-9]'), '');
        String firstName = nameWithoutNumbers.trim().split(' ').first;
        setState(() {
          _firstName = firstName.isEmpty ? 'there' : firstName;
        });
      }
    }
  }

  void _goToConversation(String message) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatbotConversationScreen(initialMessage: message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoaded) {
          String fullName = state.name;
          String nameWithoutNumbers = fullName.replaceAll(RegExp(r'[0-9]'), '');
          String firstName = nameWithoutNumbers.trim().split(' ').first;
          _firstName = firstName;
        }
        return Scaffold(
          backgroundColor: const Color(0xffF5F5F7),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back, color: Colors.black),
            ),
            title: Text(
              "Neurea (AI Therapist)",
              style: TextStyle(
                color: const Color(0xFF5C2D91),
                fontWeight: FontWeight.w600,
                fontSize: sw * 0.042,
              ),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: sw * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: sh * 0.04),
                  Text(
                    "Hi ${_firstName.replaceAll(RegExp(r'[0-9]'), '')},",
                    style: TextStyle(
                      fontSize: sw * 0.07,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  SizedBox(height: sh * 0.01),
                  Text(
                    "How are you feeling today? I'm here to listen and help you find clarity.",
                    style: TextStyle(fontSize: sw * 0.04, height: 1.4),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: sh * 0.17,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _cards.length,
                      separatorBuilder: (_, __) => SizedBox(width: sw * 0.04),
                      itemBuilder: (context, index) {
                        final card = _cards[index];
                        return GestureDetector(
                          onTap: () => _goToConversation(card.text),
                          child: _buildCard(sw, sh, card.image, card.text),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: sh * 0.03),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: sw * 0.05,
                      vertical: sw * 0.025,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            onSubmitted: (val) {
                              if (val.trim().isNotEmpty) {
                                _goToConversation(val.trim());
                              }
                            },
                            decoration: InputDecoration(
                              hintText: "Let's talk",
                              hintStyle: TextStyle(
                                color: const Color(0xFFB8B8B8),
                                fontSize: sw * 0.043,
                                fontWeight: FontWeight.bold,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            final text = _controller.text.trim();
                            if (text.isNotEmpty) _goToConversation(text);
                          },
                          child: Container(
                            width: sw * 0.12,
                            height: sw * 0.12,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF1ECFF),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Image.asset(
                                "assets/chatbot welcome4.png",
                                width: sw * 0.12,
                                height: sw * 0.12,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: sh * 0.02),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCard(double sw, double sh, String imagePath, String text) {
    return Container(
      width: sw * 0.3,
      padding: EdgeInsets.all(sw * 0.03),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            width: sw * 0.07,
            height: sw * 0.07,
            fit: BoxFit.contain,
          ),
          SizedBox(height: sw * 0.025),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: sw * 0.028, height: 1.2),
          ),
        ],
      ),
    );
  }
}