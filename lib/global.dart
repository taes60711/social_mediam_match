// ip
import 'package:flutter/material.dart';

String appVer = "1.0.0";
String ip = "192.168.1.107"; //release mac: "192.168.1.161" Windows: "192.168.1.107"
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
BuildContext? globalHomeContext;
