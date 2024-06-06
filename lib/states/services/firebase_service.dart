import 'package:firebase_auth/firebase_auth.dart';

import '../../components/strings/account/sign_up_strings.dart';

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
          signUpResult = SignUpError().emailFormatError;
          break;
        case "weak-password":
          signUpResult = SignUpError().pwdWeakError;
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
}
