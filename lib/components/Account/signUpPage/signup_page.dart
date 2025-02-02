// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/utilities/common_scaffold.dart';
import 'package:social_mediam_match/components/utilities/style/app_image.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import '../../utilities/inputField/label_input.dart';
import '../../utilities/style/app_colors.dart';
import '../account_main_page.dart';
import '../account_page_utilites.dart';
import 'signup_step_last.dart';
import 'signup_step_two.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(16)),
        child: Column(
          children: [
            SizedBox(height: ScreenSize.fitPxWidth(40)),

            ///　Logo
            AccountPageUtilites().logo(),

            SizedBox(height: ScreenSize.fitPxWidth(20)),
            accountBuild(),
            SizedBox(height: ScreenSize.fitPxWidth(16)),

            const Expanded(child: SizedBox(height: 1)),

            ///　普通登録
            AccountPageUtilites().btnContainer(
              onPress: () async {
                bool isSendOK = await ref.read(viewModelProvider.notifier).state.sendCaptchaMail();

                if (isSendOK) {
                  SignUpStepTwoPage().show(context);
                }
                setState(() {});
              },
              btnText: "開始註冊",
            ),

            SizedBox(height: ScreenSize.fitPxWidth(16)),

            ///　Google登録
            AccountPageUtilites().btnContainer(
              onPress: () async {
                bool isSendOK = await ref.read(viewModelProvider.notifier).state.googleSignUp();
                if (isSendOK) {
                  SignUpStepLastPage().show(context);
                }
              },
              imgIcon: AppImage.googleIcon,
              btnBgColor: AppColors.whiteColor,
              btnTextColor: AppColors.greyColor98,
              btnText: "Google註冊",
            ),

            SizedBox(height: ScreenSize.fitPxWidth(120)),
          ],
        ),
      ),
    );
  }

  Widget accountBuild() {
    return LabelInput(
      controller: ref.read(viewModelProvider.notifier).state.accountController,
      label: "Email",
      errMsg: [ref.read(viewModelProvider.notifier).state.emailErr],
    );
  }
}
