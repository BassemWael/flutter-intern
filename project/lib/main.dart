import 'package:flutter/material.dart';
import 'package:project/Screens/login.dart';
import 'package:project/Screens/signup.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: LoginScreen.routename,
      routes: {
        SignUpScreen.routename: (context) => const SignUpScreen(),
        LoginScreen.routename: (context) => const LoginScreen(),
      },
    );
  }
}
