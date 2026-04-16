// ignore_for_file: control_flow_in_finally
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neurea/core/presentation/screens/Notification_Helper.dart'
    show NotificationHelper;
import 'package:neurea/features/before_after_view.dart';
import 'package:neurea/features/login_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmergencycontactView extends StatefulWidget {
  final String? userId;

  const EmergencycontactView({super.key, this.userId});

  @override
  State<EmergencycontactView> createState() => _EmergencycontactViewState();
}

class _EmergencycontactViewState extends State<EmergencycontactView> {
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _showSnack(String msg, {bool isError = true}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> _next() async {
    final phone = _phoneController.text.trim();

    if (phone.isEmpty) {
      _showSnack('Please enter a phone number');
      return;
    }
    if (phone.length != 11) {
      _showSnack('Phone number must be 11 digits');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final currentUser = Supabase.instance.client.auth.currentUser;
      final userId = currentUser?.id ?? widget.userId;

      if (userId == null || userId.isEmpty) {
        _showSnack('Error: User not found. Please log in again.');
        return;
      }

      await Supabase.instance.client
          .from('emergency_contacts')
          .insert({
            'user_id': userId,
            'phone': phone,
          });

      if (currentUser != null) {
        await NotificationHelper.send(
          title: 'Emergency Contact Added',
          description:
              'Your emergency contact has been saved successfully. You\'re all set!',
          type: 'general',
        );
      }

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const BeforeAfterView()),
      );
    } catch (e) {
      _showSnack('Error: ${e.toString()}');
    } finally {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(elevation: 0, backgroundColor: Colors.transparent),
      body: SafeArea(
          child: ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  'assets/LOGO.png',
                  height: screenHeight * 0.1,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                'Emergency contact',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF2A2F41),
                  fontSize: screenWidth * 0.055,
                  fontWeight: FontWeight.w600,
                  height: 1.40,
                ),
              ),
              SizedBox(height: screenHeight * 0.012),
              Text(
                'Give Us a number most one you trust',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF67747A),
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Mobile phone',
                  style: TextStyle(
                    color: const Color(0xFF67747A),
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 11,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: '01xxxxxxxxx',
                  counterText: '',
                  filled: true,
                  fillColor: const Color(0xFFF2F6FB),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  errorText:
                      _phoneController.text.isNotEmpty &&
                          _phoneController.text.length < 11
                      ? 'Phone number must be 11 digits'
                      : null,
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              SizedBox(
                width: double.infinity,
                height: screenHeight * 0.07,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _next,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7A2BAF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Next',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              Center(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(
                          color: const Color(0xFF2A2F41),
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: 'Log in',
                        style: TextStyle(
                          color: const Color(0xFF5C2D91),
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w600,
                          height: 1.40,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginView(),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.35),
              Center(
                child: Container(
                  width: 150,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
            ],
          ),
        ),
      ),
      ),
    );
  }
}