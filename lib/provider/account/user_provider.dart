// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/models/user_model.dart';
import '../../services/firebase_service.dart';
import '../../services/user_service.dart';
import '../friend_provider.dart';

///ユーザ資料について（登録の関数がSignUpViewModel、SignUpViewProivderにいる）
class UserProvider extends ChangeNotifier {
  ///ユーザでータ
  LoginUser userData = LoginUser();

  ///isLoginCheckページローディング
  bool isLoading = false;

  ///メソッド：アプリ始めるスタート場合は，ユーザーログインがどうか確認する
  // ユーザの資料を取得、最後ログインのタイム更新、友達リスト（WS）繋がる
  void isLoginCheck(BuildContext context) async {
    if (userData.uid == "-1") {
      FirebaseSerivce().firebaseLoginCheck().listen((String userUID) async {
        if (userUID != "noUID" && !isLoading) {
          isLoading = true;
          notifyListeners();

          // ユーザの資料を取得する
          userData = await UserService().requestGetUserData(userUID);
          if (userData.uid != "-1") {
            // 最後ログインのタイム更新する
            await UserService().sqlUpdateUserLoginLastTime(userUID);
            // 友達リスト（WS）繋がる
            context.read<FriendProvider>().friendListConnect(userUID);
            if (Platform.isAndroid) {
              // 取得使用者TOKEN > 通知系統在上架前,先暫時只給安卓使用
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

  ///メソッド：ログアウト
  Future<void> signOut(FriendProvider chatListChannel) async {
    await FirebaseSerivce().firebaseSignOut();
    chatListChannel.closefriendList();
    userData = LoginUser();
    notifyListeners();
  }

  ///メソッド：ユーザ資料更新する
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
