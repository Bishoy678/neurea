import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neurea/features/auth/presentation/views/create_password_view.dart';
import 'package:neurea/features/login_view.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  String _selectedGender = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _onSignUp() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedGender.isEmpty) {
      _showError('Please select gender');
      return;
    }

    setState(() => _isLoading = true);
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CreatePasswordView(
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            email: _emailController.text.trim(),
            phone: _phoneController.text.trim(),
            gender: _selectedGender,
          ),
        ),
      );
    } catch (e) {
      _showError('Error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
      body: Form(
        key: _formKey,
        child: ScrollConfiguration(
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
                  'Create a new account',
                  style: TextStyle(
                    color: Color(0xFF2A2F41),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const _Label('Name'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _AppFormField(
                      controller: _firstNameController,
                      hint: 'First name',
                      validator: (v) => v == null || v.isEmpty
                          ? 'First name is required'
                          : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _AppFormField(
                      controller: _lastNameController,
                      hint: 'Last name',
                      validator: (v) => v == null || v.isEmpty
                          ? 'Last name is required'
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const _Label('Gender'),
              const SizedBox(height: 8),
              Row(
                children:
                    ['Male', 'Female', 'Other']
                        .map(
                          (g) => _GenderButton(
                            label: g,
                            isSelected: _selectedGender == g,
                            onTap: () => setState(() => _selectedGender = g),
                          ),
                        )
                        .toList()
                        .expand((w) => [w, const SizedBox(width: 10)])
                        .toList()
                      ..removeLast(),
              ),
              const SizedBox(height: 20),
              const _Label('Email'),
              const SizedBox(height: 8),
              _AppFormField(
                controller: _emailController,
                hint: 'YourEmail@gmail.com',
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
              ),
              const SizedBox(height: 20),
              const _Label('Mobile phone'),
              const SizedBox(height: 8),
              _AppFormField(
                controller: _phoneController,
                hint: 'Enter phone number',
                keyboardType: TextInputType.phone,
                maxLength: 11,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Phone number is required';
                  if (v.length != 11) return 'Phone number must be 11 digits';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _PrimaryButton(
                label: 'Sign up',
                isLoading: _isLoading,
                onPressed: _onSignUp,
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
              const SizedBox(height: 37),
              const _BottomBar(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your email';
    final emailRegex = RegExp(r'^[\w\.-]+@([\w-]+\.)+[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) return 'Enter a valid email';
    return null;
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

class _AppFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;

  const _AppFormField({
    required this.controller,
    this.hint = '',
    this.keyboardType = TextInputType.text,
    this.validator,
    this.maxLength,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        counterText: '',
        filled: true,
        fillColor: const Color(0xFFF2F6FB),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

class _GenderButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF7A2BAF)
                : const Color(0xFFF2F6FB),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF7A2BAF)
                  : Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF67747A),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
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
