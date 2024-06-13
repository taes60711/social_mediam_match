import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:social_mediam_match/components/strings/account/login_strings.dart';
import 'package:social_mediam_match/components/strings/message_strings/account_message.dart';
import 'package:social_mediam_match/models/user_model.dart';
import 'package:social_mediam_match/states/friend_state.dart';

import '../../services/firebase_service.dart';
import '../../services/user_service.dart';

///ユーザ資料について（登録の関数がSignUpViewModel、SignUpViewProivderにいる）
class UserProvider extends ChangeNotifier {
  ///ユーザでータ
  LoginUser userData = LoginUser(
    uid: "-1",
    token: null,
    image: null,
    email: "",
    isEmailVerified: false,
    name: null,
    job: null,
    lastLogin: "",
    status: 0,
    introduction: null,
    mainSkills: [],
    wantSkills: [],
  );

  ///ページローディング
  bool isLoading = false;

  ///パスワード忘れたページに送信したメッセージ
  String resetPwdError = ResetPwdStatus.noMessage.value;

  ///ログインのエラーメッセージ
  String loginError = LoginError().noError;

  //メソッド：アプリ始めるスタート場合は，ユーザーログインがどうか確認する
  void isLoginCheck(FriendState chatListChannel) {
    if (userData.uid == "-1") {
      FirebaseSerivce().firebaseLoginCheck().listen((String userUID) async {
        if (userUID != "noUID" && !isLoading) {
          isLoading = true;
          notifyListeners();

          //ユーザの資料を取得する
          userData = await UserService().requestGetUserData(userUID);
          if (userData.uid != "-1") {
            //最後ログインのタイム更新する
            await UserService().sqlUpdateUserLoginLastTime(userUID);
            //チャットルームサーバー繋がる
            chatListChannel.friendListConnect(userUID);
            print("LoginedUserData ${userData.uid}");

            if (Platform.isAndroid) {
              //取得使用者TOKEN > 通知系統在上架前,先暫時只給安卓使用
              final fcmToken = await FirebaseMessaging.instance.getToken();
              await UserService().sqlUpdateUserToken(userUID, fcmToken!);
            }
          }

          isLoading = false;
          notifyListeners();
        }
      });
    }
  }

  ///メソッド：ログイン
  ///email：メールアドレス，password：パスワード
  Future<bool> signIn(String email, String password) async {
    bool isSucess = true;

    String signInResult = await FirebaseSerivce().firebaseSignIn(email, password);
    if (!signInResult.contains("Sucess")) {
      loginError = signInResult;
      isSucess = false;
      notifyListeners();
    }

    return isSucess;
  }

  ///メソッド：ログアウト
  Future<void> signOut(FriendState chatListChannel) async {
    await FirebaseSerivce().firebaseSignOut();
    chatListChannel.closefriendList();
    userData.uid = "-1";
    notifyListeners();
  }

  ///メソッド：パスワード忘れた場合，パスワードがメール送ってリセット
  ///email：ユーザ登録のメールアドレス
  Future<void> reSetPwd(String email) async {
    resetPwdError = await FirebaseSerivce().reSetPwd(email);
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
