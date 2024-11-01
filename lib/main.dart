// main.dart
import 'package:flutter/material.dart';
import 'package:ticker_project/views/home_screen.dart';

void main() {
  runApp(const EarningsTrackerApp());
}

class EarningsTrackerApp extends StatelessWidget {
  const EarningsTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Earnings Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}
