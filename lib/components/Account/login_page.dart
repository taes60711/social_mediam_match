import 'dart:developer';
import 'package:social_mediam_match/components/utilities/background_widget.dart';
import 'package:social_mediam_match/components/utilities/custom_button.dart';
import 'package:social_mediam_match/components/utilities/loading.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import 'package:social_mediam_match/global.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/Icon_with_input.dart';
import 'package:social_mediam_match/components/strings/message_strings/account_message.dart';
import 'package:social_mediam_match/states/user_state.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController pwdController = TextEditingController();
    UserState userFuture = context.read<UserState>();
    String loginError = context.select((UserState value) => value.loginError);
    emailController.text = "taes60811@gmail.com";
    pwdController.text = "toto60811";

    bool isLoading = context.select((UserState value) => value.isLoading);
    void closeResetPwdWindow() {
      userFuture.resetPwdError = ResetPwdStatus.NoMessage.value;
      Navigator.pop(context);
    }

    openBottomSheet() {
      showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (context) {
            String resetPwdError = context.select((UserState value) => value.resetPwdError);
            return SizedBox(
              height: ScreenSize().height * .55,
              child: Stack(
                children: [
                  Positioned(
                    top: 30,
                    bottom: 0,
                    child: Container(
                      width: ScreenSize().width,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("請輸入註冊時的郵箱地址:"),
                            IconWithInput(
                              icon: Icons.email,
                              inputController: emailController,
                              hintText: 'Email',
                            ),
                            Text(
                              resetPwdError,
                              style: const TextStyle(color: Colors.red),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                onPressed: () => userFuture.reSetPwd(emailController.text),
                                child: const Text("發送"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                      right: 25,
                      child: GestureDetector(
                        onTap: () => closeResetPwdWindow(),
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 88, 127, 226),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: const Icon(
                            Icons.arrow_downward,
                            color: Colors.white,
                          ),
                        ),
                      ))
                ],
              ),
            );
          });
    }

    void returnHome() {
      resetAllInfo() {
        userFuture.loginError = LoginStatus.NoMessage.value;
      }

      Navigator.of(context).popUntil(ModalRoute.withName(RoutePath.home.value));
      resetAllInfo();
    }

    Widget loginErrorMessage;
    if (loginError != LoginStatus.NoMessage.value) {
      loginErrorMessage = Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            loginError,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    } else {
      loginErrorMessage = Container();
    }

    //ボタン
    //param:
    //title: ボタン内の文字、　titleColor:　ボタン内の文字の色
    //backgroundColor: ボタンの色、　onPressed: ボタンの機能関数
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

    String googleIconPath = 'assets/google_w_Logo.png';
    Color googleButtonColor = const Color.fromARGB(255, 93, 161, 238);

    String twitterIconPath = 'assets/twitter_w_Logo.png';
    Color twitterButtonColor = const Color.fromARGB(255, 41, 41, 41);

    Widget userComponent;
    if (isLoading) {
      userComponent = const Loading();
    } else {
      userComponent = BackgroundWidget(
        child: Column(
          children: [
            SizedBox(
              height: ScreenSize().safeheight * 0.4,
              child: SizedBox(
                width: 150,
                height: 150,
                child: Image.asset('assets/Logo.png'),
              ),
            ),
            SizedBox(
              height: ScreenSize().safeheight * 0.6,
              child: FittedBox(
                child: Column(
                  children: [
                    TitleInput(title: "信箱", textController: emailController),
                    TitleInput(title: "密碼", textController: pwdController),
                    loginErrorMessage,
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: SizedBox(
                        width: ScreenSize().width,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              openBottomSheet();
                            },
                            child: const Text(
                              "忘記密碼?",
                              style: TextStyle(color: Colors.blueAccent),
                            ),
                          ),
                        ),
                      ),
                    ),

                    //ログインボタン
                    _button(
                        title: "登入",
                        titleColor: normalTextColor,
                        backgroundColor: normalBgColor,
                        onPressed: () async {
                          bool isLoginSucess = await userFuture.signIn(emailController.text, pwdController.text);
                          isLoginSucess ? returnHome() : () {};
                        }),
                    const SizedBox(height: 10),
                    //登録ボタン
                    _button(
                        title: "註冊帳號",
                        titleColor: normalTextColor,
                        backgroundColor: Color.fromARGB(255, 177, 179, 177),
                        onPressed: () async {
                          Navigator.of(context).pushNamed(RoutePath.signUpPage.value);
                        }),
                    const SizedBox(height: 10),
                    //グーグル登録ボタン
                    _button(
                        title: "Google登入",
                        titleColor: normalTextColor,
                        backgroundColor: googleButtonColor,
                        iconImg: googleIconPath,
                        onPressed: () {
                          log("Google 登入");
                        }),
                    const SizedBox(height: 10),
                    //ツイッター登録ボタン
                    _button(
                        title: "Twitter 登入",
                        titleColor: normalTextColor,
                        backgroundColor: twitterButtonColor,
                        iconImg: twitterIconPath,
                        onPressed: () {
                          log("Twitter 登入");
                        }),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(child: userComponent),
    );
  }
}
