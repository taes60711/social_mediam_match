import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:social_mediam_match/components/account/pwd_forgot_page.dart';
import 'package:social_mediam_match/components/utilities/common_scaffold.dart';
import 'package:social_mediam_match/components/utilities/inputField/base_input.dart';
import 'package:social_mediam_match/components/utilities/inputField/label_input.dart';
import 'package:social_mediam_match/components/utilities/main_button.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/style/app_colors.dart';
import 'package:social_mediam_match/provider/account/LoginPage/login_view_model.dart';
import '../utilities/style/app_image.dart';
import 'account_page_utilites.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  late LoginViewModel viewModel = LoginViewModel();

  @override
  void initState() {
    viewModel = LoginViewModel(ref: ref, context: context, render: () => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(16)),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: ScreenSize.fitPxWidth(40)),

            ///　Logo
            AccountPageUtilites().logo(),

            SizedBox(height: ScreenSize.fitPxWidth(20)),

            ///　帳號輸入
            accountBuild(),
            SizedBox(height: ScreenSize.fitPxWidth(16)),

            ///　密碼輸入
            pwdBuild(),
            SizedBox(height: ScreenSize.fitPxWidth(16)),

            ///　錯誤資訊
            errMsgBuild(),
            SizedBox(height: ScreenSize.fitPxWidth(16)),

            ///　一般登入
            AccountPageUtilites().btnContainer(
              onPress: () {
                viewModel.login();
              },
              btnText: "登入",
            ),
            SizedBox(height: ScreenSize.fitPxWidth(16)),

            ///　Google登入
            AccountPageUtilites().btnContainer(
              imgIcon: AppImage.googleIcon,
              onPress: () {
                viewModel.googleLogin();
              },
              btnBgColor: AppColors.whiteColor,
              btnTextColor: AppColors.greyColor98,
              btnText: "Google登入",
            ),
            SizedBox(height: ScreenSize.fitPxWidth(16)),

            ///　Apple登入
            AccountPageUtilites().btnContainer(
              imgIcon: AppImage.appleIcon,
              onPress: () {},
              btnBgColor: AppColors.whiteColor,
              btnTextColor: AppColors.greyColor98,
              btnText: "Apple登入",
            ),

            SizedBox(height: ScreenSize.fitPxWidth(120)),
          ],
        ),
      ),
    ));
  }

  Widget pwdForgotBuild() {
    return MainBtn(
      backgroundColor: AppColors.transparent,
      onPress: () {
        PwdForgotPage().show(context);
      },
      title: "忘記密碼?",
      titleStyle: TextStyle(
        color: AppColors.whiteColor,
        fontSize: ScreenSize.fontSize14,
      ),
    );
  }

  Widget errMsgBuild() {
    return viewModel.errMsg == ""
        ? Container()
        : Align(
            alignment: Alignment.centerLeft,
            child: Text(
              viewModel.errMsg,
              style: TextStyle(color: AppColors.redColor),
            ),
          );
  }

  Widget accountBuild() {
    return LabelInput(
      controller: viewModel.accountController,
      label: "Email",
    );
  }

  Widget pwdBuild() {
    return Column(
      children: [
        SizedBox(
          height: ScreenSize.fitPxWidth(80),
          child: Row(
            children: [
              Expanded(
                child: LabelInput(
                  controller: viewModel.pwdController,
                  label: "密碼",
                  type: InputType.pwd,
                  onChanged: (value) {
                    viewModel.pwdCheck();
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: ScreenSize.fitPxWidth(20)),
                child: pwdForgotBuild(),
              ),
            ],
          ),
        ),
        SizedBox(height: ScreenSize.fitPxWidth(8)),
        Row(
          children: [
            AccountPageUtilites().textCheckBuild(condition: viewModel.pwdleastSix, text: "六碼以上"),
            SizedBox(width: ScreenSize.fitPxWidth(5)),
            AccountPageUtilites().textCheckBuild(condition: viewModel.pwdNeedEnglish, text: "英文"),
            SizedBox(width: ScreenSize.fitPxWidth(5)),
            AccountPageUtilites().textCheckBuild(condition: viewModel.pwdNeedNum, text: "數字"),
          ],
        ),
      ],
    );
  }
}
