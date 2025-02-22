// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/account/complete_profile_step.dart';
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
    return ref.read(loginUserData.notifier).state.uid != "-1";
  }

  bool isGuest() {
    return ref.read(loginUserData.notifier).state.uid == "guest";
  }

  /// ゲストでログイン
  void useGuestLogin() {
    ref.read(loginUserData.notifier).update(
          (state) => ProfileData(
            uid: "guest",
            name: "未登入",
            mainSkills: [],
            wantSkills: [],
            status: 999,
          ),
        );
    render();
  }

  /// ゲスト場合でログアウト
  void guestLogOut({Function? attachFunc}) {
    ref.read(loginedUserUID.notifier).update((state) => "");
    ref.read(loginUserData.notifier).update((state) => ProfileData());
    render();
    if (attachFunc != null) {
      attachFunc();
    }
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
      if (requestUserData.uid != "-1") {
        await commonLoginFunc(requestUserData: requestUserData);
      }
    }
  }

  ///loginType = normalSign , googleSign
  Future<bool> login({required LoginDataModel loginInputData, String loginType = "normalSign"}) async {
    bool loginDataGetSuccess = false;

    /// ユーザデータ取得
    ///loginType = normalSign , googleSign
    ProfileData requestUserData = await UserService().requestUserDataByEmail(
      loginInputData.account,
      loginInputData.pwd,
      loginType: loginType,
    );

    print("LoginUserUID: ${requestUserData.uid}");
    if (requestUserData.uid != "-1") {
      loginDataGetSuccess = true;

      /// ログイン前にスキルを選択したこと確認
      if (requestUserData.mainSkills!.isEmpty || requestUserData.wantSkills!.isEmpty) {
        /// スキルを選択してない場合
        CompleteProfileStepPage(
          choicedSkillData: (skills, wantSkills) async {
            UpdateUser sqlUpdateData = UpdateUser.update(
              uid: requestUserData.uid,
              name: requestUserData.name,
              image: requestUserData.image,
              job: requestUserData.job,
              introduction: requestUserData.introduction,
              mainSkills: skills,
              wantSkills: wantSkills,
            );

            await UserService().updateUserData(requestUserData.uid, sqlUpdateData);

            requestUserData.mainSkills = skills;
            requestUserData.wantSkills = wantSkills;

            await loginSaveUIDToPhone(requestUserData);
            render();
          },
        ).show(context);

        return loginDataGetSuccess;
      } else {
        /// スキルを選択した場合
        await loginSaveUIDToPhone(requestUserData);
        render();

        return loginDataGetSuccess;
      }
    } else {
      return loginDataGetSuccess;
    }
  }

  /// アカウント削除
  Future<void> deleteAccount() async {
    /// アカウント削除
    bool isSuccess = await UserService().deleteUser(userUID: ref.read(loginUserData).uid);
    if (isSuccess) {
      await logOut();
    } else {
      print("deleteAccount  Failed");
    }
  }

  Future<void> logOut({bool needUpdateToken = true}) async {
    if (needUpdateToken) {
      /// 通知用のtoken削除
      await UserService().updateUserToken(ref.read(loginUserData).uid, '');
    }

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

  /// ＳＤにユーザUID保存 & ログイン処理
  Future<void> loginSaveUIDToPhone(ProfileData requestUserData) async {
    /// ＳＤにユーザUID保存
    await sharedPreference.loginSetUserUID(requestUserData.uid);
    ref.read(loginedUserUID.notifier).update((state) => requestUserData.uid);

    /// ログイン処理
    await commonLoginFunc(requestUserData: requestUserData);
  }

  /// ログイン処理
  Future<void> commonLoginFunc({required ProfileData requestUserData}) async {
    ref.read(loginUserData.notifier).update((state) => requestUserData);

    /// 最後ログインのタイム更新する
    await UserService().updateUserLoginLastTime(requestUserData.uid);

    /// 読んでいない通知数取得する
    String notReadNotificationCount = await NotificationService().requestNoReadNotificationAmount(
      userUId: requestUserData.uid,
    );
    ref.read(loginUserNotReadNotificationCount.notifier).update((state) => int.parse(notReadNotificationCount));
  }
}
