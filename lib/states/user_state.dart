import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_mediam_match/global.dart';
import 'package:social_mediam_match/components/strings/message_strings/account_message.dart';
import 'package:social_mediam_match/models/user_model.dart';
import 'package:social_mediam_match/states/friend_state.dart';
import 'package:social_mediam_match/states/services/db_service.dart';

class UserState extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DBService _dbService = DBService();
  //ユーザダータ
  LoginUser? userData;
  //ページローディング
  bool isLoading = false;
  //パスワード忘れたページに送信したメッセージ
  String resetPwdError = ResetPwdStatus.NoMessage.value;
  //ログインのエラーメッセージ
  String loginError = LoginStatus.NoMessage.value;
  //ログインのエラーメッセージ
  String signError = SignUpStatus.NoMessage.value;
  //サーバーアドレス
  String url = "http://$ip:$port/user";
  //登録かどうか確認、登録したらログインしなくてために
  bool _isSignUp = false;

  //メソッド：アプリ始めるスタート場合は，ユーザーログインがどうか確認する
  void isLoginCheck(FriendState chatListChannel) {
    Stream<String> colsure() {
      return _auth.authStateChanges().map((event) {
        return event != null ? event.uid : "";
      });
    }

    if (userData == null) {
      colsure().listen((String userUID) async {
        if (userUID != "" && !_isSignUp) {
          isLoading = true;
          userData = await _dbService.getUserData(userUID);

          chatListChannel.friendListConnect(userData!.uid);
          notifyListeners();
          inspect(userData);
          isLoading = false;
          notifyListeners();
        }
      });
    }
  }

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
          loginError = LoginStatus.EmailorPwdError.value;
          break;
        case "invalid-email":
          loginError = LoginStatus.EmailFormatError.value;
          break;
        case "channel-error":
          loginError = LoginStatus.EmailFormatError.value;
      }
      notifyListeners();
    }
    return isSucess;
  }

  //メソッド：登録
  //param
  //email：メールアドレス，password：パスワード
  Future<dynamic> signUp(String email, String password) async {
    bool isSucess = false;
    try {
      _isSignUp = true;
      await _auth.createUserWithEmailAndPassword(email: email, password: password).then(
        (UserCredential value) async {
          print("firebase SiginUp Success:${value.user!.uid}");

          bool isMysqlSignUpSucess = await _dbService.signUpUser(value.user!.uid, email, password);

          if (isMysqlSignUpSucess) {
            isSucess = true;
          }
        },
      ).then((value) {
        //firebaseのlistenで自動ログインなのでバッグ発生なくよう、先にログアウト追加する。
        signOut();
      });
    } on FirebaseAuthException catch (e) {
      print("SignUp error ${e.code}");
      switch (e.code) {
        case "invalid-email":
          signError = SignUpStatus.EmailFormatError.value;
          break;
        case "weak-password":
          signError = SignUpStatus.PwdWeakError.value;
          break;
      }
      notifyListeners();
    }
    _isSignUp = false;
    print("_isSignUp ${_isSignUp}");
    return isSucess;
  }

  //メソッド：ログアウト
  void signOut() {
    _auth.signOut().then((value) {
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

      resetPwdError = ResetPwdStatus.Success.value;
    } catch (e) {
      resetPwdError = ResetPwdStatus.Error.value;
      print("Email Error $resetPwdError");
      notifyListeners();
    }
  }

  Future<void> updateProfile(String uid, UpdateUser updateData) async {
    try {
      await _dbService.updateUserData(uid, updateData).then((isSucess) {
        if (isSucess) {
          userData!.name = updateData.name;
          userData!.introduction = updateData.introduction;
          userData!.mainSkills = updateData.mainSkills;
          userData!.wantSkills = updateData.wantSkills;
          notifyListeners();
        }
      });
    } catch (e) {
      print(e);
    }
  }
}
