import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/components/Account/pwd_forgot_page.dart';
import 'package:social_mediam_match/components/utilities/common_scaffold.dart';
import 'package:social_mediam_match/components/utilities/inputField/base_input.dart';
import 'package:social_mediam_match/components/utilities/inputField/label_input.dart';
import 'package:social_mediam_match/components/utilities/main_button.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';

import 'package:social_mediam_match/provider/account/LoginPage/login_view_model.dart';
import 'package:social_mediam_match/services/firebase_service.dart';

import 'account_main_page.dart';
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
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: ScreenSize.fitPxWidth(40),
                height: ScreenSize.fitPxWidth(40),
                color: Colors.transparent,
                child: MainBtn(
                    onPress: () {
                      ref.read(pageControllerProvider).animateToPage(
                            1,
                            duration: const Duration(milliseconds: 150),
                            curve: Curves.easeIn,
                          );
                    },
                    child: Icon(
                      FontAwesomeIcons.arrowLeft,
                      color: AppColors.whiteColor,
                    )),
              ),
            ),
            SizedBox(height: ScreenSize.fitPxWidth(20)),

            ///　Logo
            AccountPageUtilites().logo(),

            SizedBox(height: ScreenSize.fitPxWidth(20)),

            ///　帳號輸入
            accountBuild(),
            SizedBox(height: ScreenSize.fitPxWidth(16)),

            ///　密碼輸入
            pwdBuild(),
            SizedBox(height: ScreenSize.fitPxWidth(16)),

            ///　忘記密碼
            Align(
              alignment: Alignment.centerRight,
              child: pwdForgotBuild(),
            ),

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
              imgIcon: 'assets/google_w_Logo.png',
              btnBgColor: AppColors.blueColor,
              onPress: () {
                FirebaseSerivce().signInWithGoogle();
              },
              btnText: "登入",
            ),
          ],
        ),
      ),
    ));
  }

  Widget pwdForgotBuild() {
    return MainBtn(
      backgroundColor: Colors.transparent,
      onPress: () {
        PwdForgotPage().show(context);
      },
      title: "忘記密碼?",
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
        LabelInput(
          controller: viewModel.pwdController,
          label: "密碼",
          type: InputType.pwd,
          onChanged: (value) {
            viewModel.pwdCheck();
          },
        ),
        SizedBox(height: ScreenSize.fitPxWidth(8)),
        Row(
          children: [
            textCheckBuild(condition: viewModel.pwdleastSix, text: "六碼以上"),
            SizedBox(width: ScreenSize.fitPxWidth(5)),
            textCheckBuild(condition: viewModel.pwdNeedEnglish, text: "含有英文"),
            SizedBox(width: ScreenSize.fitPxWidth(5)),
            textCheckBuild(condition: viewModel.pwdNeedNum, text: "含有數字"),
          ],
        ),
      ],
    );
  }

  Widget textCheckBuild({required bool condition, required text}) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(10), vertical: ScreenSize.fitPxWidth(2)),
          decoration: BoxDecoration(
            color: condition ? AppColors.purpleColor : AppColors.greyColor57,
            borderRadius: BorderRadius.circular(
              ScreenSize.fitPxWidth(15),
            ),
          ),
          child: Row(
            children: [
              condition
                  ? Icon(
                      Icons.check,
                      color: AppColors.greenColor,
                      size: ScreenSize.fontSize14,
                    )
                  : Icon(
                      Icons.close,
                      color: AppColors.redColor,
                      size: ScreenSize.fontSize14,
                    ),
              SizedBox(width: ScreenSize.fitPxWidth(2)),
              Text(
                text,
                style: TextStyle(color: AppColors.whiteColor),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
