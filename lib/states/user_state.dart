import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_mediam_match/message_strings/account_message.dart';
import 'package:social_mediam_match/service/db_service.dart';

class UserState extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DBService dbService = DBService();
  //ユーザダータ
  String userData = "";
  //ページローディング
  bool isLoading = false;
  //パスワード忘れたページに送信したメッセージ
  String resetPwdError = "";

  //メソッド：アプリ始めるスタート場合は，ユーザーログインがどうか確認する
  String isLoginCheck() {
    Stream<String> colsure() {
      return _auth.authStateChanges().map((event) {
        return event != null ? event.uid : "";
      });
    }

    if (userData == "") {
      colsure().listen((event) {
        userData = event;
        notifyListeners();
      });
    }
    return userData;
  }

  //メソッド：ログイン
  //param
  //email：メールアドレス，password：パスワード
  Future<bool> signIn(String email, String password) async {
    bool isSucess = false;
    try {
      isLoading = true;
      notifyListeners();
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        print("SignIn Success: ${value}");
        isSucess = true;
      });
      isLoading = false;
    } catch (e) {
      print("$e");
    }
    return isSucess;
  }

  //メソッド：登録
  //param
  //email：メールアドレス，password：パスワード
  Future<dynamic> signUp(String email, String password) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        print("SignUp Successfull: $value");
      });
      await dbService.signUp(email);
      return true;
    } catch (e) {
      print("$e");
      return e;
    }
  }

  //メソッド：ログアウト
  void signOut() {
    _auth.signOut().then((value) => print("signOut Successfull"));
  }

  //メソッド：パスワード忘れた場合，パスワードがリセット
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
}
