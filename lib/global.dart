// ip
import 'package:flutter/material.dart';

String ip = "114.37.133.103";
String port = '80';

String webSocketPort = "123";
String branch = "ws";
String channelListUrl = 'ws://$ip:$webSocketPort/$branch';
String channelRoomUrl = 'ws://$ip:$webSocketPort/$branch/chatroom';

//Route路徑
enum RoutePath {
  home("/"),
  loginPage("/login"),
  signUpPage("/signUp"),
  profilePage("/profile"),
  postEditPage("/postEdit"),
  courseEditPage("/courseEdit"),
  skillChoicePage("/skillChoice"),
  myPosts("/myposts"),
  myCourses("/mycourses"),
  myFriends("/myFriends"),
  privacySettingPage("/privacySetting");

  final String value;
  const RoutePath(this.value);
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

BuildContext globalContext = navigatorKey.currentState!.context;
