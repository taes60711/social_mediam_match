import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/user_service.dart';

class SignUpViewModel {
  BuildContext? context;
  WidgetRef? ref;
  Function? render;
  SignUpViewModel({this.ref, this.context, this.render});
  TextEditingController accountController = TextEditingController(text: "taes60511@gmail.com");
  TextEditingController verifyController = TextEditingController(text: "");
  TextEditingController passwordController = TextEditingController(text: "toto60511");
  TextEditingController nameController = TextEditingController(text: "name");

  /// 送驗證碼
  Future<bool> sendCaptchaMail() async {
    bool isSendMailSuccess = await UserService().sendCaptchaMail(email: accountController.text);
    return isSendMailSuccess;
  }

  /// 註冊
  Future<bool> signUp() async {
    bool result = await UserService().signUp(
      captchaCode: verifyController.text,
      email: accountController.text,
      password: passwordController.text,
      name: nameController.text,
    );

    return result;
  }
}
