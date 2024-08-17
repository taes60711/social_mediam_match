import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/provider/account/LoginPage/login_provider.dart';
import 'package:social_mediam_match/provider/post/post_comment_provider.dart';
import 'package:social_mediam_match/components/utilities/apiListView/base_api_list_provider.dart';
import '../../components/home/postPage/editor_page.dart';
import '../../main.dart';
import '../../models/post_model.dart';
import '../../provider/Initial/initial_provider.dart';
import '../../provider/account/signUpPage/sign_up_view_provider.dart';
import '../../provider/account/user_provider.dart';
import '../../provider/course_provider.dart';
import '../../provider/friend_provider.dart';
import '../../provider/home/skill_map_provider.dart';
import '../../provider/home/user_setting_view_provider.dart';
import '../../provider/post/post_provider.dart';
import '../enum/route_path.dart';
import 'bottom_bar_controller_provider.dart';

/// main
Widget mainWidget = MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => UserProvider()),
    ChangeNotifierProvider(create: (_) => FriendProvider()),
    ChangeNotifierProvider(create: (_) => BottomBarControllerProvider()),
  ],
  child: EasyLocalization(
    supportedLocales: const [Locale('zh', 'TW'), Locale('en', 'US'), Locale('ja', 'JP')],
    fallbackLocale: const Locale('en', 'US'),
    path: 'assets/langs',
    child: const MyApp(),
  ),
);

Map<String, Widget Function(BuildContext)> routeManager = <String, WidgetBuilder>{
  /// "/"
  RoutePath.home.value: (BuildContext context) => ChangeNotifierProvider(
        create: (_) => InitialProvider(),
        child: RoutePath.home.pageWidget,
      ),

  /// "/signUp"
  RoutePath.signUpPage.value: (BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SignUpViewProvider()),
          ChangeNotifierProvider(create: (_) => UserSettingViewProvider()),
          ChangeNotifierProvider(create: (_) => SkillMapProvider()),
        ],
        child: RoutePath.signUpPage.pageWidget,
      ),

  /// "/login"
  RoutePath.loginPage.value: (BuildContext context) => ChangeNotifierProvider(
        create: (_) => LoginProvider(),
        child: RoutePath.loginPage.pageWidget,
      ),

  /// "/postEdit"
  RoutePath.postEditPage.value: (BuildContext context) => const EditorPage(),

  /// "/mycourses"
  RoutePath.courseEditPage.value: (BuildContext context) => ChangeNotifierProvider(
        create: (_) => CourseProvider(),
        child: RoutePath.courseEditPage.pageWidget,
      ),

  /// "/privacySetting"
  RoutePath.privacySettingPage.value: (BuildContext context) => RoutePath.privacySettingPage.pageWidget,

  /// "/profile"
  RoutePath.profilePage.value: (BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserSettingViewProvider()),
          ChangeNotifierProvider(create: (_) => SkillMapProvider()),
        ],
        child: RoutePath.profilePage.pageWidget,
      ),

  /// "/myposts"
  RoutePath.myPosts.value: (BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => BaseAPIListProvider<PostModel>()),
          ChangeNotifierProvider(create: (_) => PostProvider()),
          ChangeNotifierProvider(create: (_) => PostCommentProvider()),
        ],
        child: RoutePath.myPosts.pageWidget,
      ),

  /// "/mycourses"
  RoutePath.myCourses.value: (BuildContext context) => ChangeNotifierProvider(
        create: (_) => CourseProvider(),
        child: RoutePath.myCourses.pageWidget,
      ),

  /// "/myFriends"
  RoutePath.myFriends.value: (BuildContext context) => RoutePath.myFriends.pageWidget,

  /// "/MyNotificationPage"
  RoutePath.myNotifictaionPage.value: (BuildContext context) => RoutePath.myNotifictaionPage.pageWidget,

  /// "/guide"
  RoutePath.guide.value: (BuildContext context) => RoutePath.guide.pageWidget,
};
