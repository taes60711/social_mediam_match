// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:social_mediam_match/models/user_model.dart';

/// ログイン中のユーザデータ
final loginUserData = StateProvider<ProfileData>(
  (ref) {
    return ProfileData(
      uid: "guest",
      name: "未登入",
      mainSkills: [],
      wantSkills: [],
      status: 999,
    );
  },
);

/// ログイン中のユーザの読んでない数
final loginUserNotReadNotificationCount = StateProvider<int>((ref) {
  return 0;
});

/// ログイン中のユーザ
final loginUserInChatRoomId = StateProvider<int>((ref) {
  return -1;
});

///ユーザ資料について（登録の関数がSignUpViewModel、SignUpViewProivderにいる）
class UserProvider extends ChangeNotifier {
  /// 読んでいない通知数
  String notReadNotificationCount = "0";

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
