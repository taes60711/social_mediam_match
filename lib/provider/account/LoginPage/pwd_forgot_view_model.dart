import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../components/utilities/lodaing_dialog.dart';
import '../../../services/user_service.dart';

class PwdForgotViewModel {
  BuildContext? context;
  WidgetRef? ref;
  Function? render;
  PwdForgotViewModel({this.ref, this.context, this.render});

  TextEditingController accountController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController verifyController = TextEditingController();

  bool emailCantChange = false;

  String errMsg = "";
  String emailErr = "";
  String confrimPwdErr = "";
  String verifyErr = "";

  bool pwdleastSix = false;
  bool pwdNeedEnglish = false;
  bool pwdNeedNum = false;

  /// 送驗證碼
  Future<bool> sendCaptchaMail() async {
    String result = "";
    LoadingDialog().show(loadingMsg: "驗證碼寄送至信箱中...");
    print(accountController.text);
    if (_checkEmailFormat()) {
      result = await UserService().sendCaptchaMail(
        email: accountController.text,
        type: "resetPwd",
      );
    }
    LoadingDialog().close();

    if (result == "success") {
      emailCantChange = true;
      render!();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> sendOnpress() async {
    pwdCheck();
    String result = "";
    LoadingDialog().show();
    if (sendBeforeCheck()) {
      result = await UserService().updateUserPwdByMail(
        captchaCode: verifyController.text,
        email: accountController.text,
        newPwd: passwordController.text,
      );
    }

    if (result == "success") {
      LoadingDialog().close();

      Navigator.of(context!).popUntil((route) => route.isFirst);
      render!();
      return true;
    } else if (result == "captchaCodeErr") {
      verifyErr = "驗證碼輸入錯誤";
      render!();
      LoadingDialog().close();
      return false;
    } else {
      LoadingDialog().close();
      return false;
    }
  }

  bool sendBeforeCheck() {
    bool isOK = true;
    pwdCheck();
    if (verifyController.text == "") {
      verifyErr = "驗證碼不得為空";
      isOK = false;
    }

    if (accountController.text == "") {
      emailErr = "信箱不得為空";
      isOK = false;
    }

    if (passwordController.text != confirmPasswordController.text) {
      confrimPwdErr = "輸入的密碼不正確";
      isOK = false;
    }

    if (!pwdleastSix || !pwdNeedEnglish || !pwdNeedNum) {
      isOK = false;
    }

    return isOK;
  }

  bool _checkEmailFormat() {
    bool isOK = true;
    emailErr = "";
    RegExp emailRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (accountController.text == "") {
      emailErr = "信箱不能為空";
      isOK = false;
    } else if (!emailRegExp.hasMatch(accountController.text)) {
      emailErr = "信箱格式錯誤";
      isOK = false;
    }
    render!();
    return isOK;
  }

  void pwdCheck() {
    pwdleastSix = false;
    pwdNeedEnglish = false;
    pwdNeedNum = false;
    if (passwordController.text.length >= 6) {
      pwdleastSix = true;
    }
    if (RegExp(r'[a-zA-Z]').hasMatch(passwordController.text)) {
      pwdNeedEnglish = true;
    }
    if (RegExp(r'[0-9]').hasMatch(passwordController.text)) {
      pwdNeedNum = true;
    }
  }
}
