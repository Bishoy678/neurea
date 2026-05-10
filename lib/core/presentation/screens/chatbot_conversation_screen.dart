// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
// import 'package:flutter_chat_ui/flutter_chat_ui.dart';
// import 'package:neurea/core/presentation/screens/crisis_support_screen.dart';

// class ChatbotConversationScreen extends StatefulWidget {
//   final String? initialMessage;
//   const ChatbotConversationScreen({super.key, this.initialMessage});

//   @override
//   State<ChatbotConversationScreen> createState() =>
//       _ChatbotConversationScreenState();
// }

// class _ChatbotConversationScreenState extends State<ChatbotConversationScreen> {
//   final List<types.Message> _messages = [];
//   final _user = const types.User(id: 'user', firstName: 'You');
//   final _bot = const types.User(id: 'bot', firstName: 'Neurea');
//   bool _showOptions = false;

//   final List<String> _options = [
//     "Work Pressure",
//     "Relation issues",
//     "Health concerns",
//     "Financial issues",
//   ];

//   String _randomId() => Random().nextInt(999999).toString();

//   @override
//   void initState() {
//     super.initState();

//     Future.delayed(const Duration(milliseconds: 500), () {
//       if (!mounted) return;
//       final botMsg = types.TextMessage(
//         author: _bot,
//         id: _randomId(),
//         text: "Hello! I'm Neurea, your AI Therapist. I'm here to help you. What are you going through today?",
//         createdAt: DateTime.now().millisecondsSinceEpoch,
//       );
//       setState(() {
//         _messages.insert(0, botMsg);
//         _showOptions = true;
//       });
//     });

//     if (widget.initialMessage != null && widget.initialMessage!.isNotEmpty) {
//       Future.microtask(() => _handleUserMessage(widget.initialMessage!));
//     }
//   }

//   void _handleUserMessage(String text) {
//     final userMsg = types.TextMessage(
//       author: _user,
//       id: _randomId(),
//       text: text,
//       createdAt: DateTime.now().millisecondsSinceEpoch,
//     );
//     setState(() {
//       _messages.insert(0, userMsg);
//       _showOptions = false;
//     });
//     Future.delayed(const Duration(milliseconds: 800), () => _addBotReply(text));
//   }

//   void _addBotReply(String userMessage) {
//     final lower = userMessage.toLowerCase();
//     String reply;
//     bool showOptions = false;

//     if (lower.contains('breakdown') ||
//         lower.contains('emotional') ||
//         lower.contains('feeling')) {
//       reply =
//           "I understand. Let's work through this together. What's causing your emotional breakdown?";
//       showOptions = true;
//     } else if (lower.contains('work') || lower.contains('pressure')) {
//       reply =
//           "Work pressure can be really overwhelming. Have you tried setting boundaries or talking to your manager about your workload?";
//     } else if (lower.contains('relation')) {
//       reply =
//           "Relationship issues can be emotionally draining. Would you like to talk more about what's going on?";
//     } else if (lower.contains('health')) {
//       reply =
//           "Health concerns can cause a lot of anxiety. Are you currently seeing a doctor about this?";
//     } else if (lower.contains('financial') || lower.contains('money')) {
//       reply =
//           "Financial stress is very common. Let's think about small steps you can take to feel more in control.";
//     } else if (lower.contains('overwhelm')) {
//       reply =
//           "Feeling overwhelmed is tough. Let's break things down into smaller steps. What's the biggest thing on your mind right now?";
//     } else if (lower.contains('positive') || lower.contains('focus')) {
//       reply =
//           "That's a great mindset! Let's start with one thing you're grateful for today. What comes to mind?";
//     } else {
//       reply =
//           "Thank you for sharing that with me. I'm here for you. Can you tell me more about what you're going through?";
//     }

