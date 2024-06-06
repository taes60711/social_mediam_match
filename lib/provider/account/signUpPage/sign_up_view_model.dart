import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/provider/account/signUpPage/sign_up_view_provider.dart';

import '../../../components/utilities/style/style_config.dart';
import '../../../states/services/firebase_service.dart';
import '../../../states/services/user_service.dart';

class SignUpViewModel {
  ///メールチェック
  void emailCheck(BuildContext context) {
    SignUpViewProvider signUpViewProvider = Provider.of<SignUpViewProvider>(context, listen: false);
    bool isEmail = signUpViewProvider.signUpEmailCheck(signUpViewProvider.emailController.text);
    if (isEmail) {
      signUpViewProvider.onChangeSignUpPage(1);
      signUpViewProvider.signUpErrorReset();
    }
  }

  ///登録始まる
  Future<void> signUpStart(BuildContext context) async {
    Future<void> loadingPopView() {
      return showDialog<void>(
        barrierDismissible: false,
        barrierColor: barrierColor,
        context: context,
        builder: (BuildContext context) {
          return LoadingAnimationWidget.inkDrop(color: normalBgColor, size: 35);
        },
      );
    }

    void closePop() {
      if (!ModalRoute.of(context)!.isCurrent) {
        Navigator.of(context).pop();
      }
    }

    SignUpViewProvider signUpViewProvider = Provider.of<SignUpViewProvider>(context, listen: false);

    String email = signUpViewProvider.emailController.text;
    String password = signUpViewProvider.pwdController.text;

    print("Email $email Pwd $password");

    loadingPopView();

    // String signUpResult = await signUp(email, password);
    // signUpViewProvider.signUpResultChange(signUpResult);
    await Future.delayed(const Duration(seconds: 1));

    closePop();

    signUpViewProvider.onChangeSignUpPage(2);
  }

  ///firebaseServer、MysqlServer登録
  ///email：メールアドレス，password：パスワード
  Future<String> signUp(String email, String password) async {
    String signUpResult = "";

    String firebaseSignUpResult = await FirebaseSerivce().firebaseSignUp(email, password);

    if (firebaseSignUpResult.contains("sucess:")) {
      String tempSignedUID = firebaseSignUpResult.substring(("sucess:").length);
      bool isMySqlSignUpSucess = await UserService().sqlSignUp(tempSignedUID, email, password);

      if (isMySqlSignUpSucess) {
        signUpResult = firebaseSignUpResult;
      } else {
        signUpResult = "mysql-error";
      }
    } else {
      signUpResult = firebaseSignUpResult;
    }
    return signUpResult;
  }
}
