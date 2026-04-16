// import 'package:flutter/material.dart';

// class AppTheme {
//   /// 🎨 الألوان الأساسية (نفس اللي انت مستخدمها)
//   static const primary = Color(0xFF7A2BAF);
//   static const lightBackground = Colors.white;
//   static const darkBackground = Color(0xFF121212);

//   static const fieldColor = Color(0xFFF2F6FB);
//   static const textPrimary = Color(0xFF2A2F41);
//   static const textSecondary = Color(0xFF67747A);

//   /// ================= LIGHT =================
//   static ThemeData light = ThemeData(
//     brightness: Brightness.light,

//     scaffoldBackgroundColor: lightBackground,

//     colorScheme: const ColorScheme.light(
//       primary: primary,
//     ),

//     /// AppBar
//     appBarTheme: const AppBarTheme(
//       elevation: 0,
//       backgroundColor: Colors.transparent,
//       iconTheme: IconThemeData(color: textPrimary),
//     ),

//     /// Text
//     textTheme: const TextTheme(
//       titleMedium: TextStyle(
//         color: textPrimary,
//         fontSize: 20,
//         fontWeight: FontWeight.w600,
//       ),
//       bodyMedium: TextStyle(
//         color: textSecondary,
//         fontSize: 16,
//         fontWeight: FontWeight.w500,
//       ),
//     ),

//     /// Input (هيطبق على TextField)
//     inputDecorationTheme: InputDecorationTheme(
//       filled: true,
//       fillColor: fieldColor,
//       hintStyle: const TextStyle(color: Colors.grey),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: BorderSide.none,
//       ),
//     ),

//     /// Button
//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: primary,
//         foregroundColor: Colors.white,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(30),
//         ),
//         textStyle: const TextStyle(
//           fontSize: 20,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     ),
//   );

//   /// ================= DARK =================
//   static ThemeData dark = ThemeData(
//     brightness: Brightness.dark,

//     scaffoldBackgroundColor: darkBackground,

//     colorScheme: const ColorScheme.dark(
//       primary: primary,
//     ),

//     appBarTheme: const AppBarTheme(
//       elevation: 0,
//       backgroundColor: Colors.transparent,
//       iconTheme: IconThemeData(color: Colors.white),
//     ),

//     textTheme: const TextTheme(
//       titleMedium: TextStyle(
//         color: Colors.white,
//         fontSize: 20,
//         fontWeight: FontWeight.w600,
//       ),
//       bodyMedium: TextStyle(
//         color: Colors.grey,
//         fontSize: 16,
//         fontWeight: FontWeight.w500,
//       ),
//     ),

//     inputDecorationTheme: InputDecorationTheme(
//       filled: true,
//       fillColor: Color(0xFF1E1E1E),
//       hintStyle: const TextStyle(color: Colors.grey),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: BorderSide.none,
//       ),
//     ),

//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: primary,
//         foregroundColor: Colors.white,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(30),
//         ),
//       ),
//     ),
//   );
// }