// ignore_for_file: avoid_print
import 'package:flutter/material.dart';

import '../../../components/strings/account/sign_up_strings.dart';

class SignUpViewProvider extends ChangeNotifier {
  //サインアップのインプット
  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();

  //サインアップステップインデックス
  int pageIndex = 0;

  void onChangeSignUpPage(int toPageIndex) {
    pageIndex = toPageIndex;
    notifyListeners();
  }

  //サインアップのエラーメッセージ
  String signError = SignUpError().noError;
}
