import 'package:flutter/material.dart';
import 'package:project/Classes/firebase-auth.dart';
import 'package:project/Classes/firestore.dart';
import 'package:project/Screens/login.dart';
import 'package:project/Screens/profile.dart';
import 'package:project/Screens/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => FirestoreProvider()),
      ],
      child: MyApp(),
    ),
  );
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
        ProfilePage.routeName: (context) => ProfilePage(
          email: ModalRoute.of(context)!.settings.arguments as String,
        ),
      },
    );
  }
}
