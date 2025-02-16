// ip

import 'package:flutter/material.dart';
import 'package:social_mediam_match/enum/dev_type.dart';

String appVer = "1.0.0";
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
BuildContext globalContext = navigatorKey.currentState!.context;
bool apiFailDialogIsShow = false;

class APIHttpController {
  static APIHttpController? _instance;

  APIHttpController._();

  factory APIHttpController() {
    return _instance ??= APIHttpController._();
  }

  static String shareDomain = "universal-link.directsense.tw"; //暫時
  final String _domain = "skillstorm.directsense.tw";
  final String _ip = "10.6.9.129";

  ///"192.168.1.158";

  final String _port = '80';
  final String _webSocketDebugPort = "123";
  final String _webSocketReleasePort = "4433";
  final String _wsBranchUrl = "ws";

  static String databaseDomainStr = "";
  static String prefixUrl = "";
  static String domainUrl = "";
  static String wsPreFixUrl = "";

  Future<void> init({required DevType devType}) async {
    switch (devType) {
      case DevType.debug:
        prefixUrl = "http";
        domainUrl = "$_ip:$_port";
        wsPreFixUrl = "ws://$_ip:$_webSocketDebugPort/$_wsBranchUrl";
        databaseDomainStr = "\$ip:\$port";
        break;
      case DevType.release:
        prefixUrl = "https";
        domainUrl = _domain;
        wsPreFixUrl = "wss://$_domain:$_webSocketReleasePort/$_wsBranchUrl";
        databaseDomainStr = "\$domain";
        break;
    }
  }
}
