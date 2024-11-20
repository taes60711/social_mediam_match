import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/utilities/common_scaffold.dart';
import 'package:social_mediam_match/components/utilities/inputField/base_input.dart';
import 'package:social_mediam_match/components/utilities/inputField/label_input.dart';
import 'package:social_mediam_match/components/utilities/main_button.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';

import 'package:social_mediam_match/provider/account/LoginPage/login_view_model.dart';
import 'package:social_mediam_match/services/firebase_service.dart';

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
      child: Column(
        children: [
          SizedBox(height: ScreenSize.fitPxWidth(60)),
          Container(
            width: ScreenSize.fitPxWidth(180),
            height: ScreenSize.fitPxWidth(180),
            color: AppColors.orangeColor,
          ),
          SizedBox(height: ScreenSize.fitPxWidth(16)),
          accountBuild(),
          SizedBox(height: ScreenSize.fitPxWidth(16)),
          pwdBuild(),
          SizedBox(height: ScreenSize.fitPxWidth(16)),
          Align(
            alignment: Alignment.centerRight,
            child: pwdForgot(),
          ),
          errMsgBuild(),
          SizedBox(height: ScreenSize.fitPxWidth(16)),
          btnContainer(
            onPress: () {
              viewModel.login();
            },
          ),
          SizedBox(height: ScreenSize.fitPxWidth(16)),
          btnContainer(
            imgIcon: 'assets/google_w_Logo.png',
            btnBgColor: AppColors.blueColor,
            onPress: () {
              FirebaseSerivce().signInWithGoogle();
            },
          ),
        ],
      ),
    ));
  }

  Widget pwdForgot() {
    return MainBtn(
      backgroundColor: Colors.transparent,
      onPress: () {},
      title: "忘記密碼?",
    );
  }

  Widget btnContainer({required Function onPress, String? imgIcon, Color? btnBgColor}) {
    return MainBtn(
      onPress: () async {
        onPress();
      },
      child: Container(
        width: ScreenSize.width,
        padding: EdgeInsets.symmetric(vertical: ScreenSize.fitPxWidth(10)),
        decoration: BoxDecoration(
          color: btnBgColor ?? AppColors.greyColor57,
          borderRadius: BorderRadius.circular(
            ScreenSize.fitPxWidth(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            imgIcon != null
                ? Image.asset(
                    imgIcon,
                    width: ScreenSize.fontSize24,
                  )
                : Container(),
            SizedBox(width: ScreenSize.fitPxWidth(10)),
            Text(
              "登入",
              style: TextStyle(
                color: AppColors.whiteColor,
                fontSize: ScreenSize.fontSize18,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
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
