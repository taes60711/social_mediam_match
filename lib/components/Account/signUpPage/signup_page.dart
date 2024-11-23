// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/utilities/common_scaffold.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/provider/account/signUpPage/sign_up_view_model.dart';

import '../../../services/firebase_service.dart';
import '../../utilities/inputField/label_input.dart';
import '../../utilities/style/style_config.dart';
import '../account_page_utilites.dart';
import 'signup_step_two.dart';

StateProvider<SignUpViewModel> viewModelProvider = StateProvider<SignUpViewModel>((ref) => SignUpViewModel());

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  @override
  void initState() {
    SignUpViewModel viewModel = SignUpViewModel(ref: ref, context: context, render: () => setState(() {}));
    Future.delayed(Duration.zero).then((_) {
      ref.read(viewModelProvider.notifier).update((state) => viewModel);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(16)),
        child: Column(
          children: [
            SizedBox(height: ScreenSize.fitPxWidth(50)),

            ///　Logo
            AccountPageUtilites().logo(),

            SizedBox(height: ScreenSize.fitPxWidth(20)),
            accountBuild(),
            SizedBox(height: ScreenSize.fitPxWidth(16)),

            ///
            AccountPageUtilites().btnContainer(
              onPress: () async {
                if (await ref.read(viewModelProvider.notifier).state.sendCaptchaMail()) {
                  SignUpStepTwoPage().show(context);
                }
              },
              btnText: "開始註冊",
            ),

            SizedBox(height: ScreenSize.fitPxWidth(16)),

            ///　Google登入
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
    );
  }
}
