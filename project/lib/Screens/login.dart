import 'package:flutter/material.dart';
import 'package:project/Classes/firebase-auth.dart';
import 'package:project/Screens/signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String routename = "Login";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthClass _authClass = AuthClass(); // Create an instance of AuthClass

  @override
  void dispose() {
    _accountController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    final user = await _authClass.signIn(
      _accountController.text,
      _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final inputWidth = screenWidth * 0.8;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: inputWidth,
                child: TextField(
                  controller: _accountController,
                  decoration: const InputDecoration(labelText: 'Account'),
                ),
              ),
              SizedBox(
                width: inputWidth,
                child: TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: const Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, SignUpScreen.routename);
                },
                child: const Text('Don\'t have an account? Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
