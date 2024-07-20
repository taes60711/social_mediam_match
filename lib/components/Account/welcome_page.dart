// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:social_mediam_match/components/strings/welcome_strings.dart';
import 'package:social_mediam_match/components/utilities/background_widget.dart';
import 'package:social_mediam_match/components/utilities/custom_button.dart';
import 'package:social_mediam_match/components/utilities/fit_widget.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import 'package:social_mediam_match/pagemanager/setting/route_controller.dart';

import '../../global.dart';

import '../../pagemanager/enum/route_path.dart';
import '../utilities/style/screen_size.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      isSafeArea: false,
      child: Column(
        children: [
          //ロゴ
          SizedBox(
            height: ScreenSize.height * 0.8,
            child: Center(
              child: SizedBox(
                width: 180,
                height: 180,
                child: Image.asset(logoImg),
              ),
            ),
          ),
          FitWidget(
            height: ScreenSize.height * 0.2,
            child: Column(
              children: [
                //登録ボタン
                _button(
                    title: WelcomeStrings().firstButtonText,
                    titleColor: normalTextColor,
                    backgroundColor: normalBgColor,
                    onPressed: () {
                      RouteOptions.pushTo(RoutePath.signUpPage);
                    }),
                const SizedBox(height: 10),
                //”ログインページ遷移”ボタン
                _button(
                    title: WelcomeStrings().loginButtonText,
                    titleColor: normalBgColor2,
                    backgroundColor: disAbleColor,
                    onPressed: () {
                      RouteOptions.pushTo(RoutePath.loginPage);
                    }),
                const SizedBox(height: 30),
                //バージョンテキスト
                _versionText,
              ],
            ),
          )
        ],
      ),
    );
  }
}

//バージョンテキスト
Widget _versionText = Text(
  "${WelcomeStrings().version} $appVer",
  style: const TextStyle(
    fontSize: 12,
    color: Color.fromARGB(255, 177, 176, 176),
  ),
);

///ボタン
///title: ボタン内の文字、　titleColor:　ボタン内の文字の色
///backgroundColor: ボタンの色、　onPressed: ボタンの機能関数
_button({required title, required titleColor, required backgroundColor, required onPressed}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: TextBtn(
      title: title,
      titleColor: titleColor,
      btnColor: backgroundColor,
      onPress: onPressed,
    ),
  );
}
