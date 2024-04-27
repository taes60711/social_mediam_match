// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:social_mediam_match/components/utilities/background_widget.dart';
import 'package:social_mediam_match/components/utilities/custom_button.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import '../../global.dart';
import '../utilities/style/screen_size.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    //バージョンテキスト
    Widget _versionText = const Text(
      "ver 1.0.0",
      style: TextStyle(
        fontSize: 12,
        color: Color.fromARGB(255, 177, 176, 176),
      ),
    );

    //ボタン
    //param:
    //title: ボタン内の文字、　titleColor:　ボタン内の文字の色
    //backgroundColor: ボタンの色、　onPressed: ボタンの機能関数
    _button({required title, required titleColor, required backgroundColor, required onPressed}) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: CustomButton(
          title: title,
          titleColor: titleColor,
          backgroundColor: backgroundColor,
          onPress: onPressed,
        ),
      );
    }

    return BackgroundWidget(
      isSafeArea: false,
      child: Column(
        children: [
          //ロゴ
          Container(
            height: ScreenSize().height * 0.83,
            child: Center(
              child: SizedBox(
                width: 180,
                height: 180,
                child: Image.asset(logoImg),
              ),
            ),
          ),
          Container(
            height: ScreenSize().height * 0.17,
            child: FittedBox(
              child: Column(
                children: [
                  //登録ボタン
                  _button(
                      title: "第一次使用",
                      titleColor: normalTextColor,
                      backgroundColor: normalBgColor,
                      onPressed: () {
                        Navigator.of(context).pushNamed(RoutePath.signUpPage.value);
                      }),
                  const SizedBox(height: 10),
                  //”ログインページ遷移”ボタン
                  _button(
                      title: "登入",
                      titleColor: normalBgColor2,
                      backgroundColor: disAbleColor,
                      onPressed: () {
                        Navigator.of(context).pushNamed(RoutePath.loginPage.value);
                      }),
                  const SizedBox(height: 30),
                  //バージョンテキスト
                  _versionText,
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
