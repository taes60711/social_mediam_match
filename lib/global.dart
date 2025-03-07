// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/utilities/dialog/confirm_dialog.dart';
import 'package:social_mediam_match/enum/dev_type.dart';
import 'package:social_mediam_match/models/app_info_model.dart';
import 'package:social_mediam_match/services/app_info_service.dart';
import 'package:url_launcher/url_launcher.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
BuildContext globalContext = navigatorKey.currentState!.context;

/// API錯誤訊息已經跳出
bool apiFailDialogIsShow = false;

/// 分享頁面是否已經跳出
final notifiProfilePageIsOpen = StateProvider<bool>((ref) {
  return false;
});

/// App Version
class APPInfoController {
  AppInfoModel phoneVer = AppInfoModel(
    iosVersion: "1.1",
    androidVersion: "1.0",
  );

  Future<bool> checkAppVersion(BuildContext context) async {
    bool isOk = true;
    AppInfoModel serviceVer = await AppInfoService().getAppInfo();
    print("Phone Version IOS : ${phoneVer.iosVersion} Android : ${phoneVer.androidVersion}");
    print("Service Version IOS : ${serviceVer.iosVersion} Android : ${serviceVer.androidVersion}");

    if (Platform.isIOS) {
      if (phoneVer.iosVersion != serviceVer.iosVersion) {
        String iosStoreUrl = "https://apps.apple.com/tw/app/skillstorm/id6739574450";
        toUpdatePage(context, storeUrl: iosStoreUrl);
        print("need Update");
        isOk = false;
      }
    } else if (Platform.isAndroid) {
      if (phoneVer.androidVersion != serviceVer.androidVersion) {
        String androidStroeUrl = "https://apps.apple.com/tw/app/skillstorm/id6739574450";
        toUpdatePage(context, storeUrl: androidStroeUrl);
        print("need Update");
        isOk = false;
      }
    }

    return isOk;
  }

  void toUpdatePage(BuildContext context, {required String storeUrl}) {
    ConfirmDilaog(
      title: "版本錯誤",
      content: "App已經更新了哦\n請至商店更新",
      btnAmount: 1,
      conirmFunc: () {
        Uri url = Uri.parse(storeUrl);
        launchUrl(url);
      },
    ).show(context);
  }
}

/// API Domain
class APIHttpController {
  static APIHttpController? _instance;

  APIHttpController._();

  factory APIHttpController() {
    return _instance ??= APIHttpController._();
  }

  final String _domain = "skillstorm.directsense.tw";
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
