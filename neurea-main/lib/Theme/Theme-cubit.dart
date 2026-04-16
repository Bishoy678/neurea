// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class ThemeCubit extends Cubit<ThemeMode> {
//   ThemeCubit() : super(ThemeMode.system) {
//     _loadTheme();
//   }

//   Future<void> _loadTheme() async {
//     final prefs = await SharedPreferences.getInstance();
//     final theme = prefs.getString('theme') ?? 'system';
//     emit(_fromString(theme));
//   }

//   Future<void> setTheme(ThemeMode mode) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('theme', _toString(mode));
//     emit(mode);
//   }

//   void toggleTheme() {
//     if (state == ThemeMode.light) {
//       setTheme(ThemeMode.dark);
//     } else {
//       setTheme(ThemeMode.light);
//     }
//   }

//   String _toString(ThemeMode mode) {
//     switch (mode) {
//       case ThemeMode.light:
//         return 'light';
//       case ThemeMode.dark:
//         return 'dark';
//       default:
//         return 'system';
//     }
//   }

//   ThemeMode _fromString(String value) {
//     switch (value) {
//       case 'light':
//         return ThemeMode.light;
//       case 'dark':
//         return ThemeMode.dark;
//       default:
//         return ThemeMode.system;
//     }
//   }
// }