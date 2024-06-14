import 'package:social_mediam_match/components/strings/account/login_strings.dart';
import 'package:social_mediam_match/components/utilities/background_widget.dart';
import 'package:social_mediam_match/components/utilities/basic_top_bar.dart';
import 'package:social_mediam_match/components/utilities/custom_button.dart';
import 'package:social_mediam_match/components/utilities/fit_widget.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/title_input.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/provider/account/LoginPage/login_provider.dart';
import 'package:social_mediam_match/provider/account/LoginPage/login_view_model.dart';
import 'package:social_mediam_match/route_options.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = context.read<LoginProvider>().emailController;
    TextEditingController pwdController = context.read<LoginProvider>().pwdController;

    emailController.text = "taes60811@gmail.com";
    pwdController.text = "toto60811";

    return BackgroundWidget(
      child: Column(
        children: [
          // backButton,
          BaseTopBar(backFunc: () => RouteOptions.pagePushToHome()),
          //ロゴ
          logo,
          Column(
            children: [
              FitWidget(
                height: ScreenSize.safeHeight * 0.6,
                alignment: Alignment.center,
                child: Column(
                  children: [
                    //メールアドレスInput
                    TitleInput(title: Login().emailInputTitle, textController: emailController),
                    //パスワードInput
                    TitleInput(title: Login().pwdInputTitle, textController: pwdController),
                    //エラーメッセージ
                    errorMessage(),
                    //パスワード忘れるテキスト
                    forgotPwdText,
                    //ログインボタン
                    _button(
                      title: Login().emailLoginButtonText,
                      titleColor: normalTextColor,
                      backgroundColor: normalBgColor,
                      onPressed: () async => await LoginViewModel().loginStart(context),
                    ),
                    const SizedBox(height: 10),

                    //グーグル登録ボタン
                    _button(
                        title: Login().googleButtonText,
                        titleColor: normalTextColor,
                        backgroundColor: googleButtonColor,
                        iconImg: googleIcon,
                        onPressed: () {
                          print("Google 登入");
                        }),
                    const SizedBox(height: 10),
                    //ツイッター登録ボタン
                    _button(
                        title: Login().twitterButtonText,
                        titleColor: normalTextColor,
                        backgroundColor: twitterButtonColor,
                        iconImg: twitterIcon,
                        onPressed: () {
                          print("Twitter 登入");
                        }),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

///ボタン
///title: ボタン内文字、　titleColor:　ボタン内文字の色
///backgroundColor: ボタンの色、　onPressed: ボタンの機能関数
_button({required title, required titleColor, required backgroundColor, required onPressed, String? iconImg}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: CustomButton(
      title: title,
      titleColor: titleColor,
      iconImg: iconImg,
      backgroundColor: backgroundColor,
      onPress: onPressed,
    ),
  );
}

///ロゴ
Widget logo = SizedBox(
  height: ScreenSize.safeHeight * 0.4,
  child: Image.asset(
    logoImg,
    width: 150,
    height: 150,
  ),
);

///ログインのエラーメッセージ
Widget errorMessage() {
  return Builder(builder: (context) {
    String sLoginError = context.select((LoginProvider value) => value.loginError);
    Widget wErrText = Container();
    if (sLoginError != LoginError().noError) {
      wErrText = SizedBox(
        width: ScreenSize.width,
        child: Align(
          alignment: Alignment.topLeft,
          child: Text(
            sLoginError,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }
    return wErrText;
  });
}

///パスワード忘れるテキスト
Widget forgotPwdText = Padding(
  padding: const EdgeInsets.symmetric(vertical: 10),
  child: SizedBox(
    width: ScreenSize.width,
    child: Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () => LoginViewModel().openPwdResetWindow(),
        child: Text(
          Login().forgotPassword,
          style: TextStyle(color: googleButtonColor),
        ),
      ),
    ),
  ),
);
