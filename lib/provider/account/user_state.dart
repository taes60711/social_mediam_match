import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:social_mediam_match/components/strings/account/login_strings.dart';
import 'package:social_mediam_match/components/strings/message_strings/account_message.dart';
import 'package:social_mediam_match/models/user_model.dart';
import 'package:social_mediam_match/states/friend_state.dart';
import 'package:social_mediam_match/states/services/user_service.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //ユーザダータ
  LoginUser? userData;
  //ページローディング
  bool isLoading = false;
  //パスワード忘れたページに送信したメッセージ
  String resetPwdError = ResetPwdStatus.noMessage.value;

  //メソッド：アプリ始めるスタート場合は，ユーザーログインがどうか確認する
  void isLoginCheck(FriendState chatListChannel) {
    Stream<String> colsure() {
      return _auth.authStateChanges().map((event) {
        return event != null ? event.uid : "";
      });
    }

    if (userData == null) {
      colsure().listen((String userUID) async {
        if (userUID != "" && !isLoading) {
          isLoading = true;
          notifyListeners();

          //ユーザの資料を取得する
          userData = await UserService().requestGetUserData(userUID);
          //最後ログインのタイム更新する
          await UserService().sqlUpdateUserLoginLastTime(userUID);
          //チャットルームサーバー繋がる
          chatListChannel.friendListConnect(userUID);
          inspect(userData);

          if (Platform.isAndroid) {
            //取得使用者TOKEN > 通知系統在上架前,先暫時只給安卓使用
            final fcmToken = await FirebaseMessaging.instance.getToken();
            await UserService().sqlUpdateUserToken(userUID, fcmToken!);
          }

          isLoading = false;
          notifyListeners();
        }
      });
    }
  }

  //ログインのエラーメッセージ
  String loginError = LoginError().noError;
  //メソッド：ログイン
  //param
  //email：メールアドレス，password：パスワード
  Future<bool> signIn(String email, String password) async {
    bool isSucess = false;

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      isSucess = true;
    } on FirebaseAuthException catch (e) {
      print("signIn error ${e.code}");
      switch (e.code) {
        case "invalid-credential":
          loginError = LoginError().emailorPwdError;
          break;
        case "invalid-email":
          loginError = LoginError().emailFormatError;
          break;
        case "channel-error":
          loginError = "channel-error";
      }
      notifyListeners();
    }
    return isSucess;
  }

  //メソッド：ログアウト
  Future<void> signOut(FriendState chatListChannel) async {
    await _auth.signOut().then((value) {
      chatListChannel.closefriendList();
      userData = null;
      notifyListeners();
    });
  }

  //メソッド：パスワード忘れた場合，パスワードがメール送ってリセット
  //param
  //email：ユーザ登録のメールアドレス
  Future<void> reSetPwd(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print("Email Sended");
      resetPwdError = ResetPwdStatus.success.value;
    } catch (e) {
      resetPwdError = ResetPwdStatus.error.value;
      print("Email Error $resetPwdError");
      notifyListeners();
    }
  }

  Future<void> getUserData(String uid) async {
    userData = await UserService().requestGetUserData(uid);
    notifyListeners();
  }

  Future<bool> updateProfile(String uid, UpdateUser updateData) async {
    bool isSucess = false;
    try {
      isSucess = await UserService().sqlUpdateUserData(uid, updateData);
      if (isSucess) {
        userData = await UserService().requestGetUserData(uid);
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
    return isSucess;
  }
}
