import 'package:flutter/material.dart';
import 'package:project/Classes/firebase-auth.dart';
import 'package:project/Classes/firestore.dart';
import 'package:provider/provider.dart';

import 'package:project/Screens/profile.dart';
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
  final TextEditingController _ageController = TextEditingController();

  Future<void> _signup() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final firestoreProvider =
          Provider.of<FirestoreProvider>(context, listen: false);

      try {
        final user = await authProvider.register(
          _nameController.text,
          _accountController.text,
          _passwordController.text,
        );

        if (user != null) {
          // Removed email verification step

          try {
            int age = int.parse(_ageController.text);
            await firestoreProvider.addUser(
                _nameController.text, age, _accountController.text);

            // Navigate to the profile page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ProfilePage(email: _accountController.text),
              ),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Invalid age. Please enter a valid number.')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Registration failed. Please try again.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _accountController.dispose();
    _passwordController.dispose();
    _ageController.dispose();
    super.dispose();
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
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Age'),
                    validator: ageSignupValidator,
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
