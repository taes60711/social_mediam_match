import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/user_service.dart';

class SignUpViewModel {
  BuildContext? context;
  WidgetRef? ref;

  SignUpViewModel({this.ref, this.context});
  TextEditingController accountController = TextEditingController();
  TextEditingController verifyController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  String emailErr = "";
  String nameErr = "";

  String verifyErr = "";

  String pwdleastSixErr = "";
  String pwdNeedEnglishErr = "";
  String pwdNeedNumErr = "";

  /// 送驗證碼
  Future<bool> sendCaptchaMail() async {
    String result = "";
    _resetAllErrMsg();

    if (_checkEmailFormat()) {
      result = await UserService().sendCaptchaMail(email: accountController.text);
    }

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
    if (signUpSendBeforeCheck()) {
      result = await UserService().signUp(
        captchaCode: verifyController.text,
        email: accountController.text,
        password: passwordController.text,
        name: nameController.text,
      );
    }

    if (result == "success") {
      return true;
    } else if (result == "captchaCodeErr") {
      verifyErr = "驗證碼輸入錯誤";
      return false;
    } else {
      return false;
    }
  }

  bool signUpSendBeforeCheck() {
    bool isOK = true;
    if (verifyController.text == "") {
      verifyErr = "驗證碼不得為空";
      isOK = false;
    }
    if (passwordController.text.length < 6) {
      pwdleastSixErr = "密碼未達６碼";
      isOK = false;
    }
    if (!RegExp(r'[a-zA-Z]').hasMatch(passwordController.text)) {
      pwdNeedEnglishErr = "密碼必須含有任一英文字母";
      isOK = false;
    }
    if (!RegExp(r'[0-9]').hasMatch(passwordController.text)) {
      pwdNeedNumErr = "密碼必須含有任一數字";
      isOK = false;
    }
    if (nameController.text == "") {
      nameErr = "名稱不得為空";
      isOK = false;
    }

    return isOK;
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
    _resetAllErrMsg();
  }

  void _resetAllErrMsg() {
    emailErr = "";
    nameErr = "";
    pwdleastSixErr = "";
    pwdNeedEnglishErr = "";
    pwdNeedNumErr = "";
    verifyErr = "";
  }
}
