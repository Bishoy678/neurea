// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neurea/cubit/auth/auth_cubit.dart';
import 'package:neurea/cubit/auth/auth_state.dart';
import 'package:neurea/features/Forget_Password3.dart';
import 'package:pinput/pinput.dart';
import 'dart:async';

class ForgetPassword2 extends StatefulWidget {
  final String email;
  const ForgetPassword2({super.key, required this.email});

  @override
  State<ForgetPassword2> createState() => _ForgetPassword2State();
}

class _ForgetPassword2State extends State<ForgetPassword2> {
  final _pinController = TextEditingController();
  bool _isResending = false;
  int _resendCooldown = 0;
  Timer? _cooldownTimer;

  final _defaultPinTheme = PinTheme(
    width: 50,
    height: 55,
    textStyle: const TextStyle(
      fontSize: 20,
      color: Color(0xFF2A2F41),
      fontWeight: FontWeight.w600,
    ),
    decoration: BoxDecoration(
      border: Border.all(color: const Color(0xFFD0D0D0)),
      borderRadius: BorderRadius.circular(12),
      color: const Color(0xFFF2F6FB),
    ),
  );

  @override
  void initState() {
    super.initState();
    _startCooldown();
  }

  @override
  void dispose() {
    _pinController.dispose();
    _cooldownTimer?.cancel();
    super.dispose();
  }

  void _startCooldown() {
    setState(() => _resendCooldown = 60);
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCooldown <= 1) {
        timer.cancel();
        _cooldownTimer = null;
        if (mounted) {
          setState(() => _resendCooldown = 0);
        }
      } else if (mounted) {
        setState(() => _resendCooldown--);
      }
    });
  }

  Future<void> _resendCode(BuildContext context) async {
    if (_isResending || _resendCooldown > 0) return;
    
    setState(() => _isResending = true);
    
    try {
      await context.read<AuthCubit>().resendOTP(email: widget.email);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('New verification code sent to your email!'),
            backgroundColor: Colors.green,
          ),
        );
        _pinController.clear();
        _startCooldown();
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = e.toString();
        if (errorMessage.contains('you can only request this after')) {
          final regex = RegExp(r'after (\d+) seconds');
          final match = regex.firstMatch(errorMessage);
          if (match != null) {
            final waitSeconds = int.parse(match.group(1)!);
            setState(() => _resendCooldown = waitSeconds + 2);
            _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
              if (_resendCooldown <= 1) {
                timer.cancel();
                _cooldownTimer = null;
                if (mounted) {
                  setState(() => _resendCooldown = 0);
                }
              } else if (mounted) {
                setState(() => _resendCooldown--);
              }
            });
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Please wait ${_resendCooldown}s before trying again'),
              backgroundColor: Colors.orange,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to resend code: ${errorMessage.split(':').last}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isResending = false);
      }
    }
  }

  void _verify(BuildContext context) {
    if (_pinController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the full 6-digit code'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    context.read<AuthCubit>().verifyOTP(
      email: widget.email,
      token: _pinController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(),
      child: Builder(
        builder: (context) => BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              if (state.isResend == false) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ForgetPassword3()),
                );
              }
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Invalid code: ${state.message}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;
            return Scaffold(
              appBar: AppBar(elevation: 0),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(child: Image.asset('assets/LOGO.png')),
                    const Text(
                      'Check your email',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF2A2F41),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: const TextStyle(
                            color: Color(0xFF67747A),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          children: [
                            const TextSpan(
                              text: "We've sent verification code to ",
                            ),
                            TextSpan(
                              text: widget.email,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Pinput(
                      controller: _pinController,
                      length: 6,
                      defaultPinTheme: _defaultPinTheme,
                      focusedPinTheme: _defaultPinTheme.copyDecorationWith(
                        border: Border.all(
                          color: const Color(0xFF7A2BAF),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      submittedPinTheme: _defaultPinTheme.copyWith(
                        decoration: _defaultPinTheme.decoration!.copyWith(
                          color: const Color(0xFFEDE7F6),
                          border: Border.all(color: const Color(0xFF7A2BAF)),
                        ),
                      ),
                      showCursor: true,
                      onCompleted: (pin) => context.read<AuthCubit>().verifyOTP(
                        email: widget.email,
                        token: pin,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Didn't receive the code? ",
                          style: TextStyle(
                            color: Color(0xFF67747A),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _resendCode(context),
                          child: Text(
                            _resendCooldown > 0 
                                ? "Resend (${_resendCooldown}s)" 
                                : (_isResending ? "Sending..." : "Resend"),
                            style: const TextStyle(
                              color: Color(0xFF6C3BAA),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 340),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : () => _verify(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6C3BAA),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  "Verify Code",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
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
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}