import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:project/Classes/users.dart';
import 'package:project/Screens/login.dart';
import 'package:project/Screens/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project/utils/boxes.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  Hive.registerAdapter(UsersAdapter());
  boxUsers = await Hive.openBox<Users>('usersBox');
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
