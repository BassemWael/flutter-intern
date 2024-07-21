import 'package:flutter/material.dart';
import 'package:project/Classes/firebase-auth.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  static const String routename = "Sign-up";

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthClass _authClass = AuthClass();

  @override
  void dispose() {
    _nameController.dispose();
    _accountController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

void _signup() async {
  final user = await _authClass.register(
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
        title: const Text('Sign-Up'),
        automaticallyImplyLeading: false,
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
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
              ),
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
                onPressed: _signup,
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
