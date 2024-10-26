import 'package:flutter/material.dart';
import '../enum/route_path.dart';

Map<String, Widget Function(BuildContext)> routeManager = <String, WidgetBuilder>{
  RoutePath.home.value: (BuildContext context) => RoutePath.home.pageWidget,

  // /// "/"
  // RoutePath.home.value: (BuildContext context) => ChangeNotifierProvider(
  //       create: (_) => InitialProvider(),
  //       child: RoutePath.home.pageWidget,
  //     ),

  // /// "/signUp"
  // RoutePath.signUpPage.value: (BuildContext context) => MultiProvider(
  //       providers: [
  //         ChangeNotifierProvider(create: (_) => SignUpViewProvider()),
  //         ChangeNotifierProvider(create: (_) => UserSettingViewProvider()),
  //         ChangeNotifierProvider(create: (_) => SkillMapProvider()),
  //       ],
  //       child: RoutePath.signUpPage.pageWidget,
  //     ),

  // /// "/login"
  // RoutePath.loginPage.value: (BuildContext context) => ChangeNotifierProvider(
  //       create: (_) => LoginProvider(),
  //       child: RoutePath.loginPage.pageWidget,
  //     ),

  // /// "/postEdit"
  // RoutePath.postEditPage.value: (BuildContext context) => ChangeNotifierProvider(
  //       create: (_) => PostProvider(),
  //       child: RoutePath.postEditPage.pageWidget,
  //     ),

  // /// "/mycourses"
  // RoutePath.courseEditPage.value: (BuildContext context) => ChangeNotifierProvider(
  //       create: (_) => CourseProvider(),
  //       child: RoutePath.courseEditPage.pageWidget,
  //     ),

  // /// "/privacySetting"
  // RoutePath.privacySettingPage.value: (BuildContext context) => RoutePath.privacySettingPage.pageWidget,

  // /// "/profile"
  // RoutePath.profilePage.value: (BuildContext context) => MultiProvider(
  //       providers: [
  //         ChangeNotifierProvider(create: (_) => UserSettingViewProvider()),
  //         ChangeNotifierProvider(create: (_) => SkillMapProvider()),
  //       ],
  //       child: RoutePath.profilePage.pageWidget,
  //     ),

  // /// "/myposts"
  // RoutePath.myPosts.value: (BuildContext context) => MultiProvider(
  //       providers: [
  //         ChangeNotifierProvider(create: (_) => BaseAPIListProvider<PostModel>()),
  //         ChangeNotifierProvider(create: (_) => PostProvider()),
  //         ChangeNotifierProvider(create: (_) => PostCommentProvider()),
  //       ],
  //       child: RoutePath.myPosts.pageWidget,
  //     ),

  // /// "/mycourses"
  // RoutePath.myCourses.value: (BuildContext context) => ChangeNotifierProvider(
  //       create: (_) => CourseProvider(),
  //       child: RoutePath.myCourses.pageWidget,
  //     ),

  // /// "/myFriends"
  // RoutePath.myFriends.value: (BuildContext context) => RoutePath.myFriends.pageWidget,

  // /// "/MyNotificationPage"
  // RoutePath.myNotifictaionPage.value: (BuildContext context) => MultiProvider(
  //       providers: [
  //         ChangeNotifierProvider(create: (_) => BaseAPIListProvider<NotificationModel>()),
  //         ChangeNotifierProvider(create: (_) => CourseProvider()),
  //         ChangeNotifierProvider(create: (_) => PostProvider()),
  //         ChangeNotifierProvider(create: (_) => PostCommentProvider()),
  //       ],
  //       child: RoutePath.myNotifictaionPage.pageWidget,
  //     ),

  // /// "/customServicePage"
  // RoutePath.customServicePage.value: (BuildContext context) => RoutePath.customServicePage.pageWidget,
};
