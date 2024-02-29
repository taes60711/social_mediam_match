import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_mediam_match/config.dart';
import 'package:social_mediam_match/message_strings/account_message.dart';

class UserState extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
      await _auth.signInWithEmailAndPassword(email: email, password: password).then((value) {
        print("SignIn Success: ${value}");
        // var uri = Uri.parse('http://61.228.189.249:80/user/ACqYscxtd2VSdPlkv1G8OgSTKxd2');
        // var response = await http.get(uri);
        // print(response.body);
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
      await _auth.createUserWithEmailAndPassword(email: email, password: password).then((UserCredential value) async {
        print("SignUp Successfull: ${value.user!.uid}");
        var uri = Uri.parse('http://$ip:$port/user/signUp');
        Map<String, String> headers = {'content-type': 'application/json'};
        String body = json.encode({"uid": value.user!.uid, "email": email, "password": password, "isEmailVerified": false});

        var resp = await http.put(uri, headers: headers, body: body);
        print(resp.body);
      });

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
