// // ignore_for_file: use_build_context_synchronously
// import 'package:flutter/material.dart';
// import 'package:neurea/Service/Auth_Service.dart';
// import 'package:neurea/core/presentation/screens/Privacy_Policy_Screen.dart';
// import 'package:neurea/features/auth/presentation/views/signup_view.dart';
// import 'package:neurea/Home/Home_Screen_daily.dart';

// class CreateSafeSpaceScreen extends StatefulWidget {
//   final String userId;
//   const CreateSafeSpaceScreen({super.key, required this.userId});

//   @override
//   State<CreateSafeSpaceScreen> createState() => _CreateSafeSpaceScreenState();
// }

// class _CreateSafeSpaceScreenState extends State<CreateSafeSpaceScreen> {
//   bool _isLoading = false;

//   Future<void> _googleSignIn() async {
//     setState(() => _isLoading = true);
//     try {
//       await AuthService.signInWithGoogle();
//       if (!mounted) return;
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const HomeScreenDaily()),
//       );
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Google sign in failed: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const Padding(
//               padding: EdgeInsets.only(right: 110, top: 20),
//               child: Text(
//                 'Create Your Safe Space',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF2A2F41),
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             const SizedBox(height: 5),
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 25),
//               child: Text(
//                 'Your data is private. Only used to support your wellness journey.',
//                 style: TextStyle(
//                   fontSize: 14,
//                   height: 1.3,
//                   color: Color(0xFF67747A),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Image.asset(
//               'assets/Meditation Person.png',
//               width: 300,
//               fit: BoxFit.contain,
//             ),
//             const SizedBox(height: 20),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: SizedBox(
//                 width: double.infinity,
//                 height: 56,
//                 child: ElevatedButton(
//                   onPressed: () => Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(builder: (_) => const SignupView()),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF7A2BAF),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                   ),
//                   child: const Text(
//                     'Continue with Email',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16),
//               child: Row(
//                 children: [
//                   Expanded(child: Divider()),
//                   Text("   or   "),
//                   Expanded(child: Divider()),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 10),
//             SizedBox(
//               height: 60,
//               width: 330,
//               child: OutlinedButton(
//                 onPressed: _isLoading ? null : _googleSignIn,
//                 style: OutlinedButton.styleFrom(
//                   side: const BorderSide(color: Colors.grey),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   backgroundColor: Colors.white,
//                 ),
//                 child: _isLoading
//                     ? const CircularProgressIndicator(color: Color(0xFF7A2BAF))
//                     : Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Image.asset('assets/google_icon.png', height: 24),
//                           const SizedBox(width: 13),
//                           const Text(
//                             "Continue with google",
//                             style: TextStyle(
//                               fontSize: 18,
//                               color: Colors.black87,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             GestureDetector(
//               onTap: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
//               ),
//               child: const Text(
//                 'Privacy Policy  |  Terms of use',
//                 style: TextStyle(fontSize: 14),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             const SizedBox(height: 50),
//             Container(
//               width: 150,
//               height: 5,
//               decoration: BoxDecoration(
//                 color: Colors.black,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
