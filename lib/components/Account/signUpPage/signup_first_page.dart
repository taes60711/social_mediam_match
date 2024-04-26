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
  const SignUpFirstPage({super.key, required this.emailController, required this.signErrorMessage, required this.userFuture});

  //ホームのボタン
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              introduction,
              style: TextStyle(color: hintTextColor, fontSize: 14),
            ),
          ),
        ),
        TitleInput(
          title: emailInputTitle,
          inputHeight: 36,
          textController: emailController,
        ),
        signErrorMessage,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Text(
                  '註冊即代表同意 ',
                  style: TextStyle(color: hintTextColor, fontSize: 14),
                ),
                GestureDetector(
                  onTap: () {
                    print("使用者條款");
                  },
                  child: Text(
                    '使用者條款',
                    style: TextStyle(color: normalBgColor, fontSize: 14),
                  ),
                ),
                Text(' 與 ', style: TextStyle(color: hintTextColor, fontSize: 14)),
                GestureDetector(
                  onTap: () {
                    print("使用者條款");
                  },
                  child: Text(
                    '隱私權政策',
                    style: TextStyle(color: normalBgColor, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
        _button(
            title: "信箱登入",
            titleColor: normalTextColor,
            backgroundColor: normalBgColor,
            onPressed: () {
              bool isEmail = userFuture.signUpEmailCheck(emailController.text);
              if (isEmail) {
                userFuture.onChangePage(1);
                userFuture.signUpErrorReset();
              }
            }),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          width: ScreenSize().width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 10),
                  child: Container(
                    width: 20,
                    height: 1,
                    color: Colors.black45,
                  ),
                ),
              ),
              const Text("或"),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 20),
                  child: Container(
                    width: 20,
                    height: 1,
                    color: Colors.black45,
                  ),
                ),
              ),
            ],
          ),
        ),
        _button(
            title: "Google 登入",
            titleColor: normalTextColor,
            backgroundColor: Color.fromARGB(255, 93, 161, 238),
            iconImg: 'assets/google_w_Logo.png',
            onPressed: () {
              log("Google 登入");
            }),
        const SizedBox(height: 10),
        _button(
            title: "Twitter 登入",
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
