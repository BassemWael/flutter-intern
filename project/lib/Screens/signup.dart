import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/Classes/firebase-auth.dart';
import 'package:project/Classes/users.dart';
import 'package:project/Screens/profile.dart';
import 'package:project/utils/boxes.dart';
import 'package:project/utils/validators.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  static const String routename = "Sign-up";

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
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
    if (_formKey.currentState!.validate()) {
      User? user = await _authClass.register(
        _nameController.text,
        _accountController.text,
        _passwordController.text,
      );

      if (user != null) {
        boxUsers.put('key_${_accountController.text}',
            Users(name: _nameController.text, email: _accountController.text));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(email: _accountController.text),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration failed. Please try again.')),
        );
      }
    }
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
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: inputWidth,
                  child: TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                ),
                SizedBox(
                  width: inputWidth,
                  child: TextFormField(
                    controller: _accountController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: emailSignupValidator,
                  ),
                ),
                SizedBox(
                  width: inputWidth,
                  child: TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: passwordSignupValidator,
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
      ),
    );
  }
}
