import 'package:firebase_auth/firebase_auth.dart';

import '../../components/strings/account/login_strings.dart';
import '../../components/strings/account/sign_up_strings.dart';
import '../../components/strings/message_strings/account_message.dart';

class FirebaseSerivce {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ///メソッド：登録
  ///email：メールアドレス，password：パスワード
  Future<String> firebaseSignUp(String email, String password) async {
    String signUpResult = "";

    try {
      UserCredential value = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      if (value.user != null) {
        print("firebase SiginUp Success:${value.user!.uid}");
        signUpResult = "sucess:${value.user!.uid}";
      } else {
        throw ArgumentError("signup-error");
      }
    } on FirebaseAuthException catch (e) {
      print("SignUp error ${e.code}");
      switch (e.code) {
        case "invalid-email":
          signUpResult = SignUpError.emailFormatError;
          break;
        case "weak-password":
          signUpResult = SignUpError.pwdWeakError;
          break;
        case "signup-error":
          signUpResult = "signup-error";
          break;
        case "channel-error":
          signUpResult = "channel-error";
          break;
      }
    }

    return signUpResult;
  }

  ///ログインチェック
  Stream<String> firebaseLoginCheck() {
    return _auth.authStateChanges().map((event) {
      return event != null ? event.uid : "noUID";
    });
  }

  ///メソッド：ログイン
  ///email：メールアドレス，password：パスワード
  Future<String> firebaseSignIn(String email, String password) async {
    String loginResult = "";
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      loginResult = "Sucess";
    } on FirebaseAuthException catch (e) {
      print("signIn error ${e.code}");
      switch (e.code) {
        case "invalid-credential":
          loginResult = LoginError.emailorPwdError;
          break;
        case "invalid-email":
          loginResult = LoginError.emailFormatError;
          break;
        case "channel-error":
          loginResult = "channel-error";
      }
    }
    return loginResult;
  }

  ///メソッド：ログアウト
  Future<void> firebaseSignOut() async {
    print("firebaseSignOut");
    await _auth.signOut();
  }

  ///メソッド：パスワード忘れた場合，パスワードがメール送ってリセット
  ///email：ユーザ登録のメールアドレス
  Future<String> reSetPwd(String email) async {
    String reSetResult = "";
    try {
      await _auth.sendPasswordResetEmail(email: email);
      reSetResult = ResetPwdStatus.success.value;
    } catch (e) {
      reSetResult = ResetPwdStatus.error.value;
      print("Email Error $reSetResult");
    }

    return reSetResult;
  }
}
