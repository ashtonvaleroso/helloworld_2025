import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helloworld_2025/frontend/home_page/calendar_page.dart';
import 'package:helloworld_2025/global/main_initializations.dart';

/// Brand Colors for Flexender
class AppColors {
  static const primary = Color(0xFF6C63FF); // Indigo-Violet
  static const secondary = Color(0xFF00C896); // Mint Green
  static const accent = Color(0xFFFF7E5F); // Coral
}

Future<void> main() async {
  await initMain();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.interTextTheme();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system, // follow system setting
      theme: ThemeData(
        useMaterial3: true,
        textTheme: textTheme,
        colorScheme: ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          tertiary: AppColors.accent,
          surface: Colors.white,
          onSurface: Colors.black,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        textTheme: textTheme.apply(
            bodyColor: Colors.white, displayColor: Colors.white),
        colorScheme: ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          tertiary: AppColors.accent,
          surface: const Color(0xFF1E1E2F),
          onSurface: Colors.white,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
      ),
      home: const CalendarPage(),
    );
  }
}
