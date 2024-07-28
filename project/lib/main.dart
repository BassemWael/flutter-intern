import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'Classes/firebase-auth.dart';
import 'Classes/firestore.dart';
import 'Classes/theme.dart';
import 'Screens/homescreen.dart';
import 'Screens/login.dart';
import 'Screens/profile.dart';
import 'Screens/signup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (!kIsWeb) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  }
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack);
    return true;
  };

  await Hive.initFlutter();
  var box = await Hive.openBox('settings');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => FirestoreProvider()),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(box),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeProvider.themeData,
          initialRoute: HomePage.routename,
          routes: {
            HomePage.routename: (context) => const HomePage(),
            SignUpScreen.routename: (context) => const SignUpScreen(),
            LoginScreen.routename: (context) => const LoginScreen(),
            ProfilePage.routeName: (context) => ProfilePage(
              email: ModalRoute.of(context)!.settings.arguments as String,
            ),
          },
        );
      },
    );
  }
}
