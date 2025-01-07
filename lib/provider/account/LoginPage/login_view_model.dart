import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_mediam_match/components/utilities/toast.dart';

import '../../../global/user_login_status_controller.dart';
import '../../../services/google_sign_in_service.dart';

class LoginViewModel {
  BuildContext? context;
  WidgetRef? ref;
  Function? render;
  LoginViewModel({this.ref, this.context, this.render});

  LoginDataModel editData = LoginDataModel.emptyData();

  TextEditingController accountController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  String errMsg = "";

  bool pwdleastSix = false;
  bool pwdNeedEnglish = false;
  bool pwdNeedNum = false;

  void pwdCheck() {
    pwdleastSix = false;
    pwdNeedEnglish = false;
    pwdNeedNum = false;
    if (pwdController.text.length >= 6) {
      pwdleastSix = true;
    }
    if (RegExp(r'[a-zA-Z]').hasMatch(pwdController.text)) {
      pwdNeedEnglish = true;
    }
    if (RegExp(r'[0-9]').hasMatch(pwdController.text)) {
      pwdNeedNum = true;
    }
    render!();
  }

  void updateLoginInputData() {
    editData = LoginDataModel(
      account: accountController.text,
      pwd: pwdController.text,
    );
  }

  bool apiBerforeErrCheck() {
    if (!pwdleastSix && !pwdNeedEnglish && !pwdNeedNum) {
      return false;
    }
    errMsg = "";
    if (editData.account == "" && editData.pwd == "") {
      errMsg = "帳號和密碼不得為空";
    } else if (editData.account == "") {
      errMsg = "帳號不得為空";
    } else if (editData.pwd == "") {
      errMsg = "密碼不得為空";
    } else if (!RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(editData.account)) {
      errMsg = "信箱格式錯誤";
    }
    render!();
    return errMsg != "";
  }

  Future<void> login() async {
    updateLoginInputData();
    bool isErr = apiBerforeErrCheck();
    if (!isErr) {
      bool apiIsSuccess = await UserLoginStatusController().login(loginInputData: editData);
      if (!apiIsSuccess) {
        errMsg = "帳號或密碼錯誤";
        render!();
      }
    }
  }

  Future<void> googleLogin() async {
    GoogleSignInAccount? googleUser = await GoogleSinginService().signInWithGoogle();
    if (googleUser != null) {
      LoginDataModel loginDataModel = LoginDataModel(account: googleUser.email, pwd: googleUser.id);
      bool success = await UserLoginStatusController().login(loginInputData: loginDataModel, loginType: "googleSign");

      if (!success) {
        Toast().showCenter(msg: "請先至註冊頁面,進行Google註冊");
      }
    }
  }
}

class LoginDataModel {
  String account;
  String pwd;
  LoginDataModel({required this.account, required this.pwd});

  static LoginDataModel emptyData() {
    return LoginDataModel(account: '', pwd: '');
  }
}
