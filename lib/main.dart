import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/account/login_page.dart';
import 'package:social_mediam_match/components/account/signup_page.dart';
import 'package:social_mediam_match/components/Initial/Initial_page.dart';
import 'package:social_mediam_match/components/home/userPage/profile.dart';
import 'package:social_mediam_match/firebase_options.dart';
import 'package:social_mediam_match/states/initial_state.dart';
import 'package:social_mediam_match/states/user_setting_state.dart';
import 'package:social_mediam_match/states/user_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserState()),
    ],
    child: const MyApp(),
  ));
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
        '/': (BuildContext context) => ChangeNotifierProvider(
              create: (_) => InitialState(),
              child: const Initialpage(),
            ),
        '/login': (BuildContext context) => const LoginPage(),
        '/signUp': (BuildContext context) => const SignUpPage(),
        '/profile': (BuildContext context) => ChangeNotifierProvider(
              create: (_) => UserSettingState(),
              child: const Profile(),
            )
      },
    );
  }
}
