// ignore_for_file: use_build_context_synchronously
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/global/user_login_status_controller.dart';
import 'package:social_mediam_match/models/user_model.dart';
import 'package:social_mediam_match/provider/account/user_provider.dart';

import '../components/home/firendsPage/firends_page.dart';
import '../components/utilities/dialog/confirm_dialog.dart';
import '../components/utilities/style/screen_size.dart';
import '../components/utilities/toast.dart';
import '../enum/user_block_status_type.dart';
import '../global.dart';
import '../models/friend_model.dart';
import '../pageManager/enum/bottom_bar_path.dart';
import '../provider/friend/chat_ws_model.dart';
import '../services/app_links_service.dart';
import '../services/black_list_service.dart';
import '../services/firebase_notification_service.dart';
import '../services/friend_service.dart';
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

  /// ブロックユーザ
  void blockUser({required ProfileData userData, bool isInChatRoom = false}) {
    if (userData.uid == "-1") {
      Toast().showCenter(msg: "該用戶已經不存在");
      return;
    }

    if (UserLoginStatusController().isGuest()) {
      ConfirmDilaog(
          title: "提示",
          content: "請先登入",
          conirmFunc: () {
            UserLoginStatusController().guestLogOut(
              attachFunc: () {
                changeMainPage(BottomBarPath.home);
              },
            );
          }).show(context);
      return;
    }

    ConfirmDilaog(
      title: "提示",
      content: "封鎖該用戶後, 未來將不會看到該用戶的任何訊息\n\n確定要封鎖用戶嗎？",
      conirmFunc: () async {
        UserBlockStatusType blockStatus = await getUserBlockStatus(userData: userData);

        switch (blockStatus) {
          case UserBlockStatusType.block:
            Toast().showCenter(msg: "該用戶已經被封鎖");
          case UserBlockStatusType.blocked:
            Toast().showCenter(msg: "你已經被該用戶封鎖");
          case UserBlockStatusType.none:
            bool isSuccess = await BlackListService().addBlackUserToList(
              uid: ref.read(loginedUserUID.notifier).state,
              blockUID: userData.uid,
            );
            if (isSuccess) {
              /// 如果為好友的話 移除好友列表
              List<FriendListModel> friendList = ref.read(frinedListProvider.notifier).state;

              int index = friendList.indexWhere((e) {
                String memberId = e.createdBy;
                if (ref.read(loginUserData.notifier).state.uid == e.createdBy) {
                  memberId = e.memberId;
                }

                return memberId == userData.uid;
              });

              if (index != -1) {
                /// 如果為好友的話 移除好友
                await FriendService().deleteFriend(friendList[index].roomId, friendList[index].userData.uid);
                friendList.removeAt(index);
                ref.read(frinedListProvider.notifier).update((state) => friendList);

                ref.read(frinedListProvider.notifier).update((state) => friendList);

                ref.read(friendPageRender.notifier).state();
                if (isInChatRoom) {
                  popUntiltFirst();
                }
              }

              Toast().showCenter(msg: "已封鎖該用戶");
            }
          case UserBlockStatusType.failed:
            print("server Failed");
        }
      },
    ).show(context);
  }

  /// ユーザのブロック状態取得する
  Future<UserBlockStatusType> getUserBlockStatus({required ProfileData userData}) async {
    String blockStatus = await BlackListService().isUserBlocked(
      uid: ref.read(loginedUserUID.notifier).state,
      blockUID: userData.uid,
    );

    switch (blockStatus) {
      case "block":
        return UserBlockStatusType.block;
      case "blocked":
        return UserBlockStatusType.blocked;
      case "none":
        return UserBlockStatusType.none;
      default:
        return UserBlockStatusType.failed;
    }
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