//     final botMsg = types.TextMessage(
//       author: _bot,
//       id: _randomId(),
//       text: reply,
//       createdAt: DateTime.now().millisecondsSinceEpoch,
//     );
//     setState(() {
//       _messages.insert(0, botMsg);
//       _showOptions = showOptions;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final sw = MediaQuery.of(context).size.width;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F7),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0.5,
//         leading: GestureDetector(
//           onTap: () => Navigator.pop(context),
//           child: const Icon(Icons.arrow_back, color: Colors.black),
//         ),
//         title: Text(
//           "Neurea (AI Therapist)",
//           style: TextStyle(
//             color: const Color(0xFF5C2D91),
//             fontWeight: FontWeight.w600,
//             fontSize: sw * 0.042,
//           ),
//         ),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: Icon(
//               Icons.warning_amber_rounded,
//               color: const Color(0xFF5C2D91),
//               size: sw * 0.06,
//             ),
//             tooltip: 'Crisis Support',
//             onPressed: () => Navigator.push(
//               context,
//               MaterialPageRoute(builder: (_) => const CrisisSupportScreen()),
//             ),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Chat(
//               messages: _messages,
//               onSendPressed: (msg) => _handleUserMessage(msg.text),
//               user: _user,
//               showUserAvatars: false,
//               showUserNames: false,
//               theme: DefaultChatTheme(
//                 primaryColor: const Color(0xFF5C2D91),
//                 secondaryColor: Colors.white,
//                 inputBackgroundColor: Colors.white,
//                 inputBorderRadius: BorderRadius.circular(30),
//                 inputTextColor: Colors.black87,
//                 backgroundColor: const Color(0xFFF5F5F7),
//                 sentMessageBodyTextStyle: TextStyle(
//                   color: Colors.white,
//                   fontSize: sw * 0.037,
//                   height: 1.5,
//                 ),
//                 receivedMessageBodyTextStyle: TextStyle(
//                   color: Colors.black87,
//                   fontSize: sw * 0.037,
//                   height: 1.5,
//                 ),
//                 inputTextStyle: TextStyle(fontSize: sw * 0.04),
//                 inputContainerDecoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(30),
//                   border: Border.all(color: Colors.grey.shade200),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.05),
//                       blurRadius: 8,
//                       offset: const Offset(0, -2),
//                     ),
//                   ],
//                 ),
//                 messageInsetsHorizontal: sw * 0.04,
//                 messageInsetsVertical: sw * 0.03,
//               ),
//             ),
//           ),
//           if (_showOptions)
//             Container(
//               color: Colors.white,
//               padding: EdgeInsets.fromLTRB(
//                 sw * 0.04,
//                 sw * 0.03,
//                 sw * 0.04,
//                 sw * 0.04,
//               ),
//               child: Wrap(
//                 spacing: sw * 0.03,
//                 runSpacing: sw * 0.03,
//                 children: _options.map((opt) {
//                   return GestureDetector(
//                     onTap: () => _handleUserMessage(opt),
//                     child: Container(
//                       padding: EdgeInsets.symmetric(
//                         vertical: sw * 0.035,
//                         horizontal: sw * 0.05,
//                       ),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFEDE7F6),
//                         borderRadius: BorderRadius.circular(14),
//                       ),
//                       child: Text(
//                         opt,
//                         style: TextStyle(
//                           fontSize: sw * 0.035,
//                           fontWeight: FontWeight.w500,
//                           color: const Color(0xFF5C2D91),
//                         ),
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }  

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:neurea/Service/chatbot_service.dart';
import 'package:neurea/core/presentation/screens/crisis_support_screen.dart';


class ChatbotConversationScreen extends StatefulWidget {
  final String? initialMessage;
  const ChatbotConversationScreen({super.key, this.initialMessage});

  @override
  State<ChatbotConversationScreen> createState() =>
      _ChatbotConversationScreenState();
}

class _ChatbotConversationScreenState extends State<ChatbotConversationScreen> {
  final List<types.Message> _messages = [];
  final _user = const types.User(id: 'user', firstName: 'You');
  final _bot = const types.User(id: 'bot', firstName: 'Neurea');
  bool _showOptions = false;
  bool _isBotTyping = false;

  final List<String> _options = [
    "Work Pressure",
    "Relation issues",
    "Health concerns",
    "Financial issues",
  ];

