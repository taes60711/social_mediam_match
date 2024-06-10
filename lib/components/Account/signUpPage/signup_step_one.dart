import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/account/signUpPage/sign_up_view_model.dart';
import '../../../provider/account/signUpPage/sign_up_view_provider.dart';
import '../../strings/account/sign_up_strings.dart';
import '../../utilities/custom_button.dart';
import '../../utilities/style/screen_size.dart';
import '../../utilities/style/style_config.dart';
import '../../utilities/title_input.dart';

class SignUpStepOne extends StatelessWidget {
  const SignUpStepOne({super.key});

  @override
  Widget build(BuildContext context) {
    SignUpViewProvider signUpViewProvider = context.read<SignUpViewProvider>();

    String googleIconPath = 'assets/google_w_Logo.png';
    Color googleButtonColor = const Color.fromARGB(255, 93, 161, 238);

    String twitterIconPath = 'assets/twitter_w_Logo.png';
    Color twitterButtonColor = const Color.fromARGB(255, 41, 41, 41);

//紹介文章
    final Widget introductionWidget = SizedBox(
      width: ScreenSize.width,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          FirstPage().introduction,
          style: TextStyle(color: hintTextColor, fontSize: 14),
        ),
      ),
    );

    //プライバシー
    final Widget privacy = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
      child: SizedBox(
        width: ScreenSize.width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              FirstPage().hintText,
              style: TextStyle(color: hintTextColor, fontSize: 14),
            ),
            GestureDetector(
              onTap: () {
                print("使用者條款");
              },
              child: Text(
                FirstPage().termText,
                style: TextStyle(color: normalBgColor, fontSize: 14),
              ),
            ),
            Text(
              FirstPage().andText,
              style: TextStyle(color: hintTextColor, fontSize: 14),
            ),
            GestureDetector(
              onTap: () {
                print("隱私權政策");
              },
              child: Text(
                FirstPage().privacyText,
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
        width: ScreenSize.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            line(padding: const EdgeInsets.only(left: 20, right: 10)),
            Text(FirstPage().orText),
            line(padding: const EdgeInsets.only(left: 10, right: 20)),
          ],
        ),
      );
    }

    ///ボタン
    ///title: ボタン内の文字、　titleColor:　ボタン内の文字の色
    ///backgroundColor: ボタンの色、　onPressed: ボタンの機能関数
    button({required title, required titleColor, required backgroundColor, required onPressed, String? iconImg}) {
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        introductionWidget,
        privacy,
        TitleInput(
          title: FirstPage().emailInputTitle,
          textController: signUpViewProvider.emailController,
        ),
        Builder(
          builder: (context) {
            String signError = context.select((SignUpViewProvider value) => value.signError);
            return Text(signError, style: const TextStyle(color: Colors.red));
          },
        ),
        button(
          title: FirstPage().emailButtonText,
          titleColor: normalTextColor,
          backgroundColor: normalBgColor,
          onPressed: () {
            print("SignUpViewProvider Btn");
            SignUpViewModel(context: context).emailCheck();
          },
        ),
        orText(),
        button(
            title: FirstPage().googleButtonText,
            titleColor: normalTextColor,
            backgroundColor: googleButtonColor,
            iconImg: googleIconPath,
            onPressed: () {
              print("Google 登入");
            }),
        const SizedBox(height: 10),
        //ツイッター登録ボタン
        button(
            title: FirstPage().twitterButtonText,
            titleColor: normalTextColor,
            backgroundColor: twitterButtonColor,
            iconImg: twitterIconPath,
            onPressed: () {
              print("Twitter 登入");
            }),
      ],
    );
  }
}
