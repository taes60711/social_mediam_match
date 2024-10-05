// ip
import 'dart:io';

import 'package:flutter/material.dart';

String appVer = "1.0.0";
String ip = Platform.isIOS ? "127.0.0.1" : "10.0.2.2"; //release "192.168.1.160"
String port = '80';

String webSocketPort = "123";
String branch = "ws";
String channelListUrl = 'ws://$ip:$webSocketPort/$branch';
String channelRoomUrl = 'ws://$ip:$webSocketPort/$branch/chatroom';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
BuildContext globalContext = navigatorKey.currentState!.context;

///通知用
BuildContext? postContext;
BuildContext? courseContext;
