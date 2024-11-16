import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/global.dart';
import 'package:social_mediam_match/provider/account/LoginPage/login_provider.dart';

import '../../../components/utilities/style/screen_size.dart';
import '../../../components/utilities/style/style_config.dart';

import '../../../pageManager/setting/route_controller.dart';

class LoginViewModel {
  BuildContext loginViewContext;
  LoginViewModel({required this.loginViewContext});

  /// パスワードわすれるウインドウズ
  void openPwdResetWindow() {
    showModalBottomSheet(
        context: globalContext,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) {
          return ChangeNotifierProvider.value(
            value: loginViewContext.read<LoginProvider>(),
            child: Builder(builder: (context) {
              TextEditingController emailController = TextEditingController();
              String resetPwdError = context.select((LoginProvider value) => value.resetPwdError);
              return DraggableScrollableSheet(
                  expand: false,
                  minChildSize: 0.65,
                  initialChildSize: 0.75,
                  maxChildSize: 0.75,
                  builder: (context, scrollController) {
                    return Stack(
                      children: [
                        Positioned(
                          top: 30,
                          bottom: 0,
                          child: Container(
                            width: ScreenSize.width,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 50),
                                  // LabelInput(title: PasswordForgot.emailInputTitle, textController: emailController),
                                  Text(
                                    resetPwdError,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                  // TextBtn(
                                  //   title: PasswordForgot.sendButtonText,
                                  //   titleColor: normalTextColor,
                                  //   btnColor: normalBgColor,
                                  //   onPress: () => context.read<LoginProvider>().reSetPwd(emailController.text),
                                  // )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            right: 25,
                            child: GestureDetector(
                              onTap: () => RouteOptions.pop(),
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: normalBgColor,
                                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                                ),
                                child: const Icon(
                                  Icons.arrow_downward,
                                  color: Colors.white,
                                ),
                              ),
                            ))
                      ],
                    );
                  });
            }),
          );
        });
  }

  /// ログインステップ開始
  Future<void> loginStart() async {
    Future<void> loadingPopView() {
      return showDialog<void>(
        barrierDismissible: false,
        barrierColor: barrierColor,
        context: globalContext,
        builder: (BuildContext context) {
          return LoadingAnimationWidget.inkDrop(color: normalBgColor, size: 35);
        },
      );
    }

    String inputedEmail = loginViewContext.read<LoginProvider>().emailController.text;
    String intputedPwd = loginViewContext.read<LoginProvider>().pwdController.text;

    loadingPopView();
    bool isLoginSucess = await loginViewContext.read<LoginProvider>().signIn(inputedEmail, intputedPwd);
    RouteOptions.pop();
    // isLoginSucess ? RouteOptions.popUntilToHome() : () {};
  }
}
