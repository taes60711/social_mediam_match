import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/provider/account/signUpPage/sign_up_view_provider.dart';

import '../../../components/utilities/style/style_config.dart';
import '../../../global.dart';
import '../../../states/services/firebase_service.dart';
import '../../../states/services/user_service.dart';

class SignUpViewModel {
  BuildContext context;
  SignUpViewModel({required this.context});

  ///ページ遷移の関数
  void backButtonFUnc() {
    SignUpViewProvider signUpViewProvider = context.read<SignUpViewProvider>();
    int preIndex = signUpViewProvider.pageIndex - 1;
    if (preIndex < 0 || preIndex >= 1) {
      Navigator.of(context).popUntil(ModalRoute.withName(RoutePath.home.value));
    } else {
      signUpViewProvider.onChangeSignUpPage(preIndex);
    }
  }

  ///メールチェック
  void emailCheck() {
    SignUpViewProvider signUpViewProvider = context.read<SignUpViewProvider>();
    bool isEmail = signUpViewProvider.signUpEmailCheck(signUpViewProvider.emailController.text);
    if (isEmail) {
      signUpViewProvider.onChangeSignUpPage(1);
      signUpViewProvider.signUpErrorReset();
    }
  }

  ///登録始まる
  Future<void> signUpStart() async {
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

    SignUpViewProvider signUpViewProvider = context.read<SignUpViewProvider>();

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
