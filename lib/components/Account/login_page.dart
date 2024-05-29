import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:social_mediam_match/components/strings/account/login_strings.dart';
import 'package:social_mediam_match/components/utilities/background_widget.dart';
import 'package:social_mediam_match/components/utilities/custom_button.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import 'package:social_mediam_match/global.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/title_input.dart';
import 'package:social_mediam_match/components/strings/message_strings/account_message.dart';
import 'package:social_mediam_match/states/user_state.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController pwdController = TextEditingController();
    UserState userFuture = context.read<UserState>();
    String loginError = context.select((UserState value) => value.loginError);
    emailController.text = "taes60811@gmail.com";
    pwdController.text = "toto60811";

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
                            TitleInput(title: PasswordForgot().emailInputTitle, textController: emailController),
                            Text(
                              resetPwdError,
                              style: const TextStyle(color: Colors.red),
                            ),
                            CustomButton(
                              title: PasswordForgot().sendButtonText,
                              titleColor: normalTextColor,
                              backgroundColor: normalBgColor,
                              onPress: () => userFuture.reSetPwd(emailController.text),
                            )
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
              ),
            );
          });
    }

    void returnHome() {
      resetAllInfo() {
        userFuture.loginError = LoginError().noError;
      }

      Navigator.of(context).popUntil(ModalRoute.withName(RoutePath.home.value));
      resetAllInfo();
    }

    Widget loginErrorMessage;
    if (loginError != LoginError().noError) {
      loginErrorMessage = SizedBox(
        width: ScreenSize().width,
        child: Align(
          alignment: Alignment.topLeft,
          child: Text(
            loginError,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    } else {
      loginErrorMessage = Container();
    }

    Future<void> loadingPopView() {
      return showDialog<void>(
        barrierDismissible: false,
        barrierColor: barrierColor,
        context: context,
        builder: (BuildContext context) {
          return LoadingAnimationWidget.inkDrop(color: normalBgColor, size: 35);
        },
      );
    }

    void closePop() {
      if (!ModalRoute.of(context)!.isCurrent) {
        Navigator.of(context).pop();
      }
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

    //ロゴ
    Widget logo = SizedBox(
      height: ScreenSize().safeheight * 0.3,
      child: SizedBox(
        width: 150,
        height: 150,
        child: Image.asset('assets/Logo.png'),
      ),
    );

    //パスワード忘れるテキスト
    Widget forgotPwdText = Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        width: ScreenSize().width,
        child: Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {
              openBottomSheet();
            },
            child: Text(
              Login().forgotPassword,
              style: TextStyle(color: googleButtonColor),
            ),
          ),
        ),
      ),
    );

    Widget backButton = SizedBox(
      width: ScreenSize().width,
      child: Align(
        alignment: Alignment.topLeft,
        child: IconButton(
          onPressed: () {
            returnHome();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: normalBgColor2,
          ),
        ),
      ),
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BackgroundWidget(
        child: Column(
          children: [
            backButton,
            //ロゴ
            logo,
            Column(
              children: [
                SizedBox(
                  height: ScreenSize().height * 0.6,
                  child: FittedBox(
                    child: Column(
                      children: [
                        //メールアドレスInput
                        TitleInput(title: Login().emailInputTitle, textController: emailController),
                        //パスワードInput
                        TitleInput(title: Login().pwdInputTitle, textController: pwdController),
                        //エラーメッセージ
                        loginErrorMessage,
                        //パスワード忘れるテキスト
                        forgotPwdText,
                        //ログインボタン
                        _button(
                            title: Login().emailLoginButtonText,
                            titleColor: normalTextColor,
                            backgroundColor: normalBgColor,
                            onPressed: () async {
                              loadingPopView();
                              bool isLoginSucess = await userFuture.signIn(emailController.text, pwdController.text);
                              closePop();
                              isLoginSucess ? returnHome() : () {};
                            }),
                        const SizedBox(height: 10),

                        //グーグル登録ボタン
                        _button(
                            title: Login().googleButtonText,
                            titleColor: normalTextColor,
                            backgroundColor: googleButtonColor,
                            iconImg: googleIconPath,
                            onPressed: () {
                              print("Google 登入");
                            }),
                        const SizedBox(height: 10),
                        //ツイッター登録ボタン
                        _button(
                            title: Login().twitterButtonText,
                            titleColor: normalTextColor,
                            backgroundColor: twitterButtonColor,
                            iconImg: twitterIconPath,
                            onPressed: () {
                              print("Twitter 登入");
                            }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
