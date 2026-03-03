import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const RashifyApp());
}

class RashifyApp extends StatelessWidget {
  const RashifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.orange, useMaterial3: true),
      home: HomeScreen(),
    );
  }
}