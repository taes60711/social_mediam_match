import 'package:flutter/material.dart';
import '../../../components/strings/account/sign_up_strings.dart';
import '../../../enum/skill_type.dart';

class SignUpViewProvider extends ChangeNotifier {
  ///メールインプット
  TextEditingController emailController = TextEditingController();

  ///パスワードインプット
  TextEditingController pwdController = TextEditingController();

  ///サインアップステップインデックス
  int pageIndex = 0;

  ///サインアップのエラーメッセージ
  String signError = SignUpError.noError;

  ///登録成功したらUIDもらってユーザ資料更新為に
  String signedUID = "";

  ///サインアップページ変更
  void onChangeSignUpPage(int toPageIndex) {
    pageIndex = toPageIndex;
    notifyListeners();
  }

  ///メソッド：メールアドレスかどうか確認
  ///email：メールアドレス
  bool signUpEmailCheck(String email) {
    bool isEmail = true;
    if (!email.contains("@")) {
      signError = SignUpError.emailFormatError;
      notifyListeners();
      isEmail = false;
    }
    return isEmail;
  }

  ///すべてステップ終わったらUIDもらう、
  ///またはエラーメッセージ画面に更新する
  void signUpResultChange(String uid) async {
    if (uid.contains("sucess:")) {
      signedUID = uid.substring(("sucess:").length);
    } else {
      signError = uid;
      notifyListeners();
    }
  }

  ///サインアップのエラーメッセージクリア
  void signUpErrorReset() {
    signError = SignUpError.noError;
    notifyListeners();
  }
}
