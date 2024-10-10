//Route路徑
import 'package:flutter/material.dart';

import '../../components/Initial/Initial_page.dart';
import '../../components/account/login_page.dart';
import '../../components/account/signUpPage/signup_page.dart';
import '../../components/home/coursePage/course_edit_page/course_edit_page.dart';
import '../../components/home/postPage/editor_page.dart';
import '../../components/home/userPage/custom_service_page.dart';
import '../../components/home/userPage/myCourse/my_courses.dart';
import '../../components/home/userPage/my_friends.dart';
import '../../components/home/userPage/my_notification_page.dart';
import '../../components/home/userPage/my_posts.dart';
import '../../components/home/userPage/privacy_setting.dart';
import '../../components/home/userPage/user_setting.dart';

enum RoutePath {
  home("/", Initialpage()),
  loginPage("/login", LoginPage()),
  signUpPage("/signUp", SignUpPage()),

  profilePage("/profile", UserSetting()),
  postEditPage("/postEdit", EditorPage()),
  courseEditPage("/courseEdit", CourseEditPage()),
  myPosts("/myposts", MyPosts()),
  myCourses("/mycourses", MyCourses()),
  myFriends("/myFriends", MyFriends()),
  myNotifictaionPage("/myNotificationPage", MyNotificationPage()),
  customServicePage("/customServicePage", CustomServicePage()),
  privacySettingPage("/privacySetting", PrivacySetting());

  final String value;
  final Widget pageWidget;
  const RoutePath(this.value, this.pageWidget);
}
