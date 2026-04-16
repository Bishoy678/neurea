import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:neurea/features/Emergency_contact_View.dart';
import 'package:neurea/Service/Auth_Service.dart';
import 'package:neurea/features/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreatePasswordView extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String gender;

  const CreatePasswordView({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.gender,
  });

  @override
  State<CreatePasswordView> createState() => _CreatePasswordViewState();
}

class _CreatePasswordViewState extends State<CreatePasswordView> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscure = true;
  bool _isLoading = false;
  bool _saveInfo = false;

  static final _db = Supabase.instance.client;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _onNext() async {
    final password = _passwordController.text.trim();
    final confirm = _confirmController.text.trim();

    if (password.isEmpty || confirm.isEmpty) {
      _showError('Please enter password and confirm it');
      return;
    }
    if (password.length < 6) {
      _showError('Password must be at least 6 characters');
      return;
    }
    if (password != confirm) {
      _showError('Passwords do not match');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final isDuplicatePhone = await _isPhoneTaken();
      if (!mounted) return;
      if (isDuplicatePhone) {
        _showError('This phone number is already registered');
        return;
      }

      final userId = await AuthService.signUp(
        email: widget.email,
        password: password,
        firstName: widget.firstName,
        lastName: widget.lastName,
        gender: widget.gender,
        phone: widget.phone,
      );

      if (_saveInfo) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('saved_email', widget.email);
        await prefs.setString('saved_password', password);
      }

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => EmergencycontactView(userId: userId)),
      );
    } on AuthException catch (e) {
      if (!mounted) return;
      final msg = e.message.toLowerCase();
      if (msg.contains('already registered') ||
          msg.contains('already exists') ||
          msg.contains('user already')) {
        _showError('This email is already registered');
      } else {
        _showError(e.message);
      }
    } catch (e) {
      if (!mounted) return;
      final msg = e.toString().toLowerCase();

      if (msg.contains('profiles_phone_key') || msg.contains('duplicate key')) {
        _showError('This phone number is already registered');
      } else {
        _showError(e.toString().replaceAll('Exception:', '').trim());
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<bool> _isPhoneTaken() async {
    final result = await _db
        .from('profiles')
        .select('id')
        .eq('phone', widget.phone)
        .maybeSingle();
    return result != null;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(elevation: 0),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: sw * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Image.asset('assets/LOGO.png')),
              const SizedBox(height: 5),
              const Center(
                child: Text(
                  'Create your password',
                  style: TextStyle(
                    color: Color(0xFF2A2F41),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'For your security, use a unique password of at least 6 characters.',
                style: TextStyle(
                  color: Color(0xFF67747A),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              const _Label('Password'),
              const SizedBox(height: 8),
              _PasswordField(
                controller: _passwordController,
                obscure: _obscure,
                onToggle: () => setState(() => _obscure = !_obscure),
              ),
              const SizedBox(height: 20),
              const _Label('Confirm Password'),
              const SizedBox(height: 8),
              _PasswordField(
                controller: _confirmController,
                obscure: _obscure,
                onToggle: () => setState(() => _obscure = !_obscure),
              ),
              const SizedBox(height: 20),
              _SaveInfoCheckbox(
                value: _saveInfo,
                onChanged: (v) => setState(() => _saveInfo = v),
              ),
              const SizedBox(height: 20),
              _PrimaryButton(
                label: 'Next',
                isLoading: _isLoading,
                onPressed: _onNext,
              ),
              const SizedBox(height: 30),
              Center(
                child: _AuthRedirectText(
                  question: 'Already have an account? ',
                  action: 'Log in',
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginView()),
                  ),
                ),
              ),
              const SizedBox(height: 150),
              const _BottomBar(),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF67747A),
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggle;

  const _PasswordField({
    required this.controller,
    required this.obscure,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF2F6FB),
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility : Icons.visibility_off),
          onPressed: onToggle,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

class _SaveInfoCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SaveInfoCheckbox({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: value ? const Color(0xFF7A2BAF) : Colors.transparent,
              border: Border.all(
                color: value ? const Color(0xFF7A2BAF) : Colors.grey,
                width: 2,
              ),
            ),
            child: value
                ? const Icon(Icons.check, size: 14, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 10),
          const Text(
            'Save my information',
            style: TextStyle(
              color: Color(0xFF67747A),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback? onPressed;

  const _PrimaryButton({
    required this.label,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF7A2BAF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}

class _AuthRedirectText extends StatelessWidget {
  final String question;
  final String action;
  final VoidCallback onTap;

  const _AuthRedirectText({
    required this.question,
    required this.action,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: question,
            style: const TextStyle(
              color: Color(0xFF2A2F41),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(
            text: action,
            style: const TextStyle(
              color: Color(0xFF5C2D91),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            recognizer: TapGestureRecognizer()..onTap = onTap,
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 150,
        height: 5,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}