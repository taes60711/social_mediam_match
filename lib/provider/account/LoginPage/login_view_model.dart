import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/global.dart';
import 'package:social_mediam_match/provider/account/LoginPage/login_provider.dart';
import 'package:social_mediam_match/route_options.dart';

import '../../../components/strings/account/login_strings.dart';
import '../../../components/utilities/custom_button.dart';
import '../../../components/utilities/style/screen_size.dart';
import '../../../components/utilities/style/style_config.dart';
import '../../../components/utilities/title_input.dart';

class LoginViewModel {
  /// パスワードわすれるウインドウズ
  void openPwdResetWindow() {
    showModalBottomSheet(
        context: globalContext,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return DraggableScrollableSheet(
              expand: false,
              minChildSize: 0.65,
              initialChildSize: 0.75,
              maxChildSize: 0.75,
              builder: (context, scrollController) {
                return ChangeNotifierProvider(
                  create: (_) => LoginProvider(),
                  child: Builder(builder: (context) {
                    TextEditingController emailController = TextEditingController();
                    String resetPwdError = context.select((LoginProvider value) => value.resetPwdError);
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
                                  TitleInput(title: PasswordForgot().emailInputTitle, textController: emailController),
                                  Text(
                                    resetPwdError,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                  CustomButton(
                                    title: PasswordForgot().sendButtonText,
                                    titleColor: normalTextColor,
                                    backgroundColor: normalBgColor,
                                    onPress: () => context.read<LoginProvider>().reSetPwd(emailController.text),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            right: 25,
                            child: GestureDetector(
                              onTap: () => RouteOptions.pagePop(),
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
                  }),
                );
              });
        });
  }

  /// ログインステップ開始
  Future<void> loginStart(BuildContext context) async {
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

    String inputedEmail = context.read<LoginProvider>().emailController.text;
    String intputedPwd = context.read<LoginProvider>().pwdController.text;

    loadingPopView();
    bool isLoginSucess = await context.read<LoginProvider>().signIn(inputedEmail, intputedPwd);
    RouteOptions.pagePop();
    isLoginSucess ? RouteOptions.pagePushToHome() : () {};
  }
}
