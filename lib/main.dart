import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gym/Components/Colors.dart';
import 'package:gym/Ui/Authentication.dart';
import 'package:gym/Ui/Main_Screen.dart';
import 'package:gym/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GYM',
      theme: ThemeData(
        primaryColor: AppColors().primaryColor,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors().primaryColor),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, userSnp) {
          if (userSnp.hasData) {
            return const MainScreen();
          }
          // return const BottomNavigationBarScreen();
          return const AuthenticationScreen();
          // return const WelcomePage();
        },
      ),
    );
  }
}
