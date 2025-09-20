import 'package:flutter/material.dart';
import 'package:helloworld_2025/frontend/home_page/calendar_page.dart';
import 'package:helloworld_2025/global/main_initializations.dart';

Future<void> main() async {
  await initMain();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const CalendarPage(title: 'Flutter Demo Home Page'),
    );
  }
}
