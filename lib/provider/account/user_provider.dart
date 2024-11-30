// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:social_mediam_match/models/user_model.dart';

/// ログイン中のユーザデータ
final loginUserData = StateProvider<ProfileData>((ref) {
  return ProfileData();
});

/// ログイン中のユーザデータ
final loginUserNotReadNotificationCount = StateProvider<int>((ref) {
  return -1;
});

///ユーザ資料について（登録の関数がSignUpViewModel、SignUpViewProivderにいる）
class UserProvider extends ChangeNotifier {
  ///ユーザでータ
  ProfileData userData = ProfileData();

  /// 読んでいない通知数
  String notReadNotificationCount = "0";

  ///isLoginCheckページローディング
  bool isLoading = false;

  bool isSignUp = false;

  ///メソッド：アプリ始めるスタート場合は，ユーザーログインがどうか確認する
  // ユーザの資料を取得、最後ログインのタイム更新、友達リスト（WS）繋がる
  void isLoginCheck(BuildContext context) async {
    if (userData.uid == "-1") {
      // FirebaseSerivce().firebaseLoginCheck().listen((String userUID) async {
      //   if (userUID != "noUID" && !isLoading && !isSignUp) {
      //     isLoading = true;
      //     notifyListeners();
      //     // ユーザの資料を取得する
      //     userData = await UserService().requestGetUserData(userUID);
      //     if (userData.uid != "-1") {
      //       // 最後ログインのタイム更新する
      //       await UserService().updateUserLoginLastTime(userUID);
      //       // 友達リスト（WS）繋がる
      //       context.read<FriendProvider>().friendListConnect(userUID);

      //       /// 読んでいない通知数取得する
      //       await getNotificationCount();
      //       if (Platform.isAndroid) {
      //         // 取得使用者TOKEN > 通知系統在上架前,先暫時只給安卓使用
      //         final fcmToken = await FirebaseMessaging.instance.getToken();
      //         print("fcmToken $fcmToken");
      //         await UserService().updateUserToken(userUID, fcmToken!);
      //       }
      //     }

      //     isLoading = false;
      //     notifyListeners();
      //   }
      // });
    }
  }

  ///メソッド： 通知数更新する
  void updateNotificationCount({bool allRead = false}) {
    if (allRead) {
      notReadNotificationCount = "0";
    } else {
      int count = int.parse(notReadNotificationCount);
      count--;
      notReadNotificationCount = "$count";
    }

    notifyListeners();
  }
}
