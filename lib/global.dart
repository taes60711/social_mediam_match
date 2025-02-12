// ip

import 'package:flutter/material.dart';

String appVer = "1.0.0";

String domain = "universal-link.directsense.tw";

String ip = "192.168.1.21"; //"10.6.9.129";

String port = '80';
String webSocketPort = "123";
String wsIp = "$ip:$webSocketPort";
String branch = "ws";
String channelListUrl = 'ws://$wsIp/$branch';
String channelRoomUrl = 'ws://$wsIp/$branch/chatroom';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
BuildContext globalContext = navigatorKey.currentState!.context;
bool apiFailDialogIsShow = false;

///"192.168.1.158";

//"119.77.173.122";
