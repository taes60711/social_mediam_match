import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/account/welcome_page.dart';
import 'package:social_mediam_match/components/home/home.dart';
import 'package:social_mediam_match/components/utilities/background_widget.dart';
import 'package:social_mediam_match/components/utilities/loading.dart';
import 'package:social_mediam_match/components/utilities/stateful_wrapper.dart';
import 'package:social_mediam_match/states/friend_state.dart';
import 'package:social_mediam_match/states/initial_state.dart';
import '../../models/user_model.dart';

import '../../provider/account/user_provider.dart';
import '../../services/dynamic_links.dart';
import '../../services/notification_service.dart';
import '../utilities/style/screen_size.dart';
import '../utilities/style/style_config.dart';

class Initialpage extends StatelessWidget {
  const Initialpage({super.key});

  @override
  Widget build(BuildContext context) {
    int delayTime = 3;

    bool isfirstEnterApp = context.select((InitialState value) => value.isfirstEnterApp);
    LoginUser userData = context.watch<UserProvider>().userData;
    bool isLoading = context.select((UserProvider value) => value.isLoading);

    void enterApp() {
      print("firstEnterApp");
      FriendState friendState = context.read<FriendState>();
      context.read<UserProvider>().isLoginCheck(friendState);
      Timer(Duration(seconds: delayTime), () {
        context.read<InitialState>().onChange();

        if (Platform.isAndroid) {
          //初始化 > dynamicLink 在上架前,先暫時只有安卓使用
          DynamicLinks().initDynamicLink(context);
          //初始化 > 通知系統 在上架前,先暫時只有安卓使用
          NotificationService notificationService = NotificationService()..initNotification();
          notificationService.notificationListen();
        }
      });
    }

    Widget component;
    if (isfirstEnterApp) {
      component = StatefulWrapper(
        onInit: () => enterApp(),
        child: BackgroundWidget(
          isSafeArea: false,
          child: Center(
            child: SizedBox(
              width: ScreenSize.width,
              child: AspectRatio(
                aspectRatio: 16.0 / 9.0,
                child: Image.asset(logoImg),
              ),
            ),
          ),
        ),
      );
    } else {
      if (isLoading) {
        component = const Scaffold(
          backgroundColor: Colors.white,
          body: Loading(),
        );
      } else {
        if (userData.uid != "-1") {
          component = const Home();
        } else {
          component = const WelcomePage();
        }
      }
    }

    return component;
  }
}
