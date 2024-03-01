import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_mediam_match/global.dart';
import 'package:social_mediam_match/message_strings/account_message.dart';
import 'package:social_mediam_match/models/user_model.dart';

class UserState extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //ユーザダータ
  UserLoginModel? userData;
  //ページローディング
  bool isLoading = false;
  //パスワード忘れたページに送信したメッセージ
  String resetPwdError = ResetPwdStatus.NoMessage.value;
  //サーバーアドレス
  String url = "http://$ip:$port/user";

  //メソッド：アプリ始めるスタート場合は，ユーザーログインがどうか確認する
  void isLoginCheck() {
    Stream<String> colsure() {
      return _auth.authStateChanges().map((event) {
        return event != null ? event.uid : "";
      });
    }

    if (userData == null) {
      colsure().listen((String userUID) async {
        if (userUID != "") {
          userData = await getUserData(userUID);
          print(userData);
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
      isLoading = true;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      isSucess = true;
      isLoading = false;
      notifyListeners();
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
        print("Firebase SignUp Success: ${value.user!.uid}");
        var uri = Uri.parse('$url/signUp');
        Map<String, String> headers = {'content-type': 'application/json'};

        UserSignUpModel signedUpUserData = UserSignUpModel(
          uid: value.user!.uid,
          email: email,
          isEmailVerified: false,
        );

        String body = json.encode(signedUpUserData);

        var resp = await http.put(uri, headers: headers, body: body);
        print("MySql SiginUp Sucess:${resp.body}");
      });
      return true;
    } catch (e) {
      print("$e");
      return e;
    }
  }

  Future<UserLoginModel?> getUserData(String uid) async {
    var uri = Uri.parse('$url/$uid');
    UserLoginModel? userdata;
    try {
      var response = await http.get(uri);

      if (response.statusCode != 404) {
        userdata = UserLoginModel.fromMap(json.decode(response.body));
      }
    } catch (e) {
      print(e);
    }
    return userdata;
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
}
