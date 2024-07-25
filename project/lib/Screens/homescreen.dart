import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:project/Screens/login.dart';
import 'package:project/Screens/signup.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static const String routename = "Home page";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Please choose an option below:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, SignUpScreen.routename);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, LoginScreen.routename);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  try {
                    throw const FormatException("got an exception");
                  } catch (e, stack) {
                    FirebaseCrashlytics.instance.recordError(e, stack);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text(
                  'Exception',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
