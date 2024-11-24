// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/components/utilities/common_scaffold.dart';
import 'package:social_mediam_match/components/utilities/main_button.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/global/lodaing_dialog.dart';

import '../../../services/firebase_service.dart';
import '../../utilities/inputField/label_input.dart';
import '../../utilities/style/style_config.dart';
import '../account_main_page.dart';
import '../account_page_utilites.dart';
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
            Align(
              alignment: Alignment.centerRight,
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
                      FontAwesomeIcons.arrowRight,
                      color: AppColors.whiteColor,
                    )),
              ),
            ),
            SizedBox(height: ScreenSize.fitPxWidth(20)),

            ///　Logo
            AccountPageUtilites().logo(),

            SizedBox(height: ScreenSize.fitPxWidth(20)),
            accountBuild(),
            SizedBox(height: ScreenSize.fitPxWidth(16)),

            ///　普通登録
            AccountPageUtilites().btnContainer(
              onPress: () async {
                LoadingDialog().show();
                bool isSendOK = await ref.read(viewModelProvider.notifier).state.sendCaptchaMail();
                LoadingDialog().close();
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
              onPress: () {
                FirebaseSerivce().signInWithGoogle();
              },
              imgIcon: 'assets/google_w_Logo.png',
              btnBgColor: AppColors.blueColor,
              btnText: "註冊",
            ),
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
