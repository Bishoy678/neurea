import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neurea/core/presentation/screens/Help_Center_Screen.dart';
import 'package:neurea/core/presentation/screens/Make_Report_Screen.dart';
import 'package:neurea/core/presentation/screens/Privacy_Policy_Screen.dart';
import 'package:neurea/cubit/auth/auth_cubit.dart';
import 'package:neurea/cubit/auth/auth_state.dart';
import 'package:neurea/features/Forget_password.dart';
import 'package:neurea/Home/Home_Screen_daily.dart';
import 'package:neurea/features/auth/presentation/views/signup_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;
  bool _saveInfo = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('saved_email');
    final savedPassword = prefs.getString('saved_password');
    
    print('═══════════════════════════════════════');
    print('📧 Saved Email from storage: $savedEmail');
    print('🔑 Saved Password from storage: $savedPassword');
    print('═══════════════════════════════════════');
    
    if (savedEmail != null && savedPassword != null) {
      setState(() {
        _emailController.text = savedEmail;
        _passwordController.text = savedPassword;
        _saveInfo = true;
      });
      print('✅ Fields populated successfully');
    } else {
      print('❌ No saved credentials found');
    }
  }

  void _onLogin(BuildContext context, AuthCubit cubit) {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showError(context, 'Please enter email and password');
      return;
    }
    cubit.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: _handleState,
        builder: _buildBody,
      ),
    );
  }

  void _handleState(BuildContext context, AuthState state) {
    if (state is AuthSuccess) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreenDaily()),
      );
    } else if (state is AuthError) {
      _showError(context, state.message);
    }
  }

  Widget _buildBody(BuildContext context, AuthState state) {
    final isLoading = state is AuthLoading;
    final cubit = context.read<AuthCubit>();
    final sw = MediaQuery.of(context).size.width;

     return Scaffold(
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: sw * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              Center(child: Image.asset('assets/LOGO.png')),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  "Let's get back to it",
                  style: TextStyle(
                    color: Color(0xFF2A2F41),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _Label('Email'),
              const SizedBox(height: 8),
              _AppTextField(
                controller: _emailController,
                hint: 'YourEmail@gmail.com',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              _Label('Password'),
              const SizedBox(height: 8),
              _AppTextField(
                controller: _passwordController,
                obscure: _obscure,
                suffix: _TogglePasswordIcon(
                  obscure: _obscure,
                  onTap: () => setState(() => _obscure = !_obscure),
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ForgetPassword()),
                  ),
                  child: const Text(
                    'Forget Password?',
                    style: TextStyle(
                      color: Color(0xFF5C2D91),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _SaveInfoCheckbox(
                value: _saveInfo,
                onChanged: (v) => setState(() => _saveInfo = v),
              ),
              const SizedBox(height: 20),
              _PrimaryButton(
                label: 'Log in',
                isLoading: isLoading,
                onPressed: () => _onLogin(context, cubit),
              ),
              const SizedBox(height: 20),
              const _Divider(),
              const SizedBox(height: 20),
              _GoogleButton(
                isLoading: isLoading,
                onPressed: () => cubit.loginWithGoogle(),
                sw: sw,
              ),
              const SizedBox(height: 30),
              Center(
                child: _AuthRedirectText(
                  question: "Don't have an account? ",
                  action: 'Sign up',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SignupView()),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              const _FooterLinks(),
              const SizedBox(height: 30),
              const _BottomBar(),
              const SizedBox(height: 10),
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

class _AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;
  final bool obscure;
  final Widget? suffix;

  const _AppTextField({
    required this.controller,
    this.hint = '',
    this.keyboardType = TextInputType.text,
    this.obscure = false,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF99A3A6), fontSize: 14),
        filled: true,
        fillColor: const Color(0xFFF2F6FB),
        suffixIcon: suffix,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF7A2BAF), width: 2),
        ),
      ),
    );
  }
}

class _TogglePasswordIcon extends StatelessWidget {
  final bool obscure;
  final VoidCallback onTap;
  const _TogglePasswordIcon({required this.obscure, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(obscure ? Icons.visibility : Icons.visibility_off),
      onPressed: onTap,
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

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: Divider()),
        Text("   or   "),
        Expanded(child: Divider()),
      ],
    );
  }
}

class _GoogleButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;
  final double sw;

  const _GoogleButton({
    required this.isLoading,
    required this.onPressed,
    required this.sw,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 60,
        width: sw * 0.85,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.grey.shade300),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/google_icon.png', height: 24),
              const SizedBox(width: 13),
              const Text(
                'Continue with Google',
                style: TextStyle(
                  color: Color(0xFF4A4A6A),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
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

class _FooterLinks extends StatelessWidget {
  const _FooterLinks();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
          ),
          child: const Text(
            'About',
            style: TextStyle(color: Color(0xFF2A2F41), fontSize: 14),
          ),
        ),
        const SizedBox(width: 25),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const HelpCenterScreen()),
          ),
          child: const Text(
            'Help',
            style: TextStyle(color: Color(0xFF2A2F41), fontSize: 14),
          ),
        ),
        const SizedBox(width: 25),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MakeReportScreen()),
          ),
          child: const Text(
            'More',
            style: TextStyle(color: Color(0xFF2A2F41), fontSize: 14),
          ),
        ),
      ],
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