  String _randomId() => Random().nextInt(999999).toString();

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      final botMsg = types.TextMessage(
        author: _bot,
        id: _randomId(),
        text: "Hello! I'm Neurea, your AI Therapist. I'm here to help you. What are you going through today?",
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );
      setState(() {
        _messages.insert(0, botMsg);
        _showOptions = true;
      });
    });

    if (widget.initialMessage != null && widget.initialMessage!.isNotEmpty) {
      Future.microtask(() => _handleUserMessage(widget.initialMessage!));
    }
  }

  void _handleUserMessage(String text) {
    final userMsg = types.TextMessage(
      author: _user,
      id: _randomId(),
      text: text,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    setState(() {
      _messages.insert(0, userMsg);
      _showOptions = false;
      _isBotTyping = true;
    });
    
    _sendToChatbot(text);
  }

  Future<void> _sendToChatbot(String userMessage) async {
    try {
      final botReplyText = await ChatService.sendMessage(userMessage);
      
      if (!mounted) return;
      
      final botMsg = types.TextMessage(
        author: _bot,
        id: _randomId(),
        text: botReplyText,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );
      
      setState(() {
        _messages.insert(0, botMsg);
        _isBotTyping = false;
      });

      _checkForOptions(botReplyText);
      
    } catch (e) {
      if (!mounted) return;
      
     
      final errorMsg = types.TextMessage(
        author: _bot,
        id: _randomId(),
        text: "I'm having trouble connecting right now. Please check your internet and try again. I'm here when you're ready.",
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );
      
      setState(() {
        _messages.insert(0, errorMsg);
        _isBotTyping = false;
      });
    }
  }

  
  void _checkForOptions(String botReply) {
    final lowerReply = botReply.toLowerCase();
   
    if (lowerReply.contains('tell me more') || 
        lowerReply.contains('what\'s causing') ||
        lowerReply.contains('can you share')) {
      setState(() {
        _showOptions = true;
      });
    } else {
      setState(() {
        _showOptions = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
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
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.warning_amber_rounded,
              color: const Color(0xFF5C2D91),
              size: sw * 0.06,
            ),
            tooltip: 'Crisis Support',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CrisisSupportScreen()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Chat(
              messages: _messages,
              onSendPressed: (msg) => _handleUserMessage(msg.text),
              user: _user,
              showUserAvatars: false,
              showUserNames: false,
              theme: DefaultChatTheme(
                primaryColor: const Color(0xFF5C2D91),
                secondaryColor: Colors.white,
                inputBackgroundColor: Colors.white,
                inputBorderRadius: BorderRadius.circular(30),
                inputTextColor: Colors.black87,
                backgroundColor: const Color(0xFFF5F5F7),
                sentMessageBodyTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: sw * 0.037,
                  height: 1.5,
                ),
                receivedMessageBodyTextStyle: TextStyle(
                  color: Colors.black87,
                  fontSize: sw * 0.037,
                  height: 1.5,
                ),
                inputTextStyle: TextStyle(fontSize: sw * 0.04),
                inputContainerDecoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                messageInsetsHorizontal: sw * 0.04,
                messageInsetsVertical: sw * 0.03,
              ),
            ),
          ),
      
          if (_isBotTyping)
            Container(
              padding: EdgeInsets.symmetric(horizontal: sw * 0.04, vertical: sw * 0.02),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(sw * 0.025),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: SizedBox(
                      width: sw * 0.08,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildTypingDot(sw, 0),
                          _buildTypingDot(sw, 0.3),
                          _buildTypingDot(sw, 0.6),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (_showOptions && !_isBotTyping) 
            Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(
                sw * 0.04,
                sw * 0.03,
                sw * 0.04,
                sw * 0.04,
              ),
              child: Wrap(
                spacing: sw * 0.03,
                runSpacing: sw * 0.03,
                children: _options.map((opt) {
                  return GestureDetector(
                    onTap: () => _handleUserMessage(opt),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: sw * 0.035,
                        horizontal: sw * 0.05,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDE7F6),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        opt,
                        style: TextStyle(
                          fontSize: sw * 0.035,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF5C2D91),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTypingDot(double sw, double delay) {
    return AnimatedOpacity(
      opacity: _isBotTyping ? 1.0 : 0.0,
      duration: Duration(milliseconds: 500),
      child: Container(
        width: sw * 0.025,
        height: sw * 0.025,
        decoration: BoxDecoration(
          color: const Color(0xFF5C2D91),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}