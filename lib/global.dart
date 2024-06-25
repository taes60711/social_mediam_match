// ip
import 'package:flutter/material.dart';

String ip = "36.226.156.94";
String port = '80';

String webSocketPort = "123";
String branch = "ws";
String channelListUrl = 'ws://$ip:$webSocketPort/$branch';
String channelRoomUrl = 'ws://$ip:$webSocketPort/$branch/chatroom';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

BuildContext globalContext = navigatorKey.currentState!.context;
