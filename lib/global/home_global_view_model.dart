// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/global/user_login_status_controller.dart';
import 'package:social_mediam_match/provider/account/user_provider.dart';

import '../components/utilities/style/screen_size.dart';
import '../global.dart';
import '../pageManager/enum/bottom_bar_path.dart';
import '../provider/friend/chat_ws_model.dart';
import '../services/app_links_service.dart';
import '../services/firebase_notification_service.dart';
import '../services/user_service.dart';

final bottomNavigationBarProvider = StateProvider<int>((ref) {
  return 0;
});

final bottomNavationBarPosProvider = StateProvider<double>((ref) {
  return Platform.isIOS ? 25 : 9;
});

class HomeGlobalViewModel {
  static HomeGlobalViewModel? _instance;

  HomeGlobalViewModel._();

  factory HomeGlobalViewModel() {
    return _instance ??= HomeGlobalViewModel._();
  }
  late BuildContext context;
  late WidgetRef ref;
  late Function render;
  late Function initalPageRender;

  Future<void> init({
    required BuildContext context,
    required WidgetRef ref,
    required Function render,
  }) async {
    this.context = context;
    this.ref = ref;
    this.render = render;

    await Future.delayed(Duration.zero);

    /// ゲスト場合　chatRoom 繋いでない　＆　Token上がってない
    if (!UserLoginStatusController().isGuest()) {
      /// チャットルームリストWS初始化
      ChatWSModel().init(ref, () => render(), userId: ref.watch(loginUserData).uid);

      /// 通知システム起動
      /// 通知用のtoken取得
      final fcmToken = await FirebaseMessaging.instance.getToken();
      print("通知用 fcmToken $fcmToken");
      await UserService().updateUserToken(ref.read(loginUserData).uid, fcmToken ?? "");
    }

    /// シャアシステム起動
    /// appLink Init
    AppLinkService().init(context: context, ref: ref);
    FirebaseNotificationService().initNotification(context: context, ref: ref);
    FirebaseNotificationService().notificationListen(context: context, ref: ref);
  }

  ///BottomNavigiatonbar隠れ/表示する
  void bottomBarHideStateChage(bool hide) {
    if (hide) {
      ref.read(bottomNavationBarPosProvider.notifier).update((state) => ScreenSize.fitPxHeight(-60));
    } else {
      ref.read(bottomNavationBarPosProvider.notifier).update((state) => Platform.isIOS ? 25 : 9);
    }
    render();
  }

  ///BottomNavigiatonbarのページコントローラー
  void changeMainPage(BottomBarPath page) {
    ref.read(bottomNavigationBarProvider.notifier).update((state) => page.path);
    render();
  }

  void popUntiltFirst() {
    Navigator.of(globalContext).popUntil((route) => route.isFirst);
  }

  void popUntiltFirstThentoPage(BottomBarPath page) {
    Navigator.of(globalContext).popUntil((route) => route.isFirst);
    ref.read(bottomNavigationBarProvider.notifier).update((state) => page.path);
    render();
  }

  static void pop() {
    Navigator.of(globalContext).pop();
  }
}
