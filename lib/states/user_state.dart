import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_mediam_match/global.dart';
import 'package:social_mediam_match/message_strings/account_message.dart';
import 'package:social_mediam_match/models/user_model.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class UserState extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //ユーザダータ
  UserLoginModel? userData;
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

  bool _isSignUp = false;

  //メソッド：アプリ始めるスタート場合は，ユーザーログインがどうか確認する
  void isLoginCheck() {
    Stream<String> colsure() {
      return _auth.authStateChanges().map((event) {
        return event != null ? event.uid : "";
      });
    }

    if (userData == null) {
      colsure().listen((String userUID) async {
        if (userUID != "" && !_isSignUp) {
          isLoading = true;
          userData = await getUserData(userUID);
          print(userData);
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
          print("firebase SiginUp Sucess:${value.user!.uid}");
          var uri = Uri.parse('$url/signUp');
          Map<String, String> headers = {'content-type': 'application/json'};

          UserSignUpModel signedUpUserData = UserSignUpModel(
            uid: value.user!.uid,
            email: email,
            password: password,
            isEmailVerified: false,
          );

          String body = jsonEncode(signedUpUserData);

          await http.put(uri, headers: headers, body: body).then((_) => print("MySql SiginUp Sucess:${_.body}"));
          isSucess = true;
          _isSignUp = false;
        },
      );
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
    return isSucess;
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




    // //加密
    // final key = encrypt.Key.fromUtf8(aesKey);
    // final iv = encrypt.IV.fromUtf8(aesIV);
    // final encrypter = encrypt.Encrypter(encrypt.AES(key));
    // final encrypted = encrypter.encrypt(password, iv: iv);
    // print(encrypted.base64);

    // // 解密
    // final encrypters = encrypt.Encrypter(encrypt.AES(key));
    // String s = "jzXPDhqma8EuBofE3jCTpA==";
    // final decrypteds = encrypters.decryptBytes(encrypt.Encrypted.fromBase64(s), iv: iv);
    // final decryptedData = utf8.decode(decrypteds);
    // print(decryptedData);
