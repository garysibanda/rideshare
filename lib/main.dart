import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart';

void main() {
  runApp(const BYURideApp());
}

class BYURideApp extends StatelessWidget {
  const BYURideApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BYURide',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Inter',
      ),
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}