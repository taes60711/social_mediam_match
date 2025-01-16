import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/utilities/appBar/basic_top_bar.dart';
import 'package:social_mediam_match/components/utilities/endDrawers/base_end_drawer.dart';
import 'package:social_mediam_match/components/utilities/main_button.dart';
import '../../provider/account/LoginPage/pwd_forgot_view_model.dart';
import '../utilities/inputField/base_input.dart';
import '../utilities/inputField/label_input.dart';
import '../utilities/style/screen_size.dart';
import '../utilities/style/style_config.dart';
import 'account_page_utilites.dart';

class PwdForgotPage extends BaseEndDrawer {
  late PwdForgotViewModel viewModel = PwdForgotViewModel();

  @override
  Future<void> initState(WidgetRef ref) async {
    viewModel = PwdForgotViewModel(ref: ref, context: context, render: () => render());
  }

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
                onPress: () {
                  viewModel.sendOnpress();
                },
                btnText: "送出",
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget mailBuild() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          // crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: LabelInput(
                controller: viewModel.accountController,
                label: "Email",
                readOnly: viewModel.emailCantChange,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: ScreenSize.fitPxWidth(10), top: ScreenSize.fitPxWidth(25)),
              child: IgnorePointer(
                ignoring: viewModel.emailCantChange,
                child: MainBtn(
                  onPress: () async {
                    await viewModel.sendCaptchaMail();
                  },
                  titleStyle: viewModel.emailCantChange ? TextStyle(color: AppColors.greyColor130) : null,
                  title: viewModel.emailCantChange ? "驗證碼已寄送" : "寄送驗證碼",
                ),
              ),
            )
          ],
        ),
        Visibility(
          visible: viewModel.emailErr != "",
          child: Text(
            viewModel.emailErr,
            style: TextStyle(color: AppColors.redColor),
          ),
        )
      ],
    );
  }

  Widget verifyBuild() {
    return LabelInput(
      controller: viewModel.verifyController,
      label: "驗證碼",
      errMsg: [viewModel.verifyErr],
    );
  }

  Widget pwdBuild() {
    return Column(
      children: [
        LabelInput(
          controller: viewModel.passwordController,
          type: InputType.pwd,
          onChanged: (value) {
            viewModel.pwdCheck();
            render();
          },
          label: "新密碼",
        ),
        SizedBox(height: ScreenSize.fitPxWidth(8)),
        Row(
          children: [
            AccountPageUtilites().textCheckBuild(
              condition: viewModel.pwdleastSix,
              text: "六碼以上",
            ),
            SizedBox(width: ScreenSize.fitPxWidth(5)),
            AccountPageUtilites().textCheckBuild(
              condition: viewModel.pwdNeedEnglish,
              text: "英文",
            ),
            SizedBox(width: ScreenSize.fitPxWidth(5)),
            AccountPageUtilites().textCheckBuild(
              condition: viewModel.pwdNeedNum,
              text: "數字",
            ),
          ],
        ),
      ],
    );
  }

  Widget newPwdBuild() {
    return LabelInput(
      controller: viewModel.confirmPasswordController,
      label: "確認密碼",
      type: InputType.pwd,
      errMsg: [viewModel.confrimPwdErr],
    );
  }
}
