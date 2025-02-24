import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:social_mediam_match/components/utilities/appBar/basic_top_bar.dart';

import 'package:social_mediam_match/components/utilities/common_scaffold.dart';
import 'package:social_mediam_match/components/utilities/dialog/confirm_dialog.dart';
import 'package:social_mediam_match/components/utilities/endDrawers/base_end_drawer.dart';
import 'package:social_mediam_match/components/utilities/inputField/base_input.dart';
import 'package:social_mediam_match/components/utilities/main_button.dart';
import 'package:social_mediam_match/components/utilities/style/app_colors.dart';

import '../../home/userPage/setting/usage_terms_dialog.dart';
import '../../utilities/inputField/label_input.dart';
import '../../utilities/style/screen_size.dart';
import '../account_main_page.dart';
import '../account_page_utilites.dart';

import 'signup_step_last.dart';

class SignUpStepTwoPage extends BaseEndDrawer {
  bool isAgree = false;

  @override
  bool needGestureDetectorClosePage() {
    return false;
  }

  @override
  Widget build(WidgetRef ref) {
    return CommonScaffold(
        child: Column(
      children: [
        BaseTopBar(
          backFunc: () {
            ref.read(viewModelProvider.notifier).state.resetAllData();
            render();
            closePage();
          },
          title: "註冊(1/2)",
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(16)),
          child: Column(
            children: [
              idBuild(),
              SizedBox(height: ScreenSize.fitPxWidth(16)),
              pwdBuild(),
              SizedBox(height: ScreenSize.fitPxWidth(16)),
              confirmPwdBuild(),
              SizedBox(height: ScreenSize.fitPxWidth(16)),
              verifyBuild(),
              SizedBox(height: ScreenSize.fitPxWidth(25)),
              Row(
                children: [
                  Theme(
                    data: Theme.of(context).copyWith(
                      unselectedWidgetColor: AppColors.whiteColor,
                    ),
                    child: Checkbox(
                      activeColor: AppColors.transparent,
                      value: isAgree,
                      onChanged: (value) {
                        isAgree = !isAgree;
                        render();
                      },
                    ),
                  ),
                  MainBtn(
                    onPress: () {
                      UsageTermsDialog().show(context);
                    },
                    child: Row(
                      children: [
                        Text(
                          "我同意",
                          style: TextStyle(fontSize: ScreenSize.fontSize14, color: AppColors.whiteColor),
                        ),
                        Text(
                          "使用者條款",
                          style: TextStyle(
                            fontSize: ScreenSize.fontSize14,
                            decoration: TextDecoration.underline,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              AccountPageUtilites().btnContainer(
                onPress: () async {
                  if (!isAgree) {
                    ConfirmDilaog(title: "提示", content: '請勾選"我同意使用者條款"', btnAmount: 1).show(context);
                    return;
                  }
                  if (await ref.read(viewModelProvider.notifier).state.signUp()) {
                    SignUpStepLastPage().show(context);
                  }

                  render();
                },
                btnText: "下一步",
              ),
            ],
          ),
        ),
      ],
    ));
  }

  Widget verifyBuild() {
    return LabelInput(
      controller: ref.read(viewModelProvider.notifier).state.verifyController,
      label: "驗證碼",
      errMsg: [ref.read(viewModelProvider.notifier).state.verifyErr],
    );
  }

  Widget pwdBuild() {
    return Column(
      children: [
        LabelInput(
          controller: ref.read(viewModelProvider.notifier).state.passwordController,
          label: "密碼",
          type: InputType.pwd,
          onChanged: (value) {
            ref.read(viewModelProvider.notifier).state.pwdCheck();
            render();
          },
        ),
        SizedBox(height: ScreenSize.fitPxWidth(8)),
        Row(
          children: [
            AccountPageUtilites().textCheckBuild(
              condition: ref.read(viewModelProvider.notifier).state.pwdleastSix,
              text: "六碼以上",
            ),
            SizedBox(width: ScreenSize.fitPxWidth(5)),
            AccountPageUtilites().textCheckBuild(
              condition: ref.read(viewModelProvider.notifier).state.pwdNeedEnglish,
              text: "含有英文",
            ),
            SizedBox(width: ScreenSize.fitPxWidth(5)),
            AccountPageUtilites().textCheckBuild(
              condition: ref.read(viewModelProvider.notifier).state.pwdNeedNum,
              text: "含有數字",
            ),
          ],
        ),
      ],
    );
  }

  Widget confirmPwdBuild() {
    return LabelInput(
      controller: ref.read(viewModelProvider.notifier).state.confirmPasswordController,
      label: "確認密碼",
      type: InputType.pwd,
      errMsg: [ref.read(viewModelProvider.notifier).state.confrimPwdErr],
    );
  }

  Widget idBuild() {
    return LabelInput(
      controller: ref.read(viewModelProvider.notifier).state.nameController,
      label: "名稱",
      errMsg: [ref.read(viewModelProvider.notifier).state.nameErr],
    );
  }
}
