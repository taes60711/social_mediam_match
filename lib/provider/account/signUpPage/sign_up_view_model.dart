import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../components/utilities/lodaing_dialog.dart';
import '../../../models/user_model.dart';
import '../../../services/user_service.dart';

class SignUpViewModel {
  BuildContext? context;
  WidgetRef? ref;

  SignUpViewModel({this.ref, this.context});
  TextEditingController accountController = TextEditingController();
  TextEditingController verifyController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  String signUpedUserUID = "";

  String emailErr = "";
  String nameErr = "";
  String confrimPwdErr = "";
  String verifyErr = "";

  bool pwdleastSix = false;
  bool pwdNeedEnglish = false;
  bool pwdNeedNum = false;

  /// 送驗證碼
  Future<bool> sendCaptchaMail() async {
    String result = "";
    LoadingDialog().show(loadingMsg: "驗證碼寄送至信箱中...");
    _resetAllErrMsg();

    if (_checkEmailFormat()) {
      result = await UserService().sendCaptchaMail(email: accountController.text);
    }
    LoadingDialog().close();

    if (result == "success") {
      return true;
    } else if (result == "emailExist") {
      emailErr = "該信箱已經存在, 請使用其他信箱";
      return false;
    } else {
      return false;
    }
  }

  /// 註冊
  /// success , captchaCodeErr
  Future<bool> signUp() async {
    _resetAllErrMsg();
    String result = "";
    LoadingDialog().show(loadingMsg: "註冊中...");
    if (signUpSendBeforeCheck()) {
      result = await UserService().signUp(
        captchaCode: verifyController.text,
        email: accountController.text,
        password: passwordController.text,
        name: nameController.text,
      );
    }

    if (result == "success") {
      ProfileData requestUserData = await UserService().requestUserDataByEmail(accountController.text, passwordController.text);
      signUpedUserUID = requestUserData.uid;
      LoadingDialog().close();
      return true;
    } else if (result == "captchaCodeErr") {
      verifyErr = "驗證碼輸入錯誤";
      LoadingDialog().close();
      return false;
    } else {
      LoadingDialog().close();
      return false;
    }
  }

  bool signUpSendBeforeCheck() {
    bool isOK = true;
    pwdCheck();
    if (verifyController.text == "") {
      verifyErr = "驗證碼不得為空";
      isOK = false;
    }

    if (passwordController.text != confirmPasswordController.text) {
      confrimPwdErr = "輸入的密碼不正確";
      isOK = false;
    }

    if (!pwdleastSix || !pwdNeedEnglish || !pwdNeedNum) {
      isOK = false;
    }

    if (nameController.text == "") {
      nameErr = "名稱不得為空";
      isOK = false;
    }

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

  bool _checkEmailFormat() {
    bool isOK = true;
    RegExp emailRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (accountController.text == "") {
      emailErr = "信箱不能為空";
      isOK = false;
    } else if (!emailRegExp.hasMatch(accountController.text)) {
      emailErr = "信箱格式錯誤";
      isOK = false;
    }
    return isOK;
  }

  void resetAllData() {
    accountController.text = "";
    verifyController.text = "";
    passwordController.text = "";
    nameController.text = "";
    confirmPasswordController.text = "";
    _resetAllErrMsg();
  }

  void _resetAllErrMsg() {
    emailErr = "";
    nameErr = "";
    pwdleastSix = false;
    pwdNeedEnglish = false;
    pwdNeedNum = false;
    confrimPwdErr = "";
    verifyErr = "";
  }
}
