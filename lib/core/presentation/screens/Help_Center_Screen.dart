// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:neurea/core/presentation/screens/profile_screen.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  bool _showFAQ = true;
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedCategory = 'Therapist Session Issue';
  final _messageController = TextEditingController();
  bool _isSending = false;

  final List<String> _categories = [
    'Therapist Session Issue',
    'Billing or Refund',
    'Account Management',
    'Other',
  ];
  final List<Map<String, dynamic>> _faqs = [
    {
      'question': 'How do I book a therapy session?',
      'answer':
          'Go to the "Therapist" tab in the bottom navigation menu. Browse the available professionals, click on their profile to see their schedule, and select an available time slot. You can choose between audio, video, or chat sessions.',
      'expanded': false,
    },
    {
      'question': 'How does the AI Therapist work?',
      'answer':
          'Our AI Therapist uses advanced natural language processing to provide immediate emotional support and coping strategies. You can access it anytime by tapping the purple sparkle button in the center of the bottom menu.',
      'expanded': false,
    },
    {
      'question': 'What is your refund policy?',
      'answer':
          'You can cancel or reschedule a therapy session for free up to 24 hours before the appointment time. Cancellations made within 24 hours of the session are not eligible for a refund.',
      'expanded': false,
    },
    {
      'question': 'Is my data secure?',
      'answer':
          'Yes. All chats, mood logs, and personal information are end-to-end encrypted. We comply with strict medical data privacy laws (HIPAA). Check our Privacy Policy for more details.',
      'expanded': false,
    },
  ];

  List<Map<String, dynamic>> get _filteredFaqs => _searchQuery.isEmpty
      ? _faqs
      : _faqs
            .where(
              (f) => f['question'].toString().toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ),
            )
            .toList();

  @override
  void dispose() {
    _searchController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please write your message'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    setState(() => _isSending = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isSending = false);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Message sent successfully ✅'),
        backgroundColor: Color(0xFF5C2D91),
      ),
    );
    _messageController.clear();
    await Future.delayed(const Duration(seconds: 1));
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfileScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: sw * 0.05,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Help Center',
          style: TextStyle(
            color: const Color(0xFF5C2D91),
            fontSize: sw * 0.045,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(sw * 0.05),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (v) => setState(() => _searchQuery = v),
                decoration: InputDecoration(
                  hintText: 'Search For help...',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: sw * 0.035,
                  ),
                  prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: sw * 0.035),
                ),
              ),
            ),
            SizedBox(height: sw * 0.04),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _showFAQ = true),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: sw * 0.03),
                        decoration: BoxDecoration(
                          color: _showFAQ
                              ? const Color(0xFF5C2D91)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'FAQ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _showFAQ ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: sw * 0.038,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _showFAQ = false),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: sw * 0.03),
                        decoration: BoxDecoration(
                          color: !_showFAQ
                              ? const Color(0xFF5C2D91)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Contact US',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: !_showFAQ ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: sw * 0.038,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: sw * 0.04),
            Expanded(child: _showFAQ ? _buildFAQ(sw) : _buildContactUs(sw)),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQ(double sw) {
    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(overscroll: false),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: _filteredFaqs.length,
          separatorBuilder: (_, __) =>
              Divider(height: 1, color: Colors.grey.shade100),
          itemBuilder: (context, i) {
            final faq = _filteredFaqs[i];
            return Column(
              children: [
                ListTile(
                  title: Text(
                    faq['question'],
                    style: TextStyle(
                      fontSize: sw * 0.035,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Icon(
                    faq['expanded']
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  onTap: () => setState(
                    () =>
                        _faqs[_faqs.indexWhere(
                              (f) => f['question'] == faq['question'],
                            )]['expanded'] =
                            !faq['expanded'],
                  ),
                ),
                if (faq['expanded'])
                  Padding(
                    padding: EdgeInsets.only(
                      left: sw * 0.04,
                      right: sw * 0.04,
                      bottom: sw * 0.03,
                    ),
                    child: Text(
                      faq['answer'],
                      style: TextStyle(
                        fontSize: sw * 0.03,
                        color: Colors.grey,
                        height: 1.5,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildContactUs(double sw) {
    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(overscroll: false),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Can\'t find the answer you\'re looking for? Send a message to our support team and we\'ll get back to you within 24 hours.',
              style: TextStyle(
                fontSize: sw * 0.033,
                color: Colors.grey,
                height: 1.5,
              ),
            ),
            SizedBox(height: sw * 0.05),
            Text(
              'What do you need help with?',
              style: TextStyle(fontSize: sw * 0.035, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: sw * 0.025),
            Container(
              padding: EdgeInsets.symmetric(horizontal: sw * 0.04),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCategory,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: _categories
                      .map(
                        (cat) => DropdownMenuItem(
                          value: cat,
                          child: Text(
                            cat,
                            style: TextStyle(fontSize: sw * 0.035),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _selectedCategory = v),
                ),
              ),
            ),
            SizedBox(height: sw * 0.04),
            Text(
              'Message',
              style: TextStyle(fontSize: sw * 0.035, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: sw * 0.025),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _messageController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Please describe your issue in detail...',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: sw * 0.033,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(sw * 0.04),
                ),
              ),
            ),
            SizedBox(height: sw * 0.06),
            SizedBox(
              width: double.infinity,
              height: sw * 0.14,
              child: ElevatedButton(
                onPressed: _isSending ? null : _sendMessage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5C2D91),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: _isSending
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Send Message',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: sw * 0.04,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            SizedBox(height: sw * 0.05),
          ],
        ),
      ),
    );
  }
}