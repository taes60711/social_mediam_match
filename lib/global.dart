// ip

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/enum/dev_type.dart';

String appVer = "1.0.0";
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
BuildContext globalContext = navigatorKey.currentState!.context;

/// API錯誤訊息已經跳出
bool apiFailDialogIsShow = false;

/// 分享頁面是否已經跳出
final notifiProfilePageIsOpen = StateProvider<bool>((ref) {
  return false;
});

class APIHttpController {
  static APIHttpController? _instance;

  APIHttpController._();

  factory APIHttpController() {
    return _instance ??= APIHttpController._();
  }

  final String _domain = "skillstorm.directsense.tw"; //"skillstorm.directsense.tw";
  final String _ip = "10.6.9.129";

  ///"192.168.1.158"; //119.77.173.122

  final String _port = '80';
  final String _webSocketDebugPort = "123";
  final String _webSocketReleasePort = "4433";
  final String _wsBranchUrl = "ws";

  static String shareDomain = "";
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
        shareDomain = "cant_use";
        break;
      case DevType.release:
        prefixUrl = "https";
        domainUrl = _domain;
        wsPreFixUrl = "wss://$_domain:$_webSocketReleasePort/$_wsBranchUrl";
        databaseDomainStr = "\$domain";
        shareDomain = _domain;
        break;
    }
  }
}
