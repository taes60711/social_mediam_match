import 'package:flutter/material.dart';

import '../../../components/strings/account/login_strings.dart';
import '../../../components/strings/message_strings/account_message.dart';
import '../../../services/firebase_service.dart';

class LoginProvider extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();

  ///パスワード忘れたページに送信したメッセージ
  String resetPwdError = ResetPwdStatus.noMessage.value;

  ///ログインのエラーメッセージ
  String loginError = LoginError.noError;

  // ///メソッド：ログイン
  // ///email：メールアドレス，password：パスワード
  // Future<bool> signIn(String email, String password) async {
  //   bool isSucess = true;

  //   String signInResult = await FirebaseSerivce().firebaseSignIn(email, password);
  //   if (!signInResult.contains("Sucess")) {
  //     loginError = signInResult;
  //     isSucess = false;
  //     notifyListeners();
  //   }

  //   return isSucess;
  // }

  // ///メソッド：パスワード忘れた場合，パスワードがメール送ってリセット
  // ///email：ユーザ登録のメールアドレス
  // Future<void> reSetPwd(String email) async {
  //   resetPwdError = await FirebaseSerivce().reSetPwd(email);
  //   notifyListeners();
  // }
}
