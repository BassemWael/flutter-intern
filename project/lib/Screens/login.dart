import 'package:flutter/material.dart';
import 'package:project/Classes/firebase-auth.dart';
import 'package:project/Screens/profile.dart';
import 'package:project/Screens/signup.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String routename = "Login";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _accountController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = await authProvider.signIn(
      _accountController.text,
      _passwordController.text,
    );

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(email: _accountController.text),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Login failed. Please check your credentials.')),
      );
    }
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
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.email),
                ),
              ),
              SizedBox(
                width: inputWidth,
                child: TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.password),
                  obscureText: true,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child:  Text(AppLocalizations.of(context)!.login),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, SignUpScreen.routename);
                },
                child: Text(AppLocalizations.of(context)!.dont),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
