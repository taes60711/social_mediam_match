import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:social_mediam_match/components/utilities/appBar/basic_top_bar.dart';
import 'package:social_mediam_match/components/utilities/endDrawers/base_end_drawer.dart';
import 'package:social_mediam_match/components/utilities/main_button.dart';

import '../utilities/inputField/label_input.dart';
import '../utilities/style/screen_size.dart';
import 'account_page_utilites.dart';

class PwdForgotPage extends BaseEndDrawer {
  @override
  Widget build(WidgetRef ref) {
    return Column(
      children: [
        BaseTopBar(
          backFunc: () => closePage(),
          title: "忘記密碼",
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(16)),
          child: Column(
            children: [
              SizedBox(height: ScreenSize.fitPxWidth(16)),
              mailBuild(),
              SizedBox(height: ScreenSize.fitPxWidth(16)),
              verifyBuild(),
              SizedBox(height: ScreenSize.fitPxWidth(16)),
              pwdBuild(),
              SizedBox(height: ScreenSize.fitPxWidth(16)),
              newPwdBuild(),
              SizedBox(height: ScreenSize.fitPxWidth(25)),
              AccountPageUtilites().btnContainer(
                onPress: () {},
                btnText: "送出",
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget mailBuild() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: LabelInput(
            controller: TextEditingController(),
            label: "Email",
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: ScreenSize.fitPxWidth(16), bottom: ScreenSize.fitPxWidth(6)),
          child: MainBtn(
            onPress: () {},
            title: "寄送驗證碼",
          ),
        )
      ],
    );
  }

  Widget verifyBuild() {
    return LabelInput(
      controller: TextEditingController(),
      label: "驗證碼",
    );
  }

  Widget pwdBuild() {
    return LabelInput(
      controller: TextEditingController(),
      label: "密碼",
    );
  }

  Widget newPwdBuild() {
    return LabelInput(
      controller: TextEditingController(),
      label: "新密碼",
    );
  }
}
