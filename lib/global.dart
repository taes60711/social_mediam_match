// ip
import 'dart:io';

import 'package:flutter/material.dart';

String appVer = "1.0.0";
String ip = Platform.isIOS ? "127.0.0.1" : "10.0.2.2"; //release "192.168.1.107" 13.239.75.115
String port = '80'; //release '9000'

String webSocketPort = "123"; //release '9001'
String wsIp = "$ip:$webSocketPort";
String branch = "ws";
String channelListUrl = 'ws://$wsIp/$branch';
String channelRoomUrl = 'ws://$wsIp/$branch/chatroom';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
BuildContext globalContext = navigatorKey.currentState!.context;

///通知用
BuildContext? globalPostContext;
BuildContext? courseContext;
