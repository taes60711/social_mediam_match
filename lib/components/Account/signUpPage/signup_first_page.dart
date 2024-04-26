// ignore_for_file: unused_element

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:social_mediam_match/components/utilities/Icon_with_input.dart';
import 'package:social_mediam_match/components/utilities/custom_button.dart';
import '../../../states/user_state.dart';
import '../../strings/account/sign_up_strings.dart';
import '../../utilities/style/screen_size.dart';
import '../../utilities/style/style_config.dart';

class SignUpFirstPage extends StatelessWidget {
  final TextEditingController emailController;
  final Widget signErrorMessage;
  final UserState userFuture;
  SignUpFirstPage({
    super.key,
    required this.emailController,
    required this.signErrorMessage,
    required this.userFuture,
  });

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

  //紹介文章
  final Widget introductionWidget = Padding(
    padding: const EdgeInsets.only(left: 8.0),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        introduction,
        style: TextStyle(color: hintTextColor, fontSize: 14),
      ),
    ),
  );

  //プライバシー
  final Widget privacy = Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Text(
            hintText,
            style: TextStyle(color: hintTextColor, fontSize: 14),
          ),
          GestureDetector(
            onTap: () {
              print("使用者條款");
            },
            child: Text(
              termText,
              style: TextStyle(color: normalBgColor, fontSize: 14),
            ),
          ),
          Text(
            andText,
            style: TextStyle(color: hintTextColor, fontSize: 14),
          ),
          GestureDetector(
            onTap: () {
              print("隱私權政策");
            },
            child: Text(
              privacyText,
              style: TextStyle(color: normalBgColor, fontSize: 14),
            ),
          ),
        ],
      ),
    ),
  );

  //or テキスト
  orText() {
    line({required EdgeInsetsGeometry padding}) {
      return Expanded(
        child: Padding(
          padding: padding,
          child: Container(
            height: 1,
            color: Colors.black45,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      width: ScreenSize().width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          line(padding: const EdgeInsets.only(left: 20, right: 10)),
          const Text("或"),
          line(padding: const EdgeInsets.only(left: 10, right: 20)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //タイトル
        Text(title),
        const SizedBox(height: 10),
        //紹介文章
        introductionWidget,
        //メールアドレスインプット
        TitleInput(
          title: emailInputTitle,
          inputHeight: 36,
          textController: emailController,
        ),
        //エラーメッセージ
        signErrorMessage,
        //プライバシー
        privacy,
        //メールアドレス登録ボタン
        _button(
            title: emailButtonText,
            titleColor: normalTextColor,
            backgroundColor: normalBgColor,
            onPressed: () {
              bool isEmail = userFuture.signUpEmailCheck(emailController.text);
              if (isEmail) {
                userFuture.onChangePage(1);
                userFuture.signUpErrorReset();
              }
            }),
        //or テキスト
        orText(),
        //グーグル登録ボタン
        _button(
            title: googleButtonText,
            titleColor: normalTextColor,
            backgroundColor: Color.fromARGB(255, 93, 161, 238),
            iconImg: 'assets/google_w_Logo.png',
            onPressed: () {
              log("Google 登入");
            }),
        const SizedBox(height: 10),
        //ツイッター登録ボタン
        _button(
            title: twitterButtonText,
            titleColor: normalTextColor,
            backgroundColor: Color.fromARGB(255, 41, 41, 41),
            iconImg: 'assets/twitter_w_Logo.png',
            onPressed: () {
              log("Twitter 登入");
            }),
      ],
    );
  }
}
