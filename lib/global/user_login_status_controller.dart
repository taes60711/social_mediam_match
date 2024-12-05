import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/global/shared_preference.dart';

import '../models/user_model.dart';
import '../provider/account/LoginPage/login_view_model.dart';
import '../provider/account/user_provider.dart';
import '../provider/friend/chat_ws_model.dart';
import '../services/google_sign_in_service.dart';
import '../services/notification_service.dart';
import '../services/user_service.dart';

final loginedUserUID = StateProvider<String>((ref) => "");

class UserLoginStatusController {
  static UserLoginStatusController? _instance;

  UserLoginStatusController._();

  factory UserLoginStatusController() {
    return _instance ??= UserLoginStatusController._();
  }
  late WidgetRef ref;
  late SharedPreference sharedPreference;
  late Function render;
  late BuildContext context;
  Future<void> init({
    required BuildContext initContext,
    required WidgetRef initRef,
    required Function initRender,
    required SharedPreference initSharedPreference,
  }) async {
    context = initContext;
    ref = initRef;
    render = initRender;

    sharedPreference = initSharedPreference;
    await loginedCheck();
  }

  bool isLogin() {
    return ref.watch(loginedUserUID) != "";
  }

  Future<void> loginedCheck() async {
    /// ＳＤからユーザUID取得
    String userUID = SharedPreference().loginCheckGetuserUID();
    print("loginCheck LoginUserUID : $userUID");
    ref.read(loginedUserUID.notifier).update((state) => userUID);

    if (ref.watch(loginedUserUID) != "") {
      /// ユーザデータ取得
      ProfileData requestUserData = await UserService().requestUserDataByUID(userUID);

      /// ログイン処理
      await commonLoginFunc(requestUserData: requestUserData);
    }
  }

  ///loginType = normalSign , googleSign
  Future<bool> login({required LoginDataModel loginInputData, String loginType = "normalSign"}) async {
    bool loginSuccess = false;

    /// ユーザデータ取得
    ///loginType = normalSign , googleSign
    ProfileData requestUserData = await UserService().requestUserDataByEmail(
      loginInputData.account,
      loginInputData.pwd,
      loginType: loginType,
    );

    print("LoginUserUID: ${requestUserData.uid}");
    if (requestUserData.uid != "-1") {
      /// ＳＤにユーザUID保存
      await sharedPreference.loginSetUserUID(requestUserData.uid);
      ref.read(loginedUserUID.notifier).update((state) => requestUserData.uid);

      /// ログイン処理
      await commonLoginFunc(requestUserData: requestUserData);

      loginSuccess = true;
    }

    render();
    return loginSuccess;
  }

  Future<void> logOut() async {
    /// 通知用のtoken削除
    await UserService().updateUserToken(ref.read(loginUserData).uid, '');

    /// SDのユーザUID削除
    await sharedPreference.loginOutRemoveUserUID();

    ///　グーグルログインしたユーザログアウト
    await GoogleSinginService().signOutFromGoogle();

    /// チャットルームリストWS クローズ
    ChatWSModel().closeStream();
    ref.read(loginedUserUID.notifier).update((state) => "");
    ref.read(loginUserData.notifier).update((state) => ProfileData());

    render();
  }

  Future<void> commonLoginFunc({required ProfileData requestUserData}) async {
    ref.read(loginUserData.notifier).update((state) => requestUserData);

    /// 最後ログインのタイム更新する
    await UserService().updateUserLoginLastTime(requestUserData.uid);

    /// 読んでいない通知数取得する
    String notReadNotificationCount = await NotificationService().requestNoReadNotificationAmount(
      userUId: requestUserData.uid,
    );
    ref.read(loginUserNotReadNotificationCount.notifier).update((state) => int.parse(notReadNotificationCount));

    /// チャットルームリストWS初始化
    ChatWSModel().init(ref, () => render(), userId: ref.watch(loginUserData).uid);
  }
}
