import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/CustomBouncingScrollPhysics.dart';
import 'package:social_mediam_match/components/account/login_page.dart';
import 'package:social_mediam_match/components/account/signUpPage/signup_page.dart';
import 'package:social_mediam_match/components/Initial/initial_page.dart';
import 'package:social_mediam_match/components/home/coursePage/course_edit_page.dart';
import 'package:social_mediam_match/components/home/postPage/editor_page.dart';
import 'package:social_mediam_match/components/home/userPage/myCourse/my_courses.dart';
import 'package:social_mediam_match/components/home/userPage/my_posts.dart';
import 'package:social_mediam_match/components/home/userPage/profile.dart';
import 'package:social_mediam_match/components/home/userPage/privacy_setting.dart';
import 'package:social_mediam_match/firebase_options.dart';
import 'package:social_mediam_match/global.dart';
import 'package:social_mediam_match/provider/account/signUpPage/sign_up_view_provider.dart';
import 'package:social_mediam_match/provider/skill_provider.dart';
import 'package:social_mediam_match/states/course_state.dart';
import 'package:social_mediam_match/states/friend_state.dart';
import 'package:social_mediam_match/states/initial_state.dart';
import 'package:social_mediam_match/states/post_state.dart';
import 'package:social_mediam_match/states/skill_exchange_state.dart';
import 'package:social_mediam_match/states/user_setting_provider.dart';
import 'package:social_mediam_match/states/user_state.dart';

import 'components/home/userPage/my_friends.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => FriendState(channelListUrl: channelListUrl)),
        ChangeNotifierProvider(create: (_) => SkillExChangeState()),
      ],
      child: EasyLocalization(
        supportedLocales: const [Locale('zh', 'TW'), Locale('en', 'US'), Locale('ja', 'JP')],
        fallbackLocale: const Locale('en', 'US'),
        path: 'assets/langs',
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      scrollBehavior: ScrollConfiguration.of(context).copyWith(
        physics: const CustomBouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      ),
      theme: ThemeData(
        fontFamily: 'GenJyu',
        useMaterial3: false,
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
        '/signUp': (BuildContext context) => MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => SkillProvider()),
                ChangeNotifierProvider(create: (_) => SignUpViewProvider()),
                ChangeNotifierProvider(create: (_) => UserSettingProvider()),
              ],
              child: const SignUpPage(),
            ),
        '/login': (BuildContext context) => const LoginPage(),
        '/postEdit': (BuildContext context) => ChangeNotifierProvider(
              create: (_) => PostState(),
              child: const EditorPage(),
            ),
        '/courseEdit': (BuildContext context) => ChangeNotifierProvider(
              create: (_) => CourseState(),
              child: const CourseEditPage(),
            ),
        '/privacySetting': (BuildContext context) => const PrivacySetting(),
        '/profile': (BuildContext context) => ChangeNotifierProvider(
              create: (_) => UserSettingProvider(),
              child: const Profile(),
            ),
        '/myposts': (BuildContext context) => ChangeNotifierProvider(
              create: (_) => PostState(),
              child: const MyPosts(),
            ),
        '/mycourses': (BuildContext context) => ChangeNotifierProvider(
              create: (_) => CourseState(),
              child: const MyCourses(),
            ),
        '/myFriends': (BuildContext context) => const MyFriends(),
      },
    );
  }
}
