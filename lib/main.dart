import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:social_mediam_match/components/loginpage.dart';
import 'package:social_mediam_match/components/signuppage.dart';
import 'package:social_mediam_match/firebase_options.dart';
import 'package:social_mediam_match/components/home/home.dart';
import 'package:social_mediam_match/service/fb_service.dart';

Future<void> main() async {
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        pageTransitionsTheme: const PageTransitionsTheme(builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
        }),
      ),
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => const Initialpage(),
        '/home': (BuildContext context) => Home(),
        '/signUp': (BuildContext context) => const SignUpPage(),
      },
    );
  }
}

class Initialpage extends StatefulWidget {
  const Initialpage({super.key});

  @override
  State<Initialpage> createState() => _InitialpageState();
}

class _InitialpageState extends State<Initialpage> {
  bool isInitial = true;
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () {
      setState(() {
        isInitial = false;
      });
    });
  }

  Widget preLoginPage() {
    return StreamBuilder(
        stream: FbService().auth.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          User? userData = snapshot.data;

          if (userData != null) {
            return Home();
          } else {
            return LoginPage();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return isInitial
        ? Scaffold(
            body: Center(
              child: Container(
                width: 200,
                height: 200,
                color: Colors.blue,
              ),
            ),
          )
        : preLoginPage();
  }
}
