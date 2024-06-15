import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/Initial/Initial_page.dart';
import 'package:social_mediam_match/provider/account/LoginPage/login_provider.dart';
import '../../components/account/login_page.dart';
import '../../components/account/signUpPage/signup_page.dart';
import '../../components/home/coursePage/course_edit_page.dart';
import '../../components/home/postPage/editor_page.dart';
import '../../components/home/userPage/myCourse/my_courses.dart';
import '../../components/home/userPage/my_friends.dart';
import '../../components/home/userPage/my_posts.dart';
import '../../components/home/userPage/privacy_setting.dart';
import '../../components/home/userPage/profile.dart';
import '../../provider/Initial/initial_provider.dart';
import '../../provider/account/signUpPage/sign_up_view_provider.dart';
import '../../provider/home/skill_map_provider.dart';
import '../../provider/home/user_setting_view_provider.dart';
import '../../states/course_state.dart';
import '../../states/post_state.dart';
import '../../states/user_setting_provider.dart';
import '../enum/route_path.dart';

Map<String, Widget Function(BuildContext)> routeManager = <String, WidgetBuilder>{
  /// "/"
  RoutePath.home.value: (BuildContext context) => ChangeNotifierProvider(
        create: (_) => InitialProvider(),
        child: const Initialpage(),
      ),

  /// "/signUp"
  RoutePath.signUpPage.value: (BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserSettingViewProvider()),
          ChangeNotifierProvider(create: (_) => SignUpViewProvider()),
          ChangeNotifierProvider(create: (_) => SkillMapProvider()),
        ],
        child: const SignUpPage(),
      ),

  /// "/login"
  RoutePath.loginPage.value: (BuildContext context) => ChangeNotifierProvider(
        create: (_) => LoginProvider(),
        child: const LoginPage(),
      ),

  /// "/postEdit"
  RoutePath.postEditPage.value: (BuildContext context) => ChangeNotifierProvider(
        create: (_) => PostState(),
        child: const EditorPage(),
      ),

  /// "/mycourses"
  RoutePath.courseEditPage.value: (BuildContext context) => ChangeNotifierProvider(
        create: (_) => CourseState(),
        child: const CourseEditPage(),
      ),

  /// "/privacySetting"
  RoutePath.privacySettingPage.value: (BuildContext context) => const PrivacySetting(),

  /// "/profile"
  RoutePath.profilePage.value: (BuildContext context) => ChangeNotifierProvider(
        create: (_) => UserSettingProvider(),
        child: const Profile(),
      ),

  /// "/myposts"
  RoutePath.myPosts.value: (BuildContext context) => ChangeNotifierProvider(
        create: (_) => PostState(),
        child: const MyPosts(),
      ),

  /// "/mycourses"
  RoutePath.myCourses.value: (BuildContext context) => ChangeNotifierProvider(
        create: (_) => CourseState(),
        child: const MyCourses(),
      ),

  /// "/myFriends"
  RoutePath.myFriends.value: (BuildContext context) => const MyFriends(),
};
