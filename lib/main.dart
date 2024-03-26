import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/account/signup_page.dart';
import 'package:social_mediam_match/components/Initial/initial_page.dart';
import 'package:social_mediam_match/components/home/postPage/editor_page.dart';
import 'package:social_mediam_match/components/home/userPage/my_posts.dart';
import 'package:social_mediam_match/components/home/userPage/profile.dart';
import 'package:social_mediam_match/components/home/userPage/privacy_setting.dart';
import 'package:social_mediam_match/firebase_options.dart';
import 'package:social_mediam_match/global.dart';
import 'package:social_mediam_match/states/friend_state.dart';
import 'package:social_mediam_match/states/initial_state.dart';
import 'package:social_mediam_match/states/post_state.dart';
import 'package:social_mediam_match/states/services/notification_service.dart';
import 'package:social_mediam_match/states/skill_exchange_state.dart';
import 'package:social_mediam_match/states/user_setting_state.dart';
import 'package:social_mediam_match/states/user_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  NotificationService notificationService = NotificationService()..initNotification();
  notificationService.notificationListen();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserState()),
      ChangeNotifierProvider(create: (_) => FriendState(channelListUrl: channelListUrl)),
      ChangeNotifierProvider(create: (_) => SkillExChangeState()),
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
        '/signUp': (BuildContext context) => const SignUpPage(),
        '/postEdit': (BuildContext context) => ChangeNotifierProvider(
              create: (_) => PostState(),
              child: const EditorPage(),
            ),
        '/privacySetting': (BuildContext context) => const PrivacySetting(),
        '/profile': (BuildContext context) => ChangeNotifierProvider(
              create: (_) => UserSettingState(),
              child: const Profile(),
            ),
        '/myposts': (BuildContext context) => ChangeNotifierProvider(
              create: (_) => PostState(),
              child: const MyPosts(),
            ),
      },
    );
  }
}
