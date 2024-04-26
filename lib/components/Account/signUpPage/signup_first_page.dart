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
          padding: const EdgeInsets.only(left: 8.0),
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: CustomButton(
            title: "信箱登入",
            titleColor: Colors.white,
            backgroundColor: normalBgColor,
            onPress: () {
              bool isEmail = userFuture.signUpEmailCheck(emailController.text);
              if (isEmail) {
                userFuture.onChangePage(1);
                userFuture.signUpErrorReset();
              }
            },
          ),
        ),
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: CustomButton(
              title: "Google 登入",
              titleColor: Colors.white,
              iconImg: 'assets/google_w_Logo.png',
              backgroundColor: Color.fromARGB(255, 93, 161, 238),
              onPress: () {
                log("Google 登入");
              }),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: CustomButton(
              title: "Twitter 登入",
              titleColor: Colors.white,
              iconImg: 'assets/twitter_w_Logo.png',
              backgroundColor: Color.fromARGB(255, 41, 41, 41),
              onPress: () {
                log("Twitter 登入");
              }),
        ),
      ],
    );
  }
}